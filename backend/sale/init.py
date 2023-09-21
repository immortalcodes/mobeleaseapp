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
          cursor.execute("INSERT INTO farm (farmname) VALUES ( %s ) ON CONFLICT (farmname)  DO NOTHING",(item.farmname,))
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
          cursor.execute("INSERT into farmunit (farmname,unitname) VALUES (%s,%s)",(item.farmname,item.unitname))
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
          cursor.execute("SELECT unitname from farmunit where farmname = %s",(item.farmname,))
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
     if token and token['role'] == 'employee':
          empid = token['empid']
          totalsale = 0
          totalcost = 0
          can_sell = True
          json_array = {}
          for ite in item.itemarray:
               json_array[ite.deviceid] = [ite.quantity,ite.sellprice]

          item.itemarray = json_array
          for ite in item.itemarray.keys():
               cursor.execute('SELECT quantity from assigndevice where employeeid = %s and deviceid = %s',(empid,int(ite)))
               qunat = cursor.fetchone()
               if qunat[0]<item.itemarray[ite][0] :
                    can_sell = False
                    break
          if can_sell == False :
               response.status_code = status.HTTP_200_OK
               return {'data':'Insufficent device in Inventory'}
          for ite in item.itemarray.keys():
               cursor.execute('SELECT quantity from assigndevice where employeeid = %s and deviceid = %s',(empid,int(ite)))
               qunat = cursor.fetchone()
               new_quant = qunat[0] -  item.itemarray[ite][0]
               cursor.execute('UPDATE  assigndevice SET quantity = %s where employeeid = %s and deviceid = %s',(new_quant,empid,int(ite)))
               connection.commit()               
               totalsale = totalsale + int(item.itemarray[ite][0]*item.itemarray[ite][1])
               cursor.execute("SELECT cost from inventory where deviceid = %s",(ite,))
               curr_cost  =  cursor.fetchone()
               totalcost = totalcost + int(int(curr_cost[0])*item.itemarray[ite][0])

          
          
          if item.type == "cash":
               current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
               cursor.execute("INSERT into devicesale (saletype,employeeid,unit,farm,itemarray,totalcost,totalsale,remark,timestamp,status,amountleft,paymentalert) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",(item.type, empid, item.unit,item.farm,Json(item.itemarray),totalcost,totalsale,item.remark,current_dt,'paid',0,0))
               response.status_code = status.HTTP_200_OK
               return {'data':'Cash Sale Completed Successfully'}
          elif item.type == "credit":
               current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
               cursor.execute("INSERT into devicesale (saletype,employeeid,customername,customeridimage,phoneno,language,unit,farm,itemarray,totalcost,totalsale,remark,timestamp,status,amountleft,paymentalert) VALUES  (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",(item.type, empid,item.customername,item.customeridimage,item.phoneno, item.language,item.unit,item.farm,Json(item.itemarray),totalcost,totalsale,item.remark,current_dt,'due',totalsale,1))
               response.status_code = status.HTTP_200_OK
               return {'data':'Credit Sale Completed Successfully'}
               
     
          
          connection.rollback()
          response.status_code = status.HTTP_400_BAD_REQUEST
          return {"message":"Error in making Sale"}
          
     else:
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"error in verifying token and permission"}



@saleRouter.post("/viewallsale", status_code=200)
async def viewallsale(item:viewsale,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token and token['role'] == 'employee':
          empid  = token['empid']
          cursor.execute("SELECT saleid,saletype,employeeid,customername,customeridimage,phoneno,language,unit,farm,itemarray,totalsale,remark,timestamp,status,amountleft,paymentalert from devicesale where (%s = '*all*' or status = %s) and (%s = '*all*' or saletype = %s) and employeeid = %s  and timestamp between %s and %s",(item.status,item.status,item.saletype,item.saletype,empid,item.starttime,item.endtime))
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
                    'language':sale[6],
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
          cursor.execute("SELECT saleid,saletype,employeeid,customername,customeridimage,phoneno,language,unit,farm,itemarray,totalsale,remark,timestamp,status,amountleft,paymentalert,totalcost from devicesale where (%s = '*all*' or employeeid = %s) and (%s = '*all*' or status = %s) and (%s = '*all*' or saletype = %s) and employeeid = %s  and timestamp between %s and %s ",(item.empid,item.empid,item.status,item.status,item.saletype,item.saletype,empid,item.starttime,item.endtime))
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
                    'language':sale[6],
                    'unit':sale[7],
                    'farm':sale[8],
                    'itemarray':sale[9],
                    'totalsale':sale[10],
                    'remark':sale[11],
                    'timestamp':sale[12],
                    'status':sale[13],
                    'amountleft':sale[14],
                    'paymentalert':sale[15],
                    'totalcost' : sale[16],
               }
          response.status_code = status.HTTP_200_OK
          return {'data':data}
     
     else:
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"error in verifying token and permission"}




