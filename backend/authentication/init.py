import requests

from fastapi import APIRouter,status,Response, Cookie
from typing import Union


from .utils import *
from .model import *
from dbconnect import connection, cursor

authRouter = APIRouter()


# working
@authRouter.post("/login", status_code=200)
async def login(item: credentials, response: Response, access_token: Union[str, None] = Cookie(default=None)):   
    try:

        cursor.execute(
            f"SELECT 'employee.Email' from Employee where 'employee.Email' = '{item.Email}'"
        )
        email = cursor.fetchone()
        if email == '':
            response.status_code = status.HTTP_404_NOT_FOUND
            return {"message":"User not found"}
        return {"message" : "user found" }
    except Exception as e:
        print((e))
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {"message":"Error Encountered wile processing the request"}

