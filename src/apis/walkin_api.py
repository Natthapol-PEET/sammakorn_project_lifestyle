# from fastapi import FastAPI, Depends, status, HTTPException
# from fastapi.datastructures import UploadFile
# from fastapi.encoders import jsonable_encoder
# from utils.face_detection import faceDetectionAndRotate
# from utils.scan_document import scanDocument

# from data.schemas import CropImage, CropImageResponse
# from data.database import database as db
# from data.schemas import WalkInRegister

# from auth.auth import AuthHandler

# from datetime import datetime
# import base64
# import io
# import numpy as np
# from PIL import Image
# import cv2

# tags_metadata = [
#     {"name": "Home Number", "description": ""},
#     {"name": "Create Walk In", "description": ""},
# ]

# auth_handler = AuthHandler()
# walkin_api = FastAPI(openapi_tags=tags_metadata)

# @walkin_api.post("/croping_cardimage/", response_model=CropImageResponse, status_code=201)
# async def crop_card_image(data: CropImage):
#     # try:
#     base64_string = data.imageBase64
#     base64_string = base64_string.replace("data:image/jpeg;base64,", "")
#     base64_decoded = base64.b64decode(base64_string)
#     image = Image.open(io.BytesIO(base64_decoded))
#     image_np = np.array(image)
#     img = image_np

#     # cv2.imwrite("origin.jpg", img)
#     im1 = image.save("origin.jpg")

#     img = cv2.imread("origin.jpg")

#     flip = scanDocument(img)

#     if flip is not None:
#         img = faceDetectionAndRotate(flip)

#         # rotate = cv2.rotate(flip, cv2.ROTATE_180)  # Rotate Image
#         # rotate = cv2.rotate(flip, cv2.ROTATE_90_CLOCKWISE)  # Rotate Image
#         rotate = cv2.rotate(flip, cv2.ROTATE_90_COUNTERCLOCKWISE)  # Rotate Image

#         resize = cv2.resize(flip, (800, 500))

#         retval, buffer = cv2.imencode('.jpg', resize)
#         jpg_as_text = base64.b64encode(buffer)

#         imageBase64 = str(jpg_as_text).replace("b\'", "")
#         imageBase64 = imageBase64.replace("'", "")
#         # f = open("demofile3.txt", "w")
#         # f.write(str(base64.b64encode(resize)))
#         # f.close()

#         print("Work ...")

#         return {
#             "cropImageBase64": "data:image/jpeg;base64," + imageBase64,
#             "classCardImage": "card",
#         }
#     # except:

#     # raise HTTPException(
#     #             status_code=412, detail='image is not card')

#     print("Work ... 2")
#     return {
#         "cropImageBase64": "None",
#         "classCardImage": "None",
#     }


# @walkin_api.get('/get_home_number', tags=['Home Number'], status_code=status.HTTP_200_OK)
# async def GetHomeNumber(token=Depends(auth_handler.get_token)):
#     if token == "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff":
#         query = "SELECT home_number FROM home;"
#         return await db.fetch_all(query)

#     else:
#         raise HTTPException(
#             status_code=401, detail='Signature has expired')


# @walkin_api.post("/walkin", tags=["Create Walk In"],  status_code=status.HTTP_201_CREATED)
# async def WalkIn(walkin: WalkInRegister,  token=Depends(auth_handler.get_token)):
#     if token == "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff":
#         # create example image id_card.jpg
#         imagePath = create_image(walkin.id_card, walkin.imageBase64)

#         # create datetime of server
#         xdatetime = create_datetime()

#         query = f'''INSERT INTO walkin (firstname, lastname, id_card, gender, address, license_plate, goto_home_address, datetime_in, path_image, qr_gen_id)
#                     VALUES ('{walkin.firstname}', '{walkin.lastname}', '{walkin.id_card}', '{walkin.gender}', '{walkin.address}', '{walkin.license_plate.replace(' ', '')}', '{walkin.goto_home_address}', '{xdatetime}', '{imagePath}', '{walkin.qrGenId}');'''
         
#         return await db.execute(query)
#         # return "ok"

#     else:
#         raise HTTPException(
#             status_code=401, detail='Signature has expired')


# def create_datetime():
#     x = datetime.now()
#     xdatetime = f"{x.year}-{x.month}-{x.day} {x.hour}:{x.minute}:{x.second}.{x.microsecond}"

#     return xdatetime


# def create_image(id_card, imageStr):
#     imgdata = b64decode(imageStr)
#     filename = f'images/{id_card}.jpg'

#     with open(filename, 'wb') as f:
#         f.write(imgdata)

#     return filename
