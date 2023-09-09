import uvicorn
from fastapi import FastAPI
from authentication.init import authRouter
from dbconnect import connection,cursor
from employee.init import empRouter
from inventory.init import invRouter
from sale.init import saleRouter

app = FastAPI()

app.include_router(authRouter, prefix="/auth")
app.include_router(empRouter, prefix="/emp")
app.include_router(invRouter, prefix="/inv")
app.include_router(saleRouter, prefix="/sale")





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

