from pydantic import BaseModel
from datetime import datetime


class credentials(BaseModel):
    email: str
    password: str
    role : str