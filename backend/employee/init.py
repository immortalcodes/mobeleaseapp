import requests
from .utils import *
from .model import *

from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor

empRouter = APIRouter()


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
async def viewallEmployee(item:employeeid,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
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
            cursor.execute("INSERT INTO employee (firstname, lastname, phoneno,password,email,employeephoto) VALUES (%s, %s,%s, %s,%s, %s)",(item.name,item.lastname,item.phoneno,item.email,item.password,item.employeephoto))
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
                if item.password == None:
                    cursor.execute("UPDATE employee SET firstname=%s, lastname=%s, phoneno=%s,email=%s,employeephoto=%s where employeeid = %s",(item.name,item.lastname,item.phoneno,item.email,item.employeephoto,item.empid))
                    connection.commit()

                    response.status_code = status.HTTP_200_OK
                    return {'data':'Employee Edited Successfully'}
                else:
                    cursor.execute("UPDATE employee SET firstname=%s, lastname=%s, password=%s, phoneno=%s,email=%s,employeephoto=%s where employeeid = %s",(item.name,item.lastname,item.password,item.phoneno,item.email,item.employeephoto,item.empid))
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
     

