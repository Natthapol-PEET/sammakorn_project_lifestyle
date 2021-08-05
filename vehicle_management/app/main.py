from apis.api import api_app
import uvicorn
from fastapi import WebSocket, Depends, FastAPI, Query, WebSocket, status
from auth import AuthHandler
from logout import Logout
from login import Login
from register import Register
from schemas import RegisterDetails, LoginDetails, LoginResident, \
    VisitorIN, HomeIn, ResidentHomeIn, WhitelistIN, BlacklistIN, \
    listItem_whitelist_blacklist, deleteBlackWhite, HomeId, VisitorId, HistoryLog, \
    ResidentId, NotificationItem, SendToAdmin, AdminDelete

from schemas import GuardhouseCheckin, GuardhouseAddvisitor, GuardhouseCheckout
from schemas import Adminstamp, ApproveBlacklist, ApproveWhitelist

from fastapi import FastAPI, status, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.encoders import jsonable_encoder

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List
import json
from ws.connection_manage import ConnectionManager

from database import database as db
from check_token import is_token_blacklisted as isTokenBlacklisted
from api import API
from home import Home, LicensePlate
from list_item import ListItem, History
from notification import Notification
from datetime import datetime, timedelta

auth_handler = AuthHandler()
api = API()
register = Register()
login = Login()
home = Home()
listItem = ListItem()
history = History()
licensePlate = LicensePlate()
notification = Notification()


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
    {"name": "Notification", "description": ""}
]

app = FastAPI(
    title="REST API using FastAPI PostgreSQL Async EndPoints (Sammakorn API)",
    openapi_tags=tags_metadata)


