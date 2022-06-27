from fastapi import FastAPI, Depends, status, HTTPException

from data.schemas import LoginResident, VisitorIN, HomeId, VisitorId, HistoryLog, ResidentId

from data.database import database as db
from data.schemas import UpdateHome, ChangePassword

from auth.check_token import is_token_blacklisted as isTokenBlacklisted
from auth.register import Register
from auth.login import Login
from auth.logout import Logout
from auth.auth import AuthHandler

from apis.home import Home, LicensePlate
from apis.api import API
from services.socket_manage import emit_message

tags_metadata = [
    {"name": "Account", "description": ""},
    {"name": "Visitor", "description": ""},
    {"name": "Whitelist", "description": ""},
    {"name": "Home", "description": ""},
]

app_api = FastAPI(openapi_tags=tags_metadata)


register = Register()
login = Login()
auth_handler = AuthHandler()
home = Home()
api = API()
licensePlate = LicensePlate()

# ------------------------------------- Account ---------------------------


@app_api.post('/v2/login_resident/', tags=["Account"], status_code=200)
async def login_resident(auth_details: LoginResident):
    return await login.login_resident(db, auth_details=auth_details)


@app_api.post("/v2/logout/", tags=["Account"], status_code=200)
async def logout(item: ResidentId, token=Depends(auth_handler.get_token)):
    return await Logout().logout(db, token=token, item=item)


@app_api.post('/v2/resident_change_password/', tags=["Account"], status_code=201)
async def resident_change_password(items: ChangePassword):
    return await register.resident_change_password(db, items=items)

# ------------------------------------- End Account ---------------------------

# ------------------------------------- Home ---------------------------


@app_api.post("/v2/gethome/", tags=["Home"], status_code=status.HTTP_200_OK)
async def get_home(item: ResidentId, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await home.get_home(db, item=item)


@app_api.put('/v2/update_home/', tags=["Home"], status_code=200)
async def update_home(item: UpdateHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.v2_update_home(db, item)

# ------------------------------------- End Home ---------------------------

# -------------------------------- Whitelist -----------------------------------------


@app_api.post("/v2/whitelist/", tags=['Whitelist'], status_code=200)
async def whitelist(item: HomeId, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.v2_get_whitelist(db, item)
# -------------------------------- End Whitelist -----------------------------------------

# ------------------------------ Visitor --------------------------------


@app_api.post("/v2/visitor/", tags=['Visitor'], status_code=200)
async def visitor(item: HomeId, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.v2_get_visitor(db, item)


@app_api.post("/v2/invite/visitor/", tags=["Visitor"],  status_code=status.HTTP_201_CREATED)
async def Invite_Visitor(item: VisitorIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')

    response = await api.Invite_Visitor(db, item=item, username=username)

    await emit_message(f'toApp/{item.home_id}', 'INVITE_VISITOR')
    await emit_message(f'toWeb', 'INVITE_VISITOR')

    return response


@app_api.put('/v2/resident_stamp/', tags=["Visitor"], status_code=200)
async def resident_stamp(item: HistoryLog, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    response = await licensePlate.resident_stamp(db, item=item)

    await emit_message(f'toApp/{item.home_id}', 'RESIDENT_STAMP')
    await emit_message(f'toWeb', 'RESIDENT_STAMP')

    return response


@app_api.delete('/v2/invite/delete/', tags=["Visitor"], status_code=200)
async def licensePlate_invite_delete(item: VisitorId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')

    await emit_message(f'toApp/{item.home_id}', 'INVITE_VISITOR')
    await emit_message(f'toWeb', 'INVITE_VISITOR')

    return await licensePlate.licensePlate_invite_delete(db, item=item)

# ------------------------------ End Visitor  --------------------------------
