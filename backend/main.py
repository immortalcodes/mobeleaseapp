import psycopg2

from fastapi import FastAPI
from dotenv import dotenv_values

from authentication.init import authRouter

config = dotenv_values(".env")

app = FastAPI()

app.include_router(authRouter, prefix="/auth")



#Connecting to Database
try:
    connection = psycopg2.connect(
        database=config["DBName"],
        user=config["DBUsername"],
        password=config["DBPwd"],
        host=config["DBHost"],
        port=config["DBPort"],
    )
    cursor = connection.cursor()

except Exception as e:
    print(e)


try:
    cursor.execute("select version()")
    data = cursor.fetchone()
    print("Connection established to: ", data)

except Exception as e:
    print(e)


@app.get("/")
async def root():
    return {"message": "Hi there , I am sweet app"}

