
import psycopg2
import dotenv

from dotenv import dotenv_values


config = dotenv_values(".env")
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
    connection.autocommit = True
except Exception as e:
    print(e)