
from pydantic import BaseModel


class LogId(BaseModel):
    logId: int


class Image(BaseModel):
    filename: str
    image_base64: str

    

class ImageBast64(BaseModel):
    classs: str
    image_base64: str

    