@saleRouter.post("/addinstallment", status_code=200)
async def addinstallment(item:installment,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token and token['role'] == 'employee':
          empid = token["empid"]
          cursor.execute("SELECT EXISTS (select * from devicesale where employeeid = %s and saleid = %s)",(empid,item.saleid))
          iftrue = cursor.fetchone()
          if  iftrue[0]:
               if item.status == 'down':
                    cursor.execute("INSERT into creditinstallment (saleid,paymentdate,status,amountpaid) VALUES (%s,%s,%s,%s)",(item.saleid,item.paymentdate,item.status,item.amountpaid))
                    connection.commit()
                    cursor.execute("SELECT amountleft from devicesale where saleid = %s",(item.saleid,))
                    amountleft = cursor.fetchone()
                    amountleft = int(amountleft[0]) - item.amountpaid
                    if amountleft <= 0:
                         cursor.execute("UPDATE devicesale SET amountleft = 0 ,paymentalert = 0 , status= 'paid' where saleid = %s",(item.saleid,))
                    else:
                         cursor.execute("UPDATE devicesale SET amountleft = %s  where saleid = %s",(amountleft,item.saleid))
                    response.status_code = status.HTTP_200_OK
                    return {'data':"Installment Added Successfully"}

                    
               elif item.status == 'topay':
                    cursor.execute("INSERT into creditinstallment(saleid,deadline,status,promisedamount) VALUES (%s,%s,%s,%s)",(item.saleid,item.deadline,item.status,item.promisedamount))
                    connection.commit()
                    response.status_code = status.HTTP_200_OK
                    return {'data':"Installment Added Successfully"}
               elif item.status == 'paid':
                    cursor.execute("INSERT into creditinstallment (saleid,paymentdate,status,amountpaid) VALUES (%s,%s,%s,%s)",(item.saleid,item.paymentdate,item.status,item.amountpaid))
                    connection.commit()
                    cursor.execute("SELECT amountleft from devicesale where saleid = %s",(item.saleid,))
                    amountleft = cursor.fetchone()
                    amountleft = int(amountleft[0]) - item.amountpaid
                    if amountleft <= 0:
                         cursor.execute("UPDATE devicesale SET amountleft = 0 , paymentalert = 0 , status= 'paid' where saleid = %s",(item.saleid,))
                    else:
                         cursor.execute("UPDATE devicesale SET amountleft = %s  where saleid = %s",(amountleft,item.saleid))
                    response.status_code = status.HTTP_200_OK
                    return {'data':"Installment Added Successfully"}
               else :
                    response.status_code = status.HTTP_400_BAD_REQUEST
                    return {"message":"Invalid status provided"}

          else :
               response.status_code = status.HTTP_404_NOT_FOUND
               return {"message":"Permission doesn't exist for this sale"}


     else :
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"error in verifying token and permission"}
     







