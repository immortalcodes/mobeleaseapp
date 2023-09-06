from pydantic import BaseModel
from typing import Optional, Union , List


class item(BaseModel):
    itemtype: str
    company: str
    devicedetail : str
    cost : str
    storage : Optional[str] = None
    remark : Optional[str] = None

class inv(BaseModel):
    deviceid : int
    quantity : int

class assign(BaseModel):
    empid: int
    devices : List[inv]

class emp(BaseModel):
    empid : int 

class itemid(BaseModel):
    deviceid = int
    
