import requests

from fastapi import APIRouter,status,Response, Cookie
from typing import Union


from .utils import *
from .model import *
from dbconnect import connection, cursor

authRouter = APIRouter()



@authRouter.post("/login", status_code=200)
async def login(item: credentials, response: Response):#:access_token: Union[str, None] = Cookie(default=None)):   
    try:
        if item.role ==  'admin':
            token =  verifyPassword(item.email,item.password,item.role)
            if token:
                    response.status_code = status.HTTP_200_OK
                    response.set_cookie(key="access_token", value=token, samesite="Lax", secure=False)

                    return {"data": {
                        'token' : token
                    }}
            else:
                    response.status_code = status.HTTP_401_UNAUTHORIZED
                    return {'message':'Invalid Credentials'}
        elif item.role ==  'employee':
            cursor.execute("SELECT email from employee where email=%s",(item.email,))
            email = cursor.fetchone()
            if email == None:
                response.status_code = status.HTTP_404_NOT_FOUND
                return {"message":"User not found"}
            else:

                token =  verifyPassword(item.email,item.password,item.role)
                if token:
                    response.status_code = status.HTTP_200_OK
                    response.set_cookie(key="access_token", value=token, samesite="Lax", secure=False)

                    return {"data": {
                        'token' : token
                    }}
                else:
                    response.status_code = status.HTTP_401_UNAUTHORIZED
                    return {'message':'Invalid Credentials'}
        else:
            response.status_code = status.HTTP_404_NOT_FOUND
            return {"message":"Invalid Role"}

    except Exception as e:
        print((e))
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {"message":"Error Encountered wile processing the request"}



@authRouter.post("/verifyuser", status_code=200)
async def verifyUser(response: Response,access_token: Union[str, None] = Cookie(default=None)):
     res = decodeToken(access_token)   
     if res:
        response.status_code = status.HTTP_200_OK
        return {'data':{
          'role': res['role'],
          'empid': None if 'empid' not in res.keys() else res['empid'],
             }}
     else:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"message":"error in verifying token"}
          
