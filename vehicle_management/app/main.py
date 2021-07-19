from .auth import AuthHandler
from .logout import Logout
from .login import Login
from .register import Register
from .schemas import RegisterDetails, LoginDetails, LoginResident
from .schemas import VisitorIN, HomeIn, ResidentHomeIn, WhitelistIN, BlacklistIN, \
    listItem_whitelist_blacklist, deleteBlackWhite, HomeId, VisitorId, HistoryLog

from fastapi import FastAPI, status, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.encoders import jsonable_encoder

from typing import List

from .database import database as db
from .check_token import is_token_blacklisted as isTokenBlacklisted
from .api import API
from .home import Home, LicensePlate
from .list_item import ListItem, History

auth_handler = AuthHandler()
api = API()
register = Register()
login = Login()
home = Home()
listItem = ListItem()
history = History()
licensePlate = LicensePlate()

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

app = FastAPI(
    title="REST API using FastAPI PostgreSQL Async EndPoints (Sammakorn API)",
    openapi_tags=tags_metadata)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=[
    #     "http://localhost:8000",
    #     "http://127.0.0.1:8000"
    # ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup():
    await db.connect()


@app.on_event("shutdown")
async def shutdown():
    await db.disconnect()

# ------------------------------------- Register ---------------------------


@app.post('/register_resident/', tags=["Register"], status_code=201)
async def register_resident(auth_details: RegisterDetails):
    return await register.register_resident(db, auth_details=auth_details)


@app.post('/register_admin/', tags=["Register"], status_code=201)
async def register_admin(auth_details: RegisterDetails):
    return await register.register_admin(db, auth_details=auth_details)


@app.post('/register_guard/', tags=["Register"], status_code=201)
async def register_guard(auth_details: RegisterDetails):
    return await register.register_guard(db, auth_details=auth_details)

# ------------------------------------- End Register ---------------------------

# ------------------------------------- Login ---------------------------


@app.post('/login_resident/', tags=["Login"], status_code=200)
async def login_resident(auth_details: LoginResident):
    return await login.login_resident(db, auth_details=auth_details)


@app.post('/login_admin/', tags=["Login"], status_code=200)
async def login_admin(auth_details: LoginDetails):
    return await login.login_admin(db, auth_details=auth_details)


@app.post('/login_guard/', tags=["Login"], status_code=200)
async def login_guard(auth_details: LoginDetails):
    return await login.login_guard(db, auth_details=auth_details)


@app.get('/protected/',  status_code=200)
async def protected(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        return {"msg": f"{username} is blacklist token"}
    else:
        return {"msg": f"{username} is not blacklisted token"}


# ------------------------------------- End Login ---------------------------

# ------------------------------------- End Logout ---------------------------
@app.post("/logout/", tags=["Logout"], status_code=302)
async def logout(token=Depends(auth_handler.get_token)):
    return await Logout().logout(db, token=token)
# ------------------------------------- End Logout ---------------------------


# ------------------------------------- Resident Home ---------------------------
@app.get("/home/", tags=["Home"], status_code=status.HTTP_200_OK)
async def get_all_home():
    return await home.get_all_home(db)


@app.post("/home/", tags=["Home"], status_code=status.HTTP_201_CREATED)
async def Add_Home(Home: HomeIn):
    return await home.Add_Home(db, Home=Home)


@app.post("/resident_home/", tags=["Resident Home"], status_code=status.HTTP_201_CREATED)
async def Add_Resident_Home(ResidentHome: ResidentHomeIn):
    return await home.Add_Resident_Home(db, ResidentHome=ResidentHome)
# ------------------------------------- End Resident Home ---------------------------


# @app.get("/notes/", response_model=List[Note], status_code=status.HTTP_200_OK)
# async def read_notes():
#     return await crud.read_notes(db, skip=0, take=20)


# @app.get("/notes/{note_id}/", response_model=Note, status_code=status.HTTP_200_OK)
# async def read_notes_id(note_id: int):
#     return await crud.read_notes_id(db, note_id=note_id)


# @app.post("/notes/", response_model=Note, status_code=status.HTTP_201_CREATED)
# async def create_note(note: NoteIn):
#     return await crud.create_note(db, note=note)


# @app.put("/notes/{note_id}/", response_model=Note, status_code=status.HTTP_200_OK)
# async def update_note(note_id: int, payload: NoteIn):
#     return await crud.update_note(db, note_id=note_id, payload=payload)


# @app.delete("/notes/{note_id}/", status_code=status.HTTP_200_OK)
# async def delete_note_id(note_id: int):
#     return await crud.delete_note_id(db, note_id=note_id)


# ------------------------------------- Application ---------------------------

@app.post("/invite/visitor/", tags=["Visitor"],  status_code=status.HTTP_201_CREATED)
async def Invite_Visitor(invite: VisitorIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.Invite_Visitor(db, invite=invite, username=username)


@app.post("/register/whitelist/", tags=["Whitelist"],  status_code=status.HTTP_201_CREATED)
async def register_whitelist(register: WhitelistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.register_whitelist(db, register=register, username=username)


@app.post("/register/blacklist/", tags=["Blacklist"],  status_code=status.HTTP_201_CREATED)
async def register_blacklist(register: BlacklistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.register_blacklist(db, register=register, username=username)

# ------------------------------------- End Application ---------------------------

# -------------------------------- List Items -----------------------------------------


@app.post("/listItem_whitelist_blacklist/", tags=["List Items"],  status_code=200)
async def listItem_whitelist_blacklist(list_item: listItem_whitelist_blacklist, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await listItem.listItem_whitelist_blacklist(db, list_item=list_item)


@app.delete("/delete_backlist_whitelist/", tags=["List Items"],  status_code=200)
async def delete_backlist_whitelist(item: deleteBlackWhite, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await listItem.delete_backlist_whitelist(db, item=item)
# -------------------------------- End List Items -----------------------------------------

# ------------------------------ History --------------------------------


@app.post('/history/', tags=["Home"], status_code=200)
async def histoly_log(home_id: HomeId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await history.histoly_log(db, home_id=home_id)

# ------------------------------ End History --------------------------------

# ------------------------------ License plate --------------------------------


@app.post('/license_plate/invite/', tags=["Home"], status_code=200)
async def license_plate_invite(home_id: HomeId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.invite(db, home_id=home_id)


@app.delete('/license_plate/invite/delete/', tags=["Home"], status_code=200)
async def licensePlate_invite_delete(visitor: VisitorId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.licensePlate_invite_delete(db, visitor=visitor)


@app.post('/license_plate/coming_and_walk/', tags=["Home"], status_code=200)
async def coming_and_walk(item: HomeId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.coming_and_walk(db, item=item)


@app.put('/license_plate/resident_stamp/', tags=["Home"], status_code=200)
async def resident_stamp(item: HistoryLog, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.resident_stamp(db, item=item)


@app.post('/license_plate/hsa_stamp/', tags=["Home"], status_code=200)
async def resident_stamp(item: HomeId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.hsa_stamp(db, item=item)


@app.put('/license_plate/send_admin_stamp/', tags=["Home"], status_code=200)
async def send_admin_stamp(item: HistoryLog, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_stamp(db, item=item)


@app.post('/license_plate/pms_show_list/', tags=["Home"], status_code=200)
async def pms_show_list(item: HomeId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.pms_show_list(db, item=item)



# ------------------------------ End License plate  --------------------------------
