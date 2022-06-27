from fastapi import Depends, FastAPI, File, HTTPException, UploadFile
from apis.api import API
from apis.notification import send_notification_v2
from auth.auth import AuthHandler
from auth.check import Check
from auth.check_token import is_token_blacklisted as isTokenBlacklisted
from data.imin_schemas import ImageBast64, LogId, Image
from data.walkin_schemas import RegisterWalkin

# database, schemas, models
from data.database import database as db
from utils.enums.title import Title
from utils.enums.data import DataClass
from services.socket_manage import emit_message

# utils
from utils import utils, manageMail
from utils.verify_id_card import isThaiNationalID

check = Check()


tags_metadata = [
    {"name": "Project", "description": ""},
    {"name": "Walk In", "description": ""},
    {"name": "Profile", "description": ""},
]

imin_api = FastAPI(openapi_tags=tags_metadata)
api = API()
auth_handler = AuthHandler()


@imin_api.get("/exit_project/", tags=["Project"], status_code=200)
async def exit_project(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.exit_project(db)


@imin_api.post("/exit_project/", tags=["Project"], status_code=201)
async def exit_project(item: LogId, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f'''
        SELECT * 
        FROM history_log AS h
        LEFT join visitor AS v
            ON h.class_id = v.visitor_id
        WHERE log_id = {item.logId};
    '''
    result = await db.fetch_one(sql)
    
    # realtime
    await emit_message(f'toApp/{result.home_id}', 'CHECKOUT')
    await emit_message(f'toWeb', 'CHECKOUT')
    await emit_message(f'toWeb', 'ADMIN_STAMP')

    # notification
    await send_notification_v2(db, result, Title.guard, DataClass.checkout, homeId=result.home_id)
    
    return await api.post_exit_project(db, item)


@imin_api.post("/register_walkin/", tags=["Walk In"], status_code=201)
async def upload(item: RegisterWalkin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.register_walkin(db, item)

    # realtime
    home_id = await check.checkHomeIdByHomeNumber(db, item)
    await emit_message(f'toApp/{home_id}', 'REGISTER_WALKIN')
    await emit_message(f'toWeb', 'COMING_WALK_IN')

    # notification
    await send_notification_v2(db, item, Title.guard, DataClass.comming, homeId=home_id)
    
    return response


@imin_api.post("/decode_image/", tags=["Walk In"], status_code=201)
async def upload(image: UploadFile = File(...)):
    return await api.decode_image(image)



@imin_api.post("/decode_image_base64/", tags=["Walk In"], status_code=201)
async def upload(image: ImageBast64, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.decode_image_base64(image)


@imin_api.get("/card/{image_name}/", tags=["Profile"], status_code=200)
async def card(image_name: str, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_card_image(image_name)