app.mount('/api', api_app)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=[
    #     "http://localhost:8080",
    #     "http://127.0.0.1:8080",
    #     "http://192.168.0.100:8080",
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
@app.post("/logout/", tags=["Logout"], status_code=200)
async def logout(item: ResidentId, token=Depends(auth_handler.get_token)):
    return await Logout().logout(db, token=token, item=item)
# ------------------------------------- End Logout ---------------------------


# ------------------------------------- Resident Home ---------------------------
@app.post("/gethome/", tags=["Home"], status_code=status.HTTP_200_OK)
async def get_home(item: ResidentId, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await home.get_home(db, item=item)


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
async def listItem_whitelist_blacklist(list_item: listItem_whitelist_blacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await listItem.listItem_whitelist_blacklist(db, list_item=list_item)


@app.delete("/delete_backlist_whitelist/", tags=["List Items"],  status_code=200)
async def delete_backlist_whitelist(item: deleteBlackWhite, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await listItem.delete_backlist_whitelist(db, item=item)
# -------------------------------- End List Items -----------------------------------------

# ------------------------------ History --------------------------------


@app.post('/history/', tags=["Home"], status_code=200)
async def histoly_log(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await history.histoly_log(db, item=item)

# ------------------------------ End History --------------------------------

# ------------------------------ License plate --------------------------------


@app.post('/license_plate/invite/', tags=["Home"], status_code=200)
async def license_plate_invite(home_id: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.invite(db, home_id=home_id)


@app.delete('/license_plate/invite/delete/', tags=["Home"], status_code=200)
async def licensePlate_invite_delete(visitor: VisitorId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.licensePlate_invite_delete(db, visitor=visitor)


@app.post('/license_plate/coming_and_walk/', tags=["Home"], status_code=200)
async def coming_and_walk(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.coming_and_walk(db, item=item)


@app.put('/license_plate/resident_stamp/', tags=["Home"], status_code=200)
async def resident_stamp(item: HistoryLog, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.resident_stamp(db, item=item)


@app.post('/license_plate/get_resident_stamp/', tags=["Home"], status_code=200)
async def resident_stamp(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.get_resident_stamp(db, item=item)


@app.put('/license_plate/send_admin_stamp/', tags=["Home"], status_code=200)
async def send_admin_stamp(item: SendToAdmin, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_stamp(db, item=item)


@app.put('/license_plate/send_admin_delete/', tags=["Home"], status_code=200)
async def send_admin_delete(item: AdminDelete, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_delete(db, item=item)


@app.post('/license_plate/get_resident_send_admin/', tags=["Home"], status_code=200)
async def get_resident_send_admin(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.get_resident_send_admin(db, item=item)


@app.put('/license_plate/resident_cancel_send_admin/', tags=["Home"], status_code=200)
async def resident_cancel_send_admin(item: HistoryLog, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.resident_cancel_send_admin(db, item=item)

from schemas import CancelRequest, DeleteWhiteBlackWhite

@app.delete('/license_plate/cancel_request_white_black/', tags=["Home"], status_code=200)
async def cancel_request_white_black(item: CancelRequest, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.cancel_request_white_black(db, item=item)


@app.put('/license_plate/cancel_request_delete_white_black/', tags=["Home"], status_code=200)
async def cancel_request_delete_white_black(item: CancelRequest, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.cancel_request_delete_white_black(db, item=item)


@app.put('/license_plate/send_admin_delete_blackwhite/', tags=["Home"], status_code=200)
async def send_admin_delete_blackwhite(item: DeleteWhiteBlackWhite, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.send_admin_delete_blackwhite(db, item=item)


@app.post('/license_plate/pms_show_list/', tags=["Home"], status_code=200)
async def pms_show_list(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.pms_show_list(db, item=item)


@app.post('/license_plate/checkout/', tags=["Home"], status_code=200)
async def checkout(item: HomeId, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await licensePlate.checkout(db, item=item)


# ------------------------------ End License plate  --------------------------------


# ------------------------------ Notification  --------------------------------
@app.post('/notification/', tags=["Notification"], status_code=200)
async def notifications(item: NotificationItem, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await notification.send_notification(db, item=item)


# ------------------------------ End Notification  --------------------------------

# ------------------------------ Web Application  --------------------------------
@app.get("/visitorlist_log", status_code=200)
async def visitorlist_log(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT v.visitor_id
     , v.license_plate
     , v.firstname
     , v.lastname
     , v.home_id 
     , h.home_number
     , v.id_card
     , v.invite_date
     , hl.datetime_in
     , hl.datetime_out
     , hl.resident_stamp
     , hl.admin_approve
     , hl.class_id
     , hl.resident_send_admin
     , hl.class
     , hl.log_id
FROM   public.visitor v
LEFT JOIN  public.home h on v.home_id = h.home_id
LEFT JOIN public.history_log hl  on hl.class = 'visitor' AND hl.class_id = v.visitor_id
WHERE v.invite_date = \'{date}\'
--WHERE invite_date = now()
ORDER BY v.visitor_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.get("/whitelist_log", status_code=200)
async def whitelist_log(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    dayp = x + timedelta(days=1)
    datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT w.whitelist_id ,
       w.home_id ,
       h.home_number ,
       w.class ,
       w.class_id ,
       w.firstname ,
       w.lastname ,
       w.license_plate ,
       w.create_datetime ,
       hl2.datetime_in ,
       hl2.datetime_out ,
       hl2.resident_stamp ,
       hl2.admin_approve ,
       hl2.resident_send_admin
       , hl2.class 
       ,hl2.class_id
FROM public.whitelist w
LEFT JOIN public.home h on w.home_id = h.home_id
LEFT JOIN (SELECT DISTINCT ON (t.class_id) class_id 
,t.log_id
     , t.class
     
     , t.datetime_in
     , t.datetime_out
     , t.resident_stamp
     , t.resident_send_admin
     , t.resident_reason
     , t.admin_datetime
     , t.admin_approve
     , t.admin_reason
     , t.create_datetime
FROM public.history_log t
WHERE t.class = 'whitelist'
ORDER BY t.class_id ,t.datetime_in DESC) hl2 on hl2.class = 'whitelist' AND hl2.class_id = w.whitelist_id 
where w.admin_approve = TRUE     
"""

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.get("/blacklist_log", status_code=200)
async def blacklist_log(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    dayp = x + timedelta(days=1)
    datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT b.blacklist_id
     , b.home_id
      , h.home_number
     , b.class
     , b.class_id
     , b.firstname
     , b.lastname
     , b.license_plate
     , b.create_datetime
     , hl.datetime_in ,
       hl.datetime_out ,
       hl.resident_stamp ,
       hl.admin_approve ,
       hl.class_id ,
       hl.resident_send_admin
    , hl.class
    , hl.log_id
FROM public.blacklist b
LEFT JOIN  public.home h on b.home_id = h.home_id
LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{date}\'  and hl.datetime_in < \'{datep}\'
where b.admin_approve = TRUE
ORDER BY b.blacklist_id 

"""

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.get("/history_visitorlist", status_code=200)
async def history_visitorlist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    dayp = x + timedelta(days=1)
    datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
    dayhis = x - timedelta(days=5)
    datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT v.visitor_id
     , v.license_plate
     , v.firstname
     , v.lastname
     , v.home_id 
     , h.home_number
     , v.id_card
     , v.invite_date
     , hl.datetime_in
     , hl.datetime_out
     , hl.resident_stamp
     , hl.admin_approve
     , hl.class_id
     , hl.resident_send_admin
     , hl.class
     , hl.log_id
FROM   public.visitor v
LEFT JOIN  public.home h on v.home_id = h.home_id
LEFT JOIN public.history_log hl  on hl.class = 'visitor' AND hl.class_id = v.visitor_id
WHERE v.invite_date > \'{datehis}\' and v.invite_date < \'{datep}\'
--WHERE invite_date = now()
ORDER BY v.visitor_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.get("/history_whitelist", status_code=200)
async def history_whitelist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    dayp = x + timedelta(days=1)
    datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
    dayhis = x - timedelta(days=5)
    datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT w.whitelist_id ,
       w.home_id ,
       h.home_number ,
       w.class ,
       w.class_id ,
       w.firstname ,
       w.lastname ,
       w.license_plate ,
       w.create_datetime ,
       hl.datetime_in ,
       hl.datetime_out ,
       hl.resident_stamp ,
       hl.admin_approve ,
       hl.class_id ,
       hl.resident_send_admin
    , hl.class
    , hl.log_id
FROM public.whitelist w
LEFT JOIN public.home h on w.home_id = h.home_id
LEFT JOIN public.history_log hl on hl.class = 'whitelist' AND hl.class_id = w.whitelist_id and hl.datetime_in > \'{datehis}\'  and hl.datetime_in < \'{datep}\'
--WHERE hl.datetime_in > '2021-07-14'  and hl.datetime_in < '2021-07-15'
ORDER BY w.whitelist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.get("/history_blacklist", status_code=200)
async def history_blacklist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    dayp = x + timedelta(days=1)
    datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
    dayhis = x - timedelta(days=5)
    datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT b.blacklist_id
     , b.home_id
      , h.home_number
     , b.class
     , b.class_id
     , b.firstname
     , b.lastname
     , b.license_plate
     , b.create_datetime
     , hl.datetime_in ,
       hl.datetime_out ,
       hl.resident_stamp ,
       hl.admin_approve ,
       hl.class_id ,
       hl.resident_send_admin
    , hl.class
    , hl.log_id
FROM public.blacklist b
LEFT JOIN  public.home h on b.home_id = h.home_id
LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{datehis}\'  and hl.datetime_in < \'{datep}\'
ORDER BY b.blacklist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.post('/guardhouse_checkin', status_code=200)
async def guardhouse_checkin(item: GuardhouseCheckin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""INSERT INTO public.history_log (
    class
    , class_id
    , datetime_in
    , create_datetime
    
) VALUES (
    \'{item.classname}\' -- class_id character varying NULLABLE
    , {item.class_id}
    , \'{item.datetime_in}\' -- datetime_in timestamp without time zone NULLABLE
    , datetime.now()
    
)
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

        return data


@app.put('/guardhouse_checkout', status_code=200)
async def guardhouse_checkout(item: GuardhouseCheckout, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.history_log
SET  datetime_out = \'{item.datetime_out}\' -- timestamp without time zone NULLABLE
WHERE public.history_log.log_id = {item.log_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

        return data


@app.post('/guardhouse_advisitor', status_code=200)
async def guardhouse_checkin(item: GuardhouseAddvisitor, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT h.home_id
FROM public.home h
WHERE h.home_number = \'{item.home_number}\'
ORDER BY h.home_id
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        print(data[0]['home_id'])

        query2 = f"""SELECT g.guard_id
FROM public.guard_account g
WHERE g.username = \'{item.username}\'
ORDER BY g.guard_id 
"""
        data2 = await db.fetch_all(query2)
        data2 = jsonable_encoder(data2)
        print(data2[0]['guard_id'])

        query3 = f"""INSERT INTO public.visitor (
    home_id
    , firstname
    , lastname
    , license_plate
    , id_card
    , invite_date
    , class
    ,class_id
    , create_datetime
) VALUES (
    {(data[0]['home_id'])} -- home_id integer NULLABLE
    , \'{item.firstname}\' -- firstname character varying NULLABLE
    , \'{item.lastname}\' -- lastname character varying NULLABLE
    , \' \'
    , \'{item.id_number}\'  -- license_plate character varying NULLABLE
    , \'{date}\' -- invite_date date NULLABLE
    , \'guard\'
    , \'{(data2[0]['guard_id'])}\'
    , datetime.now()
)
        """
        data3 = await db.fetch_all(query3)
        data3 = jsonable_encoder(data3)

        query4 = f"""SELECT v.visitor_id
FROM public.visitor v
WHERE v.invite_date = \'{date}\'  AND v.id_card =  \'{item.id_number}\'
ORDER BY v.visitor_id
"""
        data4 = await db.fetch_all(query4)
        data4 = jsonable_encoder(data4)
        print(data4[0]['visitor_id'])

        query5 = f"""INSERT INTO public.history_log (
    class
    , class_id
    , datetime_in
    , create_datetime
    
) VALUES (
    \'visitor\' -- class_id character varying NULLABLE
    , {(data4[0]['visitor_id'])}
    , \'{item.datetime_in}\' -- datetime_in timestamp without time zone NULLABLE
    ,datetime.now()
    
)
"""
        data5 = await db.fetch_all(query5)
        data5 = jsonable_encoder(data5)

        return data


@app.put('/admin_stamp', status_code=200)
async def admin_stamp(item: Adminstamp, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.history_log
SET 
     admin_approve = {item.admin_approve} -- boolean NULLABLE
    , admin_reason = \'{item.admin_reason}\'
    ,admin_datetime = \'{item.admin_datetime}\'
WHERE public.history_log.log_id = {item.log_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

        return data


@app.put('/approve_blacklist', status_code=200)
async def approve_blacklist(item: ApproveBlacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.blacklist
SET 
     admin_approve = {item.admin_approve} -- boolean NULLABLE
    , admin_reason = \'{item.admin_reason}\'
    ,admin_datetime = \'{item.admin_datetime}\'
WHERE public.blacklist.blacklist_id = {item.blacklist_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

        return data


@app.put('/approve_whitelist', status_code=200)
async def approve_whitelist(item: ApproveWhitelist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.whitelist
SET 
     admin_approve = {item.admin_approve} -- boolean NULLABLE
    , admin_reason = \'{item.admin_reason}\'
    ,admin_datetime = \'{item.admin_datetime}\'
WHERE public.whitelist.whitelist_id = {item.whitelist_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

        return data


@app.get("/whitelist", status_code=200)
async def whitelist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT w.whitelist_id
     , w.home_id
     ,  h.home_number 
     , w.class
     , w.class_id
     , w.license_plate
     , w.firstname
     , w.lastname
     , w.resident_add_reason
     , w.admin_datetime
     , w.admin_approve
     , w.admin_reason
     , w.resident_remove_reason
     , w.resident_remove_datetime
     , w.create_datetime
FROM public.whitelist w
LEFT JOIN public.home h on w.home_id = h.home_id
ORDER BY  w.home_id, w.whitelist_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@app.get("/blacklist", status_code=200)
async def blacklist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT b.blacklist_id
     , b.home_id
     ,  h.home_number 
     , b.class
     , b.class_id
     , b.firstname
     , b.lastname
     , b.resident_add_reason
     , b.admin_datetime
     , b.admin_approve
     , b.admin_reason
     , b.resident_remove_reason
     , b.resident_remove_datetime
     , b.license_plate
     , b.create_datetime
FROM public.blacklist b
LEFT JOIN public.home h on b.home_id = h.home_id
ORDER BY b.home_id, b.blacklist_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

# ------------------------------ End Web Application  --------------------------------
# ------------------------------ Websocket  --------------------------------

manager = ConnectionManager()

@app.websocket("/ws/{token}/{apptype}/{home_id}")
async def websocket_endpoint(websocket: WebSocket, token: str, apptype: str, home_id: int):

    '''
        {
            "topic": "admin approve",
            "send_to": "app",
            "home_id": 0
        }
    '''

    status = auth_handler.auth_wrapper_socket(token)

    if status == 1001:
        await manager.connect(websocket, apptype, home_id)
            
        try:
            while True:
                data = await websocket.receive_text()
                # Convert data to dict
                data = json.loads(data)
                # Convert dict to string 
                # data_str = json.dumps(data)
                print(data)

                # await websocket.send_text(data['topic'])

                # await manager.send_personal_message(f"You wrote: {data}", websocket)
                await manager.broadcast(websocket, data['topic'], data['send_to'], data['home_id'])
        except WebSocketDisconnect:
            manager.disconnect(websocket, apptype)
            # await manager.broadcast(f"Client #{home_id} left the chat")

    elif status == 1008:
        manager.disconnect(websocket)


# ------------------------------ End Websocket  --------------------------------

if __name__ == '__main__':
    uvicorn.run("main:app", host="0.0.0.0", port=8080,
                workers=True, access_log=True, log_level="info")
