import requests
from .utils import *
from .model import *
from zoneinfo import ZoneInfo
from datetime import datetime
from dotenv import dotenv_values

from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor

empRouter = APIRouter()
config = dotenv_values(".env")



@empRouter.post("/allemployee", status_code=200)
async def viewallEmployee(response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        cursor.execute("SELECT employeeid , employeephoto, firstname , lastname,phoneno,email from employee ")
        details = cursor.fetchall()
        data = {}
        for emp in details:
            with open('photo.jpg', 'wb') as photo_file:
                if emp[1]:
                    photo_file.write(emp[1])
            if emp[1]:
                with open('photo.jpg', 'rb') as photo_file:
                    photodata = photo_file.read()
            else:
                photodata = None
            data[emp[0]] = {'empphoto':photodata,
                          'firstname':emp[2],
                          'lastname':emp[3],
                          'phoneno':emp[4],
                          'email':emp[5],
                          }

        response.status_code = status.HTTP_200_OK
        return {'data':data}
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}



@empRouter.post("/singleemployee", status_code=200)
async def viewsingleEmployee(item:employeeid,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and (token['role'] == 'admin' or (token['role'] == 'employee' and item.empid == token['empid'])):
        try:
            print('f1')
            cursor.execute("SELECT employeeid , employeephoto, firstname , lastname,phoneno,email from employee where employeeid = %s",(item.empid,))
            emp = cursor.fetchone()
            if emp:
                with open('photo.jpg', 'wb') as photo_file:
                    if emp[1]:
                        photo_file.write(emp[1])
                if emp[1]:
                    with open('photo.jpg', 'rb') as photo_file:
                        photodata = photo_file.read()
                else:
                    photodata = None
                data = {}
                data[emp[0]] = {'empphoto':photodata,
                                'firstname':emp[2],
                                'lastname':emp[3],
                                'phoneno':emp[4],
                                'email':emp[5],
                                }

                response.status_code = status.HTTP_200_OK
                return {'data' : data }
            else:
                return {'message':'does not exists'}
        except Exception as e:
            print(e)
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message":"Error in fetching details"}


     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     

@empRouter.post("/createemployee", status_code=200)
async def createEmployee(item:employee,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        try:
            cursor.execute("INSERT INTO employee (firstname, lastname, phoneno,password,email,employeephoto) VALUES (%s, %s,%s, %s,%s, %s)",(item.firstname,item.lastname,item.phoneno,item.email,item.password,item.employeephoto))
            emp = connection.commit()

            response.status_code = status.HTTP_200_OK
            return {'data':'Employee Created Successfully'}
        except :
            
            connection.rollback()
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message":"Error in Creating Employee"}


     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     

@empRouter.post("/editemployee", status_code=200)
async def editEmployee(item:employee,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        
        if item.empid:

            try:
                if item.password == '**nochange**':
                    cursor.execute("UPDATE employee SET firstname=%s, lastname=%s, phoneno=%s,email=%s,employeephoto=%s where employeeid = %s",(item.firstname,item.lastname,item.phoneno,item.email,item.employeephoto,item.empid))
                    connection.commit()

                    response.status_code = status.HTTP_200_OK
                    return {'data':'Employee Edited Successfully'}
                else:
                    cursor.execute("UPDATE employee SET firstname=%s, lastname=%s, password=%s, phoneno=%s,email=%s,employeephoto=%s where employeeid = %s",(item.firstname,item.lastname,item.password,item.phoneno,item.email,item.employeephoto,item.empid))
                    connection.commit()

                    response.status_code = status.HTTP_200_OK
                    return {'data':'Employee Edited Successfully'}
            except Exception as e:
                connection.rollback()
                print(e)
                response.status_code = status.HTTP_400_BAD_REQUEST
                return {"message":"Error in Editing Employee details"}


     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
     

@empRouter.post("/addremark", status_code=200)
async def addRemark(item:remark,response: Response,access_token: Union[str, None] = Cookie(default=None)):
    token = decodeToken(access_token)   
    if token and (token['role'] == 'admin'):
        current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
        cursor.execute("INSERT into remark(employeeid,remark,initiater,remarktimestamp) VALUES (%s,%s,%s,%s)",(item.empid,item.remark,'admin',current_dt))
        response.status_code = status.HTTP_200_OK
        return {'data':'Remark Added Successfully'}
    elif token and (token['role'] == 'employee'):
        empid = token['empid']
        current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
        cursor.execute("INSERT into remark(employeeid,remark,initiater,remarktimestamp) VALUES (%s,%s,%s,%s)",(empid,item.remark,'employee',current_dt))
        response.status_code = status.HTTP_200_OK
        return {'data':'Remark Added Successfully'}
    else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}
    

@empRouter.post("/addreply", status_code=200)
async def addRemark(item:reply,response: Response,access_token: Union[str, None] = Cookie(default=None)):
    token = decodeToken(access_token)   
    if token and (token['role'] == 'admin'):
        current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
        cursor.execute("UPDATE  remark SET reply= %s , replytimestamp=%s where remarkid = %s and initiater = 'employee'",(item.reply,current_dt,item.remarkid))
        response.status_code = status.HTTP_200_OK
        return {'data':'Reply Added Successfully'}
    elif token and (token['role'] == 'employee'):
        empid = token['empid']
        current_dt = datetime.now(tz=ZoneInfo(config["TimeZone"]))
        cursor.execute("UPDATE  remark SET reply= %s , replytimestamp=%s where remarkid = %s and initiater = 'admin' and employeeid = %s",(item.reply,current_dt,item.remarkid,empid))
        response.status_code = status.HTTP_200_OK
        return {'data':'Reply Added Successfully'}
    else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}



@empRouter.post("/viewremarks", status_code=200)
async def viewremarks(item:employeeid,response: Response,access_token: Union[str, None] = Cookie(default=None)):
    token = decodeToken(access_token)   
    if token and (token['role'] == 'admin'):
        cursor.execute("SELECT * from remark where employeeid = %s ORDER BY remarktimestamp",(item.empid,))
        all_remarks = cursor.fetchall()
        data = {}
        for remark in all_remarks:
            data[remark[0]] = {
                'remark':remark[2],
                'reply':remark[3],
                'initiater':remark[4],
                'remarktimestamp':remark[5],
                'replytimestamp':remark[6],
            }
        response.status_code = status.HTTP_200_OK
        return {'data':data}
    elif token and (token['role'] == 'employee'):
        empid = token['empid']
        cursor.execute("SELECT * from remark where employeeid = %s ORDER BY remarktimestamp",(empid,))
        all_remarks = cursor.fetchall()
        data = {}
        for remark in all_remarks:
            data[remark[0]] = {
                'remark':remark[2],
                'reply':remark[3],
                'initiater':remark[4],
                'remarktimestamp':remark[5],
                'replytimestamp':remark[6],
            }
        response.status_code = status.HTTP_200_OK
        return {'data':data}
    else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token and permission"}