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
          cursor.execute("INSERT into farmunit (farm) VALUES (%s)"(item.farmname,))
          connection.commit()
          response.status_code = status.HTTP_200_OK
          return {'data':'Farm added Successfully'}
  
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
                    cursor.execute("INSERT into devicesale (type,employeeid,unit,farm,itemarray,totalcost,totalsale,remark,timestamp,status,amountleft,paymentalert) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",(item.type, empid, item.unit,item.farm,Json(item.itemarray),totalcost,totalsale,item.remark,current_dt,'paid',0,0))






 cursor.execute("INSERT into devicesale (type,employeeid,customername,custome
                                   ridimage,phoneno,langauge,unit,farn,itemarray,
                                   totalcost,totalsale,remark,timestamp,status,amountleft,paymentalert) VALUES (%s,)",(item.type, empid, 'NULL',bytes('Null', 'utf-8'),'Null'
"NULL",)) 