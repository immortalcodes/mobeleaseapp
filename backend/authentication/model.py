from pydantic import BaseModel
from datetime import datetime


class credentials(BaseModel):
    Email: str
    Password: str