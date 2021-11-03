#Import Libries
from fastapi import FastAPI
from func import cloudrun
from fastapi.middleware.cors import CORSMiddleware

#Initialize FastAPI
app = FastAPI()

#Set origin
origins = ["*"]

#Add cross origin resource sharing
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

#Add route
app.include_router(cloudrun.router)