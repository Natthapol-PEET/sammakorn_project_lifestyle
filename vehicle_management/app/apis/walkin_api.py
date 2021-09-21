from fastapi import FastAPI, Depends, status, HTTPException
from fastapi.encoders import jsonable_encoder

from data.database import database as db
from data.schemas import WalkInRegister

from auth.auth import AuthHandler

from datetime import datetime
from base64 import b64decode

tags_metadata = [
    {"name": "Home Number", "description": ""},
    {"name": "Create Walk In", "description": ""},
]

auth_handler = AuthHandler()
walkin_api = FastAPI(openapi_tags=tags_metadata)


@walkin_api.get('/get_home_number', tags=['Home Number'], status_code=status.HTTP_200_OK)
async def GetHomeNumber(token=Depends(auth_handler.get_token)):
    if token == "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff":
        query = "SELECT home_number FROM home;"
        return await db.fetch_all(query)

    else:
        raise HTTPException(
            status_code=401, detail='Signature has expired')


@walkin_api.post("/walkin", tags=["Create Walk In"],  status_code=status.HTTP_201_CREATED)
async def WalkIn(walkin: WalkInRegister,  token=Depends(auth_handler.get_token)):
    if token == "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff":
        # create example image id_card.jpg
        imagePath = create_image(walkin.id_card, walkin.imageBase64)

        # create datetime of server
        xdatetime = create_datetime()

        query = f'''INSERT INTO walkin (firstname, lastname, id_card, gender, address, license_plate, goto_home_address, datetime_in, path_image, qr_gen_id)
                    VALUES ('{walkin.firstname}', '{walkin.lastname}', '{walkin.id_card}', '{walkin.gender}', '{walkin.address}', '{walkin.license_plate.replace(' ', '')}', '{walkin.goto_home_address}', '{xdatetime}', '{imagePath}', '{walkin.qrGenId}');'''
         
        return await db.execute(query)
        # return "ok"

    else:
        raise HTTPException(
            status_code=401, detail='Signature has expired')


def create_datetime():
    x = datetime.now()
    xdatetime = f"{x.year}-{x.month}-{x.day} {x.hour}:{x.minute}:{x.second}.{x.microsecond}"

    return xdatetime


def create_image(id_card, imageStr):
    imgdata = b64decode(imageStr)
    filename = f'images/{id_card}.jpg'

    with open(filename, 'wb') as f:
        f.write(imgdata)

    return filename
