import uvicorn
from fastapi import FastAPI
from authentication.init import authRouter
from dbconnect import connection,cursor
from employee.init import empRouter

app = FastAPI()

app.include_router(authRouter, prefix="/auth")
app.include_router(empRouter, prefix="/emp")





try:
    cursor.execute("select version()")
    data = cursor.fetchone()
    print("Connection established to: ", data)

except Exception as e:
    print(e)


@app.get("/")
async def root():
    return {"message": "Hi there , I am sweet app"}






# if __name__=='main':
#     uvicorn.run("main:app",reload=True)

