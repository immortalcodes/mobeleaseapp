from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class employeeid(BaseModel):
    empid: int

class employee(BaseModel):
    empid : Optional[int] = None
    firstname : str
    lastname : str
    phoneno : Optional[str] = None
    email : str
    password : str 
    employeephoto : Optional[bytes] = None
    