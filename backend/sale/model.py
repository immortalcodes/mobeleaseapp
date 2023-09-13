from pydantic import BaseModel
from typing import Optional, Union , List



class saleobject(BaseModel):
    type : str
    customername : Optional[str] = None
    customeridimage : Optional[bytes] = None
    phoneno : Optional[str] = None
    language : Optional[str] = None
    unit : Optional[str] = None
    farm : Optional[str] = None
    itemarray : dict
    remark : Optional[str] = None
    paymentalert : int


class farm(BaseModel):
    farmname : str


class farmunit(BaseModel):
    farmid : int
    unitname : str
