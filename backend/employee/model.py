from pydantic import BaseModel
from datetime import datetime


class employeeid(BaseModel):
    empid: int
    