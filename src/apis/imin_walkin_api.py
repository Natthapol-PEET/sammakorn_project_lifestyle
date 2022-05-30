import codecs
from datetime import datetime, date
import json
from time import time, sleep
from fastapi import FastAPI, File, HTTPException, UploadFile
from data.imin_schemas import LogId
from data.walkin_schemas import RegisterWalkin
import easyocr
import cv2
import numpy as np
import base64
from PIL import Image
from io import BytesIO
from fastapi.responses import StreamingResponse
from starlette.responses import FileResponse

from utils.CroppingThaiPersonalDrivingLicense.Personal import Personal
from utils.CroppingThaiPersonalDrivingLicense.DrivingLicense import DrivingLicense
from utils.utils import generage_qr_code


from icecream import ic
from fastapi.encoders import jsonable_encoder

# database, schemas, models
from data.database import database as db

# utils
from utils import utils, manageMail
from utils.verify_id_card import isThaiNationalID


tags_metadata = [
    # {"name": "checkIn", "description": ""},
    # {"name": "checkOut", "description": ""},
]

imin_walkin_api = FastAPI(openapi_tags=tags_metadata)

# reader = easyocr.Reader(['th', 'en'], gpu=False)

personalCard = Personal(path_to_save="images/Extract")
drivingLicense = DrivingLicense()

errorMessage = {"message": "กรุณาถ่ายรูปบัตรประชาชนใหม่"}


@imin_walkin_api.get("/exit_project", status_code=200)
async def exit_project():
    queryVisitor = '''
         SELECT * 
            FROM visitor AS v
            RIGHT JOIN history_log AS h
                ON v.visitor_id = h.class_id
			LEFT JOIN home
				ON v.home_id = home.home_id
            WHERE h.class = 'visitor' and h.datetime_in is not null and v.visitor_id is not null;
    '''

    resultVisitor = await db.fetch_all(queryVisitor)

    queryWhitelist = '''
        SELECT * 
            FROM whitelist AS w
            RIGHT JOIN history_log AS h
                ON w.whitelist_id = h.class_id
			LEFT JOIN home
				ON w.home_id = home.home_id
            WHERE h.class = 'whitelist' and h.datetime_in is not null;
    '''

    resultWhitelist = await db.fetch_all(queryWhitelist)

    # result = jsonable_encoder(await db.fetch_all(query))
    # print(result)
    # return jsonable_encoder(await db.fetch_all(query))
    return {
        "resultVisitor": resultVisitor,
        "resultWhitelist": resultWhitelist,
    }


@imin_walkin_api.post("/exit_project", status_code=201)
async def exit_project(item: LogId):
    sql = f'''
        UPDATE history_log
            SET datetime_out = '{datetime.now()}'
        WHERE log_id = {item.logId}
    '''
    await db.execute(sql)
    return {'message': 'update datetime out to exit project'}


@imin_walkin_api.post("/register_walkin", status_code=201)
async def upload(item: RegisterWalkin):
    if not isThaiNationalID(item.idCard):
        raise HTTPException(
            status_code=401, detail='หมายเลขบัตรประจำตัวประชาชนไม่ถูกต้อง')

    # get home_id from home_number
    query = f"SELECT home_id FROM home WHERE home_number = '{item.homeNumber}'"
    home = jsonable_encoder(await db.fetch_one(query))

    if home is None:
        raise HTTPException(
            status_code=401, detail=f'ไม่มีบ้านเลขที่ {item.homeNumber} ในระบบ')

    home_id = home['home_id']

    # insert data to visitor - walkin
    query = f'''
        INSERT INTO visitor (home_id, class, class_id, id_card, license_plate,  qr_gen_id, invite_date, create_datetime)
            VALUES ({home_id}, 'guard', {item.guardId}, '{item.idCard}',  '{item.licensePlate}', '{item.code}', '{str(date.today())}', '{datetime.now()}')
    '''
    await db.execute(query)

    query = f"SELECT visitor_id FROM visitor WHERE qr_gen_id = '{item.code}'"
    visitorId = jsonable_encoder(await db.fetch_one(query))['visitor_id']

    # insert datetime in -> history_log
    sql = f'''
        INSERT INTO history_log (class, class_id, datetime_in, create_datetime)
            VALUES ('visitor', {visitorId}, '{datetime.now()}', '{datetime.now()}')
    '''
    await db.execute(sql)

    return {'message': 'register successful'}


@imin_walkin_api.get("/card/{image_name}", tags=["Profile"], status_code=200)
async def card(image_name: str):
    image_name = 'images/Card/' + image_name + '.jpg'

    original_image = Image.open(image_name)
    filtered_image = BytesIO()
    original_image.save(filtered_image, "JPEG")
    filtered_image.seek(0)

    return StreamingResponse(filtered_image, media_type="image/jpeg")