@saleRouter.post("/updateinstallment", status_code=200)
async def updateinstallment(item:alterinstallment,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token and token['role'] == 'employee':
          empid = token["empid"]
          cursor.execute("SELECT EXISTS (select * from devicesale where employeeid = %s and saleid = %s)",(empid,item.saleid))
          iftrue =  cursor.fetchone()
          if iftrue[0]:
               cursor.execute("SELECT status,promisedamount from creditinstallment where installmentid = %s",(item.installmentid,))
               status0 = cursor.fetchone()
               prom_amt = status0[1]
               status0 = status0[0]
               if status0 == 'delay':
                    if item.status == 'void':
                         cursor.execute("UPDATE creditinstallment SET status = 'delay_void' where installmentid = %s",(item.installmentid,))
                         response.status_code = status.HTTP_200_OK
                         return {'data':"Installment Altered Successfully"}
                    elif item.status == 'pay':
                         if prom_amt > item.amountpaid:
                              cursor.execute("UPDATE creditinstallment SET status = 'delay_paidless',amountpaid = %s, paymentdate = %s  where installmentid = %s",(item.amountpaid,item.paymentdate,item.installmentid,))
                              cursor.execute("SELECT amountleft from devicesale where saleid = %s",(item.saleid,))
                              amountleft = cursor.fetchone()
                              amountleft = int(amountleft[0]) - item.amountpaid
                              if amountleft <= 0:
                                   cursor.execute("UPDATE devicesale SET amountleft = 0 ,paymentalert = 0 , status= 'paid' where saleid = %s",(item.saleid,))
                              else:
                                   cursor.execute("UPDATE devicesale SET amountleft = %s  where saleid = %s",(amountleft,item.saleid))
                              response.status_code = status.HTTP_200_OK
                              return {'data':"Installment Altered Successfully"}
                         else :
                              cursor.execute("UPDATE creditinstallment SET status = 'delay_paid',amountpaid = %s, paymentdate = %s  where installmentid = %s",(item.amountpaid,item.paymentdate,item.installmentid,))
                              cursor.execute("SELECT amountleft from devicesale where saleid = %s",(item.saleid,))
                              amountleft = cursor.fetchone()
                              amountleft = int(amountleft[0]) - item.amountpaid
                              if amountleft <= 0:
                                   cursor.execute("UPDATE devicesale SET amountleft = 0 ,paymentalert = 0 , status= 'paid' where saleid = %s",(item.saleid,))
                              else:
                                   cursor.execute("UPDATE devicesale SET amountleft = %s  where saleid = %s",(amountleft,item.saleid))
                              response.status_code = status.HTTP_200_OK
                              return {'data':"Installment Altered Successfully"}
               elif status0 == 'topay':
                    if item.status == 'void':
                         cursor.execute("UPDATE creditinstallment SET status = 'void' where installmentid = %s",(item.installmentid,))
                         response.status_code = status.HTTP_200_OK
                         return {'data':"Installment Altered Successfully"}
                    elif item.status == 'pay':
                         if prom_amt > item.amountpaid:
                              cursor.execute("UPDATE creditinstallment SET status = 'paidless',amountpaid = %s, paymentdate = %s  where installmentid = %s",(item.amountpaid,item.paymentdate,item.installmentid,))
                              cursor.execute("SELECT amountleft from devicesale where saleid = %s",(item.saleid,))
                              amountleft = cursor.fetchone()
                              amountleft = int(amountleft[0]) - item.amountpaid
                              if amountleft <= 0:
                                   cursor.execute("UPDATE devicesale SET amountleft = 0 ,paymentalert = 0 , status= 'paid' where saleid = %s",(item.saleid,))
                              else:
                                   cursor.execute("UPDATE devicesale SET amountleft = %s  where saleid = %s",(amountleft,item.saleid))
                              response.status_code = status.HTTP_200_OK
                              return {'data':"Installment Altered Successfully"}
                         else :
                              cursor.execute("UPDATE creditinstallment SET status = 'paid',amountpaid = %s, paymentdate = %s  where installmentid = %s",(item.amountpaid,item.paymentdate,item.installmentid,))
                              cursor.execute("SELECT amountleft from devicesale where saleid = %s",(item.saleid,))
                              amountleft = cursor.fetchone()
                              amountleft = int(amountleft[0]) - item.amountpaid
                              if amountleft <= 0:
                                   cursor.execute("UPDATE devicesale SET amountleft = 0 ,paymentalert = 0 , status= 'paid' where saleid = %s",(item.saleid,))
                              else:
                                   cursor.execute("UPDATE devicesale SET amountleft = %s  where saleid = %s",(amountleft,item.saleid))
                              response.status_code = status.HTTP_200_OK
                              return {'data':"Installment Altered Successfully"}
                         

          else :
               response.status_code = status.HTTP_404_NOT_FOUND
               return {"message":"Permission doesn't exist for this sale"}


     else :
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"error in verifying token and permission"}

@saleRouter.post("/viewinstallment", status_code=200)
async def viewinstallment(item:saleid,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token) 
     if token :
          empid = token["empid"]
          cursor.execute("SELECT * from devicesale where employeeid = %s and saleid = %s",(empid,item.saleid))
          res = cursor.fetchone()
          if token["role"] == "employee":     
               if res == set():
                    response.status_code = status.HTTP_403_FORBIDDEN
                    return {"message":"Permission not Granted"}
               
          cursor.execute("SELECT * from creditinstallment where  saleid = %s",(item.saleid,))
          all_installments = cursor.fetchall()
          data = {}
          with open('photocustomer.jpg', 'wb') as photo_file:
                    if res[4]:
                        photo_file.write(res[4])
          if res[4]:
               with open('photocustomer.jpg', 'rb') as photo_file:
                        photodata = photo_file.read()
          else:
                    photodata = None
          if token["role"] == "admin":
               data["saledetails"] = {
                    'saleid': res[0],
                    'saletype':res[1],
                    'employeeid':res[2],
                    'customername':res[3],
                    'customeridimage':photodata,
                    'phoneno':res[5],
                    'language':res[6],
                    'unit':res[7],
                    'farm':res[8],
                    'itemarray':res[9],
                    'totalsale': res[11],
                    'remark':res[12],
                    'timestamp':res[13],
                    'status':res[14],
                    'amountleft':res[15],
                    'paymentalert':res[16],
                    'totalcost' : res[10],
               }
          else:
               data["saledetails"] = {
                    'saleid': res[0],
                    'saletype':res[1],
                    'employeeid':res[2],
                    'customername':res[3],
                    'customeridimage':photodata,
                    'phoneno':res[5],
                    'language':res[6],
                    'unit':res[7],
                    'farm':res[8],
                    'itemarray':res[9],
                    'totalsale': res[11],
                    'remark':res[12],
                    'timestamp':res[13],
                    'status':res[14],
                    'amountleft':res[15],
                    'paymentalert':res[16],
               }
          installments = {}
          for installment in all_installments:
               installments[installment[0]] = {
                    'saleid': installment[1],
                    'deadline': installment[2],
                    'paymentdate': installment[3],
                    'status': installment[4],
                    'promisedamount': installment[5],
                    'amountpaid':installment[6],
               }
          data["installments"] = installments
          response.status_code = status.HTTP_200_OK
          return {'data':data}
     else :
          response.status_code = status.HTTP_403_FORBIDDEN
          return {"message":"Permission not Granted"}
          