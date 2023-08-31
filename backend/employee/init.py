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
            data[emp[0]] = {'empphoto':emp[1],
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
        cursor.execute("SELECT employeeid , employeephoto, firstname , lastname,phoneno,email from employee where employeeid = %s",item.empid)
        details = cursor.fetchone()
        data = {}
        for emp in details:
            data[emp[0]] = {'empphoto':emp[1],
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
     

