from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class item(BaseModel):
    itemtype: str
    company: str
    devicedetail : str
    cost : str
    storage : Optional[str] = None
    remark : Optional[str] = None
    