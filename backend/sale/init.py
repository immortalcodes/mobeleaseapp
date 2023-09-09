import requests
import time
# from dotenv import dotenv_values
# from .utils import *
from .model import *

from fastapi import APIRouter,status,Response, Cookie
from typing import Union
from authentication.utils import decodeToken
from dbconnect import connection, cursor
# config = dotenv_values(".env")

saleRouter = APIRouter()


#adding device to the main inventory
@saleRouter.post("/additem", status_code=200)
async def addItem(item : item,response: Response,access_token: Union[str, None] = Cookie(default=None)):
     token = decodeToken(access_token)   
     if token and token['role'] == 'admin':
          pass