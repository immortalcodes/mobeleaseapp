import requests
import time
from dotenv import dotenv_values
from .utils import *
from .model import *

from zoneinfo import ZoneInfo
from datetime import datetime
from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor
config = dotenv_values(".env")

invRouter = APIRouter()


#adding device to the main inventory
@invRouter.post("/additem", status_code=200)
async def addItem(item : item,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        try:
            cursor.execute("INSERT INTO inventory (company, devicedetail, cost,storage,itemtype,remark ) VALUES (%s, %s,%s, %s,%s, %s)",(item.company,item.devicedetail,item.cost,item.storage,item.itemtype,item.remark))
            connection.commit()
            response.status_code = status.HTTP_200_OK
            return {'data':'Item added Successfully'}
        except:
            connection.rollback()
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message":"Error in adding item"}

     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}

@invRouter.post("/deleteitem", status_code=200)
async def deleteItem(item :itemid,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
            cursor.execute("UPDATE  inventory SET inuse='0' WHERE deviceid = %s",(item.deviceid,))
            response.status_code = status.HTTP_200_OK
            return {'data': 'Deleted Successfully'}
  
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     


@invRouter.post("/viewallitem", status_code=200)
async def viewallItem(response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        cursor.execute("SELECT deviceid ,company, devicedetail, cost,storage,itemtype,remark from inventory where inuse = '1' ")
        details = cursor.fetchall()
        data = {}
        for device in details:
            if device[5] not in data.keys():
                data[device[5]] = [
                    {
                        'deviceid':device[0],
                        'company':device[1],
                        'devicedetail':device[2],
                        'cost':device[3],
                        'storge':device[4],
                        'remark':device[6],
                    },
                ]
            else:
                data[device[5]].append({
                        'deviceid':device[0],
                        'company':device[1],
                        'devicedetail':device[2],
                        'cost':device[3],
                        'storge':device[4],
                        'remark':device[6],
                    })

        response.status_code = status.HTTP_200_OK
        return {'data':data}
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}


@invRouter.post("/assign", status_code=200)
async def assignInv(item:assign,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        try:
            connection.autocommit = False
            for device in item.devices:
                india_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
                cursor.execute("INSERT INTO assigndevice (employeeid,deviceid,quantity,timestamp) VALUES (%s, %s,%s, %s)",(item.empid,device.deviceid,device.quantity,india_dt))
            connection.commit()
            response.status_code = status.HTTP_200_OK
            return {'data' : "Assigned Successfully"}



        except:
            connection.rollback()
        finally:
            connection.autocommit = True
    
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     


@invRouter.post("/viewassign", status_code=200)
async def viewInv(item:emp,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)
     if token and (token['role'] == 'admin' or (token['role'] == 'employee' and token['empid'] == item.empid ) ) :
         cursor.execute("Select * from assigndevice where employeeid = %s",(item.empid,))
         records = cursor.fetchall()
         data ={'empid':item.empid , 'devices': []}
         for device in records:
             details = {}
             cursor.execute("Select * from inventory where deviceid = %s",(device[2],))
             specs = cursor.fetchone()
             details['quantity'] = device[3]
             details['quantity'] = device[3]
             details['deviceid'] = device[2]
             details['company'] = specs[1]
             details['Name'] = specs[2]
             details['Storage'] = specs[4]
             details['ItemType'] = specs[5]
             data['devices'].append(details)
         response.status_code = status.HTTP_200_OK
         return {'data':data}
            
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
         

@invRouter.post("/editassign", status_code=200)
async def editInv(item:assign,response: Response,access_token: Union[str, None] = Cookie(default=None)):
    token = decodeToken(access_token) 
    if token and token['role'] == 'admin':
        cursor.execute("DELETE FROM assigndevice  WHERE employeeid = %s",(item.empid,))
        connection.commit()
        try:
            connection.autocommit = False
            for device in item.devices:
                india_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
                cursor.execute("INSERT INTO assigndevice (employeeid,deviceid,quantity,timestamp) VALUES (%s, %s,%s, %s)",(item.empid,device.deviceid,device.quantity,india_dt))
            connection.commit()
            response.status_code = status.HTTP_200_OK
            return {'data' : "Assign Edited Successfully"}
        except:
            
            connection.rollback()
        finally:
            connection.autocommit = True
    
    else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}

         
 

         

