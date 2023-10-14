from zoneinfo import ZoneInfo
from datetime import datetime , date 


import dotenv
from dotenv import dotenv_values


import psycopg2


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


def updateinstallments():
    try:
        cursor.execute("Update creditinstallments set status = 'delay' where status = 'topay' and deadline < %s",(datetime.now(tz=ZoneInfo(config["TimeZone"])),))
        connection.commit()
    except Exception as e:
        print(e)
        


# dt_string = "12/06/2021 09:15:32"

# # Convert string to datetime object
# dt_object = datetime.strptime(dt_string, "%d/%m/%Y %H:%M:%S")
# print(dt_object>nowdate)