@imin_walkin_api.post("/decode_image", status_code=201)
async def upload(image: UploadFile = File(...)):
    # Read image
    original_image = Image.open(image.file)
    print(image.filename)

    # crop the image according to the frame.
    '''
    left = 2407
    top = 804
    width = 300
    height = 200
    box = (left, top, left+width, top+height)
    area = img.crop(box)
    '''

    # image to base64
    buffered = BytesIO()
    original_image.save(buffered, format="JPEG")
    img_str = base64.b64encode(buffered.getvalue())

    # generage code
    code = generage_qr_code("V")

    # croping & extract fullname, id code
    if image.filename == ' บัตรประจำตัวประชาชน':
        image_scan = personalCard.cropping_front_personal(img_str)
    else:
        image_scan = drivingLicense.extractInfo(img_str)

    # fullNameTH = reader.readtext("images/Extract/FullNameTH.jpg", detail=0)
    # print(f'fullNameTH: {fullNameTH}')
    # if fullNameTH:
    #     # fullNameTH = fullNameTH[0]
    #     fullname = ""
    #     for f in fullNameTH:
    #         fullname += f
    #         fullname += " "
    # else:
    #     return errorMessage

    # pre process image
    # kernel = np.ones((3, 3), np.uint8)
    # image = cv2.imread('images/Extract/Identification_Number.jpg', 0)
    # gradient = cv2.morphologyEx(image, cv2.MORPH_GRADIENT, kernel)
    # cv2.imwrite("images/Extract/Identification_Number_gradient.jpg", gradient)

    # identificationNumber = reader.readtext("images/Extract/Identification_Number.jpg", detail=0)
    # print(f'identificationNumber: {identificationNumber}')
    # if identificationNumber:
    #     id_card = identificationNumber[0]
    # else:
    #     return errorMessage

    # ------------- write json file --------------------
    # with codecs.open('images/personalCard/sample.txt', 'a', 'utf-8') as f:
    #     f.write(f'fullname: {fullname}\n')
    #     # f.write(f'lastname: {lname}\n')
    #     f.write(f'Identification_Number: {id_card}\n')
    #     # f.write(f'Identification_Number_gradient: {resultB}\n')
    #     f.write(f'code: {code}\n')
    #     f.write(f'image_path: images\personalCard\{code}.jpg\n\n')

    # save image id card
    cv2.imwrite(f"images/Card/{code}.jpg", image_scan)
    # ------------- end write json file --------------------
    sleep(1)

    return {"code": code}

    # # แปลงภาพเป็นข้อความ
    # resultA = reader.readtext(
    #     'images/Extract/Identification_Number.jpg', detail=0)
    # resultB = reader.readtext(
    #     'images/Extract/Identification_Number_gradient.jpg', detail=0)

    # # ------------- write json file --------------------
    # with codecs.open('images/personalCard/sample.txt', 'a', 'utf-8') as f:
    #     f.write(f'firstname: {fname}\n')
    #     f.write(f'lastname: {lname}\n')
    #     f.write(f'Identification_Number: {resultA}\n')
    #     f.write(f'Identification_Number_gradient: {resultB}\n')
    #     f.write(f'code: {code}\n')
    #     f.write(f'image_path: images\personalCard\{code}.jpg\n\n')

    # # save image id card
    # cv2.imwrite(f"images/personalCard/{code}.jpg", image_scan)

    # # ------------- end write json file --------------------

    # # แปลง string เป็น list พร้อมทั้งหาตำแหน่งว่า (-1)
    # A = finePositionID(resultA)
    # B = finePositionID(resultB)

    # if not A or not B:
    #     return errorMessage

    # # ความยาวของเลขบัตร ปปช แต่ละวรรค
    # id_card_index_length = [1, 4, 5, 2, 1]

    # for i in range(0, 5):
    #     # print(f"A[{i}] = {A[i]}")

    #     # ถ้า A[index] เป็นค่าว่าง แทนที่ A[index] ด้วย B[index]
    #     if A[i] == -1:
    #         A[i] = B[i]

    #     # ถ้า A[index]
    #     if len(A[i]) != id_card_index_length[i]:
    #         A[i] = B[i]

    # # ข้อมูลไม่ครบ
    # if -1 in A:
    #     return errorMessage

    # # แปลง list to string
    # id_card = " "
    # id_card = id_card.join(A).replace(" ", "")

    # # ตรวจสอบความยาวของเลขบัตร ปปช
    # if len(id_card) != 13:
    #     return errorMessage

    # result = isThaiNationalID(id_card)

    # if result:
    #     # save image id card
    #     # cv2.imwrite(f"images/personalCard/{code}.jpg", image_scan)

    #     return {
    #         "firstname": fname,
    #         "lastname": lname,
    #         "idCard": id_card,
    #         "code": code,
    #     }
    # else:
    #     return errorMessage


def finePositionID(result: list):
    id_card_index_length = [1, 4, 5, 2, 1]
    ID = result[0]
    # ID = "1 4105 72 6"
    ID = ID.split(" ")
    # print(ID)

    list_ID = [-1, -1, -1, -1, -1]
    for i in range(0, len(ID)):
        try:
            index = id_card_index_length.index(len(ID[i]))

            if index == 0:
                if list_ID[1] != -1 or list_ID[2] != -1 or list_ID[3] != -1:
                    index = 4

            list_ID[index] = ID[i]
        except:
            pass

    if list_ID.count(-1) > 1:
        return False

    return list_ID
