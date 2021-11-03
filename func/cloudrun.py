#Import Libries
from pydantic import BaseModel, Field
from fastapi import APIRouter
from google.cloud import storage
import pickle
import os

#Define url model
class UrlModel(BaseModel):
    url: str = Field(..., title="Site url", deprecated=False,
    description="The url to detect if its malicious or not")
    
#Initialize Fastapi
router = APIRouter()

#DEFINE VARIABLES
PROJECT_NAME=os.getenv("PROJECT_NAME")
BUCKET_NAME = os.getenv("BUCKET_NAME")
    
#SETUP BUCKET CONFIGURATIONS
client = storage.Client(project=PROJECT_NAME)
bucket = client.get_bucket(BUCKET_NAME)
blob = bucket.blob("model_1.pkl")
blob.download_to_filename("/tmp/model_1.pkl")
model_1 = pickle.load(open("/tmp/model_1.pkl","rb"))

#Define route to make prediction
@router.get("/")
async def home():
    return {
        "data":  {
                "title": "Malicious website detection",
                "type": "api",
                "version": "v1",
                "method": "POST",
                "route": "/api/v1/predict",
                "docs": "/docs",
                "input": "url"
            }
    }

@router.post("/api/v1/predict")
async def makePrediction(url: UrlModel):
    
    #CONVERT URL INTO DICTIONARY
    url = url.dict()
    
    #GET URL
    URL = url["url"]
    
    #MAKE PREDICTION
    make_prediction = model_1.predict([URL])
    
     #Return results
    if make_prediction[0] > 0.5:
        
        return {
            "message": "Url is not detected as malicious"
            }        
    else:
        return {
            "message": "Url contains malicious content"
            }
    