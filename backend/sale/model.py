from pydantic import BaseModel
from typing import Optional, Union , List , Dict


class itemsarray(BaseModel):
    deviceid : int
    quantity : int
    sellprice : int

class saleobject(BaseModel):
    type : str
    customername : Optional[str] = None
    customeridimage : Optional[bytes] = None
    phoneno : Optional[str] = None
    language : Optional[str] = None
    unit : Optional[str] = None
    farm : Optional[str] = None
    itemarray : List[itemsarray]
    remark : Optional[str] = None
    paymentalert : int


class farm(BaseModel):
    farmname : str


class farmunit(BaseModel):
    farmname : str
    unitname : str


class viewsale(BaseModel):
    starttime : str
    endtime : str
    status : Optional[str] = '*all*'
    empid : Optional[str] = '*all*'
    saletype : Optional[str] = '*all*'