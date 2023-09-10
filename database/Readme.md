# Commands to use the database-

## To create image  and run the container:
- `sudo ./build.bat`  after giving executable permissions to build.bat

## IMP : To get the tables and data in database -
- After you run build.bat  , an interactive terminal will open and there you need to enter the command `pg_restore -U admin -Ft -d mobelease < mydb.tar`


## To connect to Database Container through Terminal:

- sudo docker exec -it dbcont bash
- psql "dbname=mobelease  user=admin password=admin1234 port=5432 "

## To connect to Database Container through PGadmin:
- enter the following credentials
- username = admin
- password =  admin1234
- database = mobelease
- host = localhost
