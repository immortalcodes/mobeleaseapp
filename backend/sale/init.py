import requests
import time

from zoneinfo import ZoneInfo
from datetime import datetime
from dotenv import dotenv_values
# from .utils import *
from .model import *

from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor
from psycopg2.extras import Json

config = dotenv_values(".env")

saleRouter = APIRouter()





@saleRouter.post("/addfarm", status_code=200)
async def addFarm(item:farm ,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token :
          cursor.execute("INSERT INTO farm (farmname) VALUES ( %s ) ON CONFLICT (farmname) DO NOTHING"(item.farmname,))
          connection.commit()
          response.status_code = status.HTTP_200_OK
          return {'data':'Farm added Successfully'}
  
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     

@saleRouter.post("/addfarmunit", status_code=200)
async def addFarmUnit(item:farmunit ,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token :
          cursor.execute("INSERT into farmunit (farmname,unitname) VALUES (%s,%s)"(item.farmname,item.unitname))
          connection.commit()
          response.status_code = status.HTTP_200_OK
          return {'data':'Farm and Unit added Successfully'}
  
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     

@saleRouter.post("/viewfarm", status_code=200)
async def viewFarm(response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token :
          cursor.execute("SELECT farmname from farm")
          farm_list = cursor.fetchall()
          response.status_code = status.HTTP_200_OK
          return {'data': farm_list}
  
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     
@saleRouter.post("/viewfarmunit", status_code=200)
async def viewFarmUnit(item:farm, response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token :
          cursor.execute("SELECT unitname from farmunit where farmname = %s",(item.farmname))
          unit_list = cursor.fetchall()
          response.status_code = status.HTTP_200_OK
          return {'data': unit_list}
  
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}

#adding device to the main inventory
@saleRouter.post("/makesale", status_code=200)
async def makesale(item:saleobject,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token and token['role'] == 'emp':
          empid = token['empid']
          totalsale = 0
          totalcost = 0
          for ite in item.itemarray.keys():
               totalsale = totalsale + int(item.itemarray[ite][0]*item.itemarray[ite][1])
               cursor.execute("SELECT cost from inventory where deviceid = %s",(ite,))
               curr_cost  =  cursor.fetchone()
               totalcost = totalcost + int(curr_cost*item.itemarray[ite][0])

          
          try :
               if item.type == "cash":
                    current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
                    cursor.execute("INSERT into devicesale (saletype,employeeid,unit,farm,itemarray,totalcost,totalsale,remark,timestamp,status,amountleft,paymentalert) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",(item.type, empid, item.unit,item.farm,Json(item.itemarray),totalcost,totalsale,item.remark,current_dt,'paid',0,0))
                    response.status_code = status.HTTP_200_OK
                    return {'data':'Cash Sale Completed Successfully'}
               elif item.type == "credit":
                    current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
                    cursor.execute("INSERT into devicesale (saletype,employeeid,customername,customeridimage,phoneno,langauge,unit,farm,itemarray,totalcost,totalsale,remark,timestamp,status,amountleft,paymentalert) VALUES  (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",(item.type, empid,item.customername,item.customeridimage,item.phoneno, item.language,item.unit,item.farm,Json(item.itemarray),totalcost,totalsale,item.remark,current_dt,'due',totalsale,1))
                    response.status_code = status.HTTP_200_OK
                    return {'data':'Credit Sale Completed Successfully'}
                    
          except :
            
               connection.rollback()
               response.status_code = status.HTTP_400_BAD_REQUEST
               return {"message":"Error in making Sale"}
          
     else:
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"error in verifying token and permission"}



@saleRouter.post("/viewallsale", status_code=200)
async def viewallsale(item:viewsale,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token and token['role'] == 'emp':
          empid  = token['empid']
          cursor.execute("SELECT saleid,saletype,employeeid,customername,customeridimage,phoneno,langauge,unit,farm,itemarray,totalsale,remark,timestamp,status,amountleft,paymentalert from devicesale where (%s = Null or status = %s) and (%s = Null or saletype = %s) and employeeid = %s  and timestamp between %s and %s';",(item.status,item.status,item.saletype,item.saletype,empid,item.starttime,item.endtime))
          sales = cursor.fetchall()
          data = {}
          for sale in sales:
               with open('photocustomer.jpg', 'wb') as photo_file:
                    if sale[4]:
                        photo_file.write(sale[4])
               if sale[4]:
                    with open('photocustomer.jpg', 'rb') as photo_file:
                        photodata = photo_file.read()
               else:
                    photodata = None
               data[sale[0]] = {
                    'saletype':sale[1],
                    'employeeid':sale[2],
                    'customername':sale[3],
                    'customeridimage':photodata,
                    'phoneno':sale[5],
                    'langauge':sale[6],
                    'unit':sale[7],
                    'farm':sale[8],
                    'itemarray':sale[9],
                    'totalsale':sale[10],
                    'remark':sale[11],
                    'timestamp':sale[12],
                    'status':sale[13],
                    'amountleft':sale[14],
                    'paymentalert':sale[15],
               }
          response.status_code = status.HTTP_200_OK
          return {'data':data}

     elif token and token['role'] == 'admin':
          cursor.execute("SELECT saleid,saletype,employeeid,customername,customeridimage,phoneno,langauge,unit,farm,itemarray,totalsale,remark,timestamp,status,amountleft,paymentalert from devicesale where (%s = Null or employeeid = %s) and (%s = Null or status = %s) and (%s = Null or saletype = %s) and employeeid = %s  and timestamp between %s and %s';",(item.empid,item.empid,item.status,item.status,item.saletype,item.saletype,empid,item.starttime,item.endtime))
          sales = cursor.fetchall()
          data = {}
          for sale in sales:
               with open('photocustomer.jpg', 'wb') as photo_file:
                    if sale[4]:
                        photo_file.write(sale[4])
               if sale[4]:
                    with open('photocustomer.jpg', 'rb') as photo_file:
                        photodata = photo_file.read()
               else:
                    photodata = None
               data[sale[0]] = {
                    'saletype':sale[1],
                    'employeeid':sale[2],
                    'customername':sale[3],
                    'customeridimage':photodata,
                    'phoneno':sale[5],
                    'langauge':sale[6],
                    'unit':sale[7],
                    'farm':sale[8],
                    'itemarray':sale[9],
                    'totalsale':sale[10],
                    'remark':sale[11],
                    'timestamp':sale[12],
                    'status':sale[13],
                    'amountleft':sale[14],
                    'paymentalert':sale[15],
               }
          response.status_code = status.HTTP_200_OK
          return {'data':data}
     
     else:
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"error in verifying token and permission"}




@saleRouter.post("/addinstallment", status_code=200)
async def addinstallment(item:saleobject,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token and token['role'] == 'emp':
          pass



