import requests
from .utils import *
from .model import *

from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor

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


@invRouter.post("/viewallitem", status_code=200)
async def viewallItem(response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        cursor.execute("SELECT deviceid ,company, devicedetail, cost,storage,itemtype,remark from inventory ")
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

