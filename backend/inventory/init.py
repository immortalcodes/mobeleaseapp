import requests
from .utils import *
from .model import *

from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor

invRouter = APIRouter()



@invRouter.post("/allemployee", status_code=200)
async def viewallEmployee(response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
        cursor.execute("SELECT employeeid , employeephoto, firstname , lastname,phoneno,email from employee ")
        details = cursor.fetchall()
        x = details[1][1]
        print(x)
        data = {}
        for emp in details: