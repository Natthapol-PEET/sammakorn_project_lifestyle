from fastapi import FastAPI, Depends, status, HTTPException

from data.schemas import RegisterDetails, LoginResident, \
    VisitorIN, HomeIn, ResidentHomeIn, WhitelistIN, BlacklistIN, \
    listItem_whitelist_blacklist, deleteBlackWhite, HomeId, VisitorId, HistoryLog, \
    ResidentId, SendToAdmin, AdminDelete

from data.database import database as db
from data.schemas import CancelRequest, DeleteWhiteBlackWhite

from auth.check_token import is_token_blacklisted as isTokenBlacklisted
from auth.register import Register
from auth.login import Login
from auth.logout import Logout
from auth.auth import AuthHandler

from apis.home import Home, LicensePlate
from apis.api import API
from apis.list_item import ListItem, History

tags_metadata = [
    {"name": "Register", "description": ""},
    {"name": "Login", "description": ""},
    {"name": "Logout", "description": ""},
    {"name": "Visitor", "description": ""},
    {"name": "Blacklist", "description": ""},
    {"name": "Whitelist", "description": ""},
    {"name": "Resident Home", "description": ""},
    {"name": "Home", "description": ""},
    {"name": "List Items", "description": ""},
]

app_api = FastAPI(openapi_tags=tags_metadata)


register = Register()
login = Login()
auth_handler = AuthHandler()
home = Home()
api = API()
listItem = ListItem()
history = History()
licensePlate = LicensePlate()

# ------------------------------------- Register ---------------------------

@app_api.post('/register_resident/', tags=["Register"], status_code=201)
async def register_resident(auth_details: RegisterDetails):
    return await register.register_resident(db, auth_details=auth_details)

# ------------------------------------- End Register ---------------------------

# ------------------------------------- Login ---------------------------

@app_api.post('/login_resident/', tags=["Login"], status_code=200)
async def login_resident(auth_details: LoginResident):
    return await login.login_resident(db, auth_details=auth_details)

# ------------------------------------- End Login ---------------------------

# ------------------------------------- End Logout ---------------------------
@app_api.post("/logout/", tags=["Logout"], status_code=200)
async def logout(item: ResidentId, token=Depends(auth_handler.get_token)):
    return await Logout().logout(db, token=token, item=item)
# ------------------------------------- End Logout ---------------------------

# ------------------------------------- Resident Home ---------------------------
@app_api.post("/gethome/", tags=["Home"], status_code=status.HTTP_200_OK)
async def get_home(item: ResidentId, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await home.get_home(db, item=item)


@app_api.post("/home/", tags=["Home"], status_code=status.HTTP_201_CREATED)
async def Add_Home(Home: HomeIn):
    return await home.Add_Home(db, Home=Home)


@app_api.post("/resident_home/", tags=["Resident Home"], status_code=status.HTTP_201_CREATED)
async def Add_Resident_Home(ResidentHome: ResidentHomeIn):
    return await home.Add_Resident_Home(db, ResidentHome=ResidentHome)
# ------------------------------------- End Resident Home ---------------------------

# ------------------------------------- Application ---------------------------

@app_api.post("/invite/visitor/", tags=["Visitor"],  status_code=status.HTTP_201_CREATED)
async def Invite_Visitor(invite: VisitorIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.Invite_Visitor(db, invite=invite, username=username)


@app_api.post("/register/whitelist/", tags=["Whitelist"],  status_code=status.HTTP_201_CREATED)
async def register_whitelist(register: WhitelistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.register_whitelist(db, register=register, username=username)


@app_api.post("/register/blacklist/", tags=["Blacklist"],  status_code=status.HTTP_201_CREATED)
async def register_blacklist(register: BlacklistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.register_blacklist(db, register=register, username=username)

# ------------------------------------- End Application ---------------------------

# -------------------------------- List Items -----------------------------------------

@app_api.post("/listItem_whitelist_blacklist/", tags=["List Items"],  status_code=200)
async def listItem_whitelist_blacklist(list_item: listItem_whitelist_blacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await listItem.listItem_whitelist_blacklist(db, list_item=list_item)


@app_api.delete("/delete_backlist_whitelist/", tags=["List Items"],  status_code=200)
async def delete_backlist_whitelist(item: deleteBlackWhite, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await listItem.delete_backlist_whitelist(db, item=item)
# -------------------------------- End List Items -----------------------------------------

# ------------------------------ History --------------------------------

@app_api.post('/history/', tags=["Home"], status_code=200)
async def histoly_log(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await history.histoly_log(db, item=item)

# ------------------------------ End History --------------------------------

# ------------------------------ License plate --------------------------------

@app_api.post('/license_plate/invite/', tags=["Home"], status_code=200)
async def license_plate_invite(home_id: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.invite(db, home_id=home_id)


@app_api.delete('/license_plate/invite/delete/', tags=["Home"], status_code=200)
async def licensePlate_invite_delete(visitor: VisitorId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.licensePlate_invite_delete(db, visitor=visitor)


@app_api.post('/license_plate/coming_and_walk/', tags=["Home"], status_code=200)
async def coming_and_walk(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.coming_and_walk(db, item=item)


@app_api.put('/license_plate/resident_stamp/', tags=["Home"], status_code=200)
async def resident_stamp(item: HistoryLog, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.resident_stamp(db, item=item)


@app_api.post('/license_plate/get_resident_stamp/', tags=["Home"], status_code=200)
async def resident_stamp(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.get_resident_stamp(db, item=item)


@app_api.put('/license_plate/send_admin_stamp/', tags=["Home"], status_code=200)
async def send_admin_stamp(item: SendToAdmin, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_stamp(db, item=item)


@app_api.put('/license_plate/send_admin_delete/', tags=["Home"], status_code=200)
async def send_admin_delete(item: AdminDelete, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_delete(db, item=item)


@app_api.post('/license_plate/get_resident_send_admin/', tags=["Home"], status_code=200)
async def get_resident_send_admin(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.get_resident_send_admin(db, item=item)


@app_api.put('/license_plate/resident_cancel_send_admin/', tags=["Home"], status_code=200)
async def resident_cancel_send_admin(item: HistoryLog, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.resident_cancel_send_admin(db, item=item)



@app_api.delete('/license_plate/cancel_request_white_black/', tags=["Home"], status_code=200)
async def cancel_request_white_black(item: CancelRequest, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.cancel_request_white_black(db, item=item)


@app_api.put('/license_plate/cancel_request_delete_white_black/', tags=["Home"], status_code=200)
async def cancel_request_delete_white_black(item: CancelRequest, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.cancel_request_delete_white_black(db, item=item)


@app_api.put('/license_plate/send_admin_delete_blackwhite/', tags=["Home"], status_code=200)
async def send_admin_delete_blackwhite(item: DeleteWhiteBlackWhite, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_delete_blackwhite(db, item=item)


@app_api.post('/license_plate/pms_show_list/', tags=["Home"], status_code=200)
async def pms_show_list(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.pms_show_list(db, item=item)


@app_api.post('/license_plate/checkout/', tags=["Home"], status_code=200)
async def checkout(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.checkout(db, item=item)

# ------------------------------ End License plate  --------------------------------