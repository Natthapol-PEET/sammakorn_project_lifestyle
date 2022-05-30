from fastapi import FastAPI,  Depends, HTTPException
from fastapi.encoders import jsonable_encoder

# database, schemas, models
from data.database import database as db
from data.profile_schemas import ProfileImageSchemas
from data.schemas import BlacklistIN, LoginDetails, ResidentId, \
    GuardhouseCheckin, GuardhouseAddvisitor, GuardhouseCheckout, \
    Adminstamp, ApproveBlacklist, ApproveWhitelist, WhitelistIN, startDateendDate,  \
    DeleteWhitelist, DeleteBlacklist, DeclineDeleteWhitelist, DeclineDeleteBlacklist, GetIDResident
from data.home_schemas import CreateHome, DeleteHome, UpdateHome
from data.password_schemas import ChangePassword, ConfirmPassword, ResetPassword
from data.recovery_password_schemas import ConfirmSchemas, RecoverySchemas
from data.resident_schemas import DeleteResident, RegisterResidentAccount, UpdateResidentAccount
from data.verify_schemas import VerifySchemas
from data.whitelist_schemas import UpdateWhitelist
from data.admin_schemas import CreateAdmin, DeleteAdmin, UpdateAdmin
from data.blacklist_schemas import UpdateBlacklist
from data.guard_schemas import CreateGuard, DeleteGuard, UpdateGuard
from data.models import home as HOME, resident_account, resident_car, resident_home, admin_account, guard_account

# apis
from apis.api import API

# auth
from auth.register import Register
from auth.login import Login
from auth.logout import Logout
from auth.auth import AuthHandler
from auth.check_token import is_token_blacklisted as isTokenBlacklisted

# utils
from utils import utils, manageMail

from datetime import datetime, timedelta
from icecream import ic
import uuid
from io import BytesIO
from PIL import Image
from fastapi.responses import StreamingResponse


tags_metadata = [
    {"name": "Admin", "description": ""},
    {"name": "Guard", "description": ""},
    {"name": "Login", "description": ""},
    {"name": "Logout", "description": ""},
    {"name": "Home", "description": ""},
    {"name": "Resident", "description": ""},
    {"name": "Password Management", "description": ""},
    {"name": "Whitelist", "description": ""},
    {"name": "Blacklist", "description": ""},
    {"name": "Profile", "description": ""},
    {"name": "Verify Password"},
    {"name": "Recovery Password"},
]

web_api = FastAPI(openapi_tags=tags_metadata)


register = Register()
login = Login()
auth_handler = AuthHandler()


# ------------------------------------- Admin ---------------------------

@web_api.post('/register_admin/', tags=["Admin"], status_code=201)
async def register_admin(auth_details: CreateAdmin):
    return await register.register_admin(db, auth_details=auth_details)


@web_api.get('/admin/', tags=["Admin"], status_code=200)
async def admin(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = admin_account.select()
    return await db.fetch_all(sql)


@web_api.delete('/admin/', tags=["Admin"], status_code=200)
async def admin(item: DeleteAdmin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f"DELETE FROM admin_account WHERE admin_id = {item.admin_id}"
    await db.execute(sql)
    return {"msg": "delete successful"}


@web_api.put('/admin/', tags=["Admin"], status_code=200)
async def guard(item: UpdateAdmin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f'''
        UPDATE admin_account
            SET firstname = '{item.firstname}',
                lastname = '{item.lastname}',
                username = '{item.username}',
                email = '{item.email}',
                role = '{item.role}',
                id_card = '{item.id_card}',
                active_user = {item.active_user}
            WHERE admin_id = {item.admin_id}

    '''
    await db.execute(sql)
    return {"msg": "update successful"}

# ------------------------------------- End Admin ---------------------------

# ------------------------------------- Guard ---------------------------


@web_api.post('/register_guard/', tags=["Guard"], status_code=201)
async def register_guard(auth_details: CreateGuard, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await register.register_guard(db, auth_details=auth_details)


@web_api.get('/guard/', tags=["Guard"], status_code=200)
async def guard(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = guard_account.select()
    return await db.fetch_all(sql)


@web_api.delete('/guard/', tags=["Guard"], status_code=200)
async def guard(item: DeleteGuard, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f"DELETE FROM guard_account WHERE guard_id = {item.guard_id}"
    await db.execute(sql)
    return {"msg": "delete successful"}


@web_api.put('/guard/', tags=["Guard"], status_code=200)
async def guard(item: UpdateGuard, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f'''
        UPDATE guard_account
            SET firstname = '{item.firstname}',
                lastname = '{item.lastname}',
                username = '{item.username}',
                email = '{item.email}',
                id_card = '{item.id_card}',
                active_user = {item.active_user},
                role = '{item.role}'
            WHERE guard_id = {item.guard_id}

    '''
    await db.execute(sql)
    return {"msg": "update successful"}
# ------------------------------------- End Guard ---------------------------


@web_api.post('/change_password_resident/', tags=["Password Management"], status_code=200)
async def change_password_resident(item: ChangePassword):
    query = f"SELECT resident_id, username, password FROM resident_account WHERE username = '{item.username}'"
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if auth_handler.verify_password(item.old_pass, result['password']):
            sql = f"UPDATE resident_account SET password = '{auth_handler.get_password_hash(item.new_pass)}' WHERE resident_id = {result['resident_id']}"
            await db.execute(sql)
        else:
            raise HTTPException(
                status_code=401, detail='Invalid Old Password')
    else:
        raise HTTPException(
            status_code=401, detail='No have username')

    return {"message": "Update Password Successful"}


@web_api.post('/change_password_admin/', tags=["Password Management"], status_code=200)
async def change_password_admin(item: ChangePassword):
    query = f"SELECT admin_id, username, password FROM admin_account WHERE username = '{item.username}'"
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if auth_handler.verify_password(item.old_pass, result['password']):
            sql = f"UPDATE admin_account SET password = '{auth_handler.get_password_hash(item.new_pass)}' WHERE admin_id = {result['admin_id']}"
            await db.execute(sql)
        else:
            raise HTTPException(
                status_code=401, detail='Invalid Old Password')
    else:
        raise HTTPException(
            status_code=401, detail='No have username')

    return {"message": "Update Password Successful"}


@web_api.post('/change_password_guard/', tags=["Password Management"], status_code=200)
async def change_password_guard(item: ChangePassword):
    query = f"SELECT guard_id, username, password FROM guard_account WHERE username = '{item.username}'"
    result = jsonable_encoder(await db.fetch_one(query))

    print(f'change_password_guard: {result}')

    if result:
        if auth_handler.verify_password(item.old_pass, result['password']):
            sql = f"UPDATE guard_account SET password = '{auth_handler.get_password_hash(item.new_pass)}' WHERE guard_id = {result['guard_id']}"
            await db.execute(sql)
        else:
            raise HTTPException(
                status_code=401, detail='Invalid Old Password')
    else:
        raise HTTPException(
            status_code=401, detail='No have username')

    return {"message": "Update Password Successful"}


@web_api.post('/reset_password_resident/', tags=["Password Management"], status_code=200)
async def reset_password_resident(item: ResetPassword):
    query = f"SELECT * FROM resident_account WHERE email = '{item.email}'"
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        # insert token table reset password
        sql = f'''
            INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                VALUES ('{str(uuid.uuid4())}', 'resident', {result['resident_id']}, {True}, '{datetime.now()}')
        '''
        # send mail
    else:
        raise HTTPException(
            status_code=401, detail='Invalid E-mail Address')

    return {"message": "Send link to E-mail Successful"}


@web_api.put('/reset_password_resident_confirm/', tags=["Password Management"], status_code=201)
async def reset_password_resident_confirm(item: ConfirmPassword):
    if item.new_pass == item.confirm_pass:
        pass
        # query role->resident, role_id
        query = f"SELECT role_id, is_use FROM reset_password WHERE key = {item.key}"
        result = await db.fetch_one(query)

        if result:
            if not result['is_use']:
                pass
                # update password
                # update reset_password -> is_use = True
            else:
                raise HTTPException(
                    status_code=401, detail='token expire')
        else:
            raise HTTPException(
                status_code=401, detail='invalid token')
    else:
        raise HTTPException(
            status_code=401, detail='Passwords do not match.')

    return {"message": "Update Password Successful"}

# ------------------------------------- Login ---------------------------


@web_api.post('/login_admin/', tags=["Login"], status_code=200)
async def login_admin(auth_details: LoginDetails):
    return await login.login_admin(db, auth_details=auth_details)


@web_api.post('/login_guard/', tags=["Login"], status_code=200)
async def login_guard(auth_details: LoginDetails):
    return await login.login_guard(db, auth_details=auth_details)

# ------------------------------------- End Login ---------------------------

# ------------------------------------- End Logout ---------------------------


@web_api.post("/logout/", tags=["Logout"], status_code=200)
async def logout(item: ResidentId, token=Depends(auth_handler.get_token)):
    return await Logout().logout(db, token=token, item=item)
# ------------------------------------- End Logout ---------------------------

# ------------------------------ Web Application  --------------------------------


@web_api.get("/visitorlist_log", status_code=200)
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
                    , v.qr_gen_id
                FROM   public.visitor v
                LEFT JOIN  public.home h on v.home_id = h.home_id
                LEFT JOIN public.history_log hl  on hl.class = 'visitor' AND hl.class_id = v.visitor_id
                WHERE v.invite_date = \'{date}\'
                --WHERE invite_date = now()
                ORDER BY v.visitor_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/whitelist_log", status_code=200)
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
                    ,w.id_card
                    ,w.email
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
                where w.admin_approve = TRUE """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/all_home", status_code=200)
async def all_home(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    query = "SELECT home_id AS id, home_name AS project, home_number AS address FROM home;"
    return await db.fetch_all(query)


@web_api.get("/blacklist_log", status_code=200)
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
                        , b.id_card
                    FROM public.blacklist b
                    LEFT JOIN  public.home h on b.home_id = h.home_id
                    LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{date}\'  and hl.datetime_in < \'{datep}\'
                    where b.admin_approve = TRUE
                    ORDER BY b.blacklist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/history_visitorlist", status_code=200)
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


@web_api.post("/history_visitorlist_date", status_code=200)
async def history_visitorlist_date(item: startDateendDate, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
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
                    WHERE v.invite_date > \'{item.datestart}\' and v.invite_date <= \'{item.dateend} 23:59\'
                    --WHERE invite_date = now()
                    ORDER BY v.visitor_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/history_whitelist", status_code=200)
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
                        , w.id_card
                        , w.email
                    FROM public.whitelist w
                    LEFT JOIN public.home h on w.home_id = h.home_id
                    LEFT JOIN public.history_log hl on hl.class = 'whitelist' AND hl.class_id = w.whitelist_id and hl.datetime_in > \'{datehis}\'  and hl.datetime_in < \'{datep}\'
                    --WHERE hl.datetime_in > '2021-07-14'  and hl.datetime_in < '2021-07-15'
                    ORDER BY w.whitelist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.post("/history_whitelist_date", status_code=200)
async def history_whitelist_date(item: startDateendDate, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
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
                        , w.id_card
                        , w.email
                    FROM public.whitelist w
                    LEFT JOIN public.home h on w.home_id = h.home_id
                    LEFT JOIN public.history_log hl on hl.class = 'whitelist' AND hl.class_id = w.whitelist_id and hl.datetime_in > \'{item.datestart}\'  and hl.datetime_in <= \'{item.dateend}\'
                    --WHERE hl.datetime_in > '2021-07-14'  and hl.datetime_in < '2021-07-15'
                    ORDER BY w.whitelist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/history_blacklist", status_code=200)
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
                    , b.id_card
                FROM public.blacklist b
                LEFT JOIN  public.home h on b.home_id = h.home_id
                LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{datehis}\'  and hl.datetime_in < \'{datep}\'
                ORDER BY b.blacklist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.post("/history_blacklist_date", status_code=200)
async def history_blacklist_date(item: startDateendDate, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
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
                    , b.id_card
                FROM public.blacklist b
                LEFT JOIN  public.home h on b.home_id = h.home_id
                LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{item.datestart}\'  and hl.datetime_in <= \'{item.dateend}\'
                ORDER BY b.blacklist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.post('/guardhouse_checkin', status_code=200)
async def guardhouse_checkin(item: GuardhouseCheckin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    xdatetime = f"{x.year}-{x.month}-{x.day} {x.hour}:{x.minute}:{x.second}.{x.microsecond}"
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
                    , \'{xdatetime}\'
                ) """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.put('/guardhouse_checkout', status_code=200)
async def guardhouse_checkout(item: GuardhouseCheckout, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.history_log
                    SET  datetime_out = \'{item.datetime_out}\' -- timestamp without time zone NULLABLE
                    WHERE public.history_log.log_id = {item.log_id} """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.post('/guardhouse_advisitor', status_code=200)
async def guardhouse_checkin(item: GuardhouseAddvisitor, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        # get home_id from home_number
        query = f"SELECT home_id FROM home WHERE home_number = '{item.home_number}'"
        home = jsonable_encoder(await db.fetch_one(query))
        home_id = home['home_id']
        ic(home_id)

        # get guard_id from guard_account
        query = f"SELECT guard_id FROM guard_account WHERE username = '{item.username}'"
        guard = jsonable_encoder(await db.fetch_one(query))
        guard_id = guard['guard_id']
        ic(guard_id)

        # generage qr code
        qr_gen_id = utils.generage_qr_code('V')
        ic(qr_gen_id)

        # send mail
        try:
            manageMail.sendMailToWhitelist(
                item.email, qr_gen_id, item.firstname, "Register Walk in")
        except:
            raise HTTPException(status_code=401, detail='Invalid email')

        # insert data to visitor
        query = f'''
            INSERT INTO visitor (home_id, class, class_id, firstname, lastname, license_plate, id_card, invite_date, qr_gen_id, create_datetime)
                VALUES ({home_id}, 'guard', {guard_id}, '{item.firstname}', '{item.lastname}', '{item.license_plate.strip()}', '{item.id_number}', '{item.datetime_in}', '{qr_gen_id}', '{datetime.now()}')
        '''
        result = await db.execute(query)
        ic(result)

        # get visitor id
        query = f"SELECT visitor_id FROM visitor WHERE qr_gen_id = '{qr_gen_id}'"
        visitor_id = await db.execute(query)
        ic(visitor_id)

        # ---------------------- insert history log -------------------------------
        query = f'''
            INSERT INTO history_log (class, class_id, datetime_in, create_datetime)
                VALUES ('visitor', {visitor_id}, '{datetime.now()}', '{datetime.now()}')
        '''
        result = await db.execute(query)
        ic(result)

        return home


@web_api.put('/admin_stamp', status_code=200)
async def admin_stamp(item: Adminstamp, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.history_log
                    SET  
                        resident_stamp = '{datetime.now()}'
                        -- admin_approve = {item.admin_approve} -- boolean NULLABLE
                        -- , admin_reason = \'{item.admin_reason}\'
                        -- ,admin_datetime = \'{item.admin_datetime}\'
                    WHERE public.history_log.log_id = {item.log_id} """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.put('/approve_blacklist', status_code=200)
async def approve_blacklist(item: ApproveBlacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.blacklist
                    SET 
                        admin_approve = {item.admin_approve} -- boolean NULLABLE
                        , admin_reason = \'{item.admin_reason}\'
                        ,admin_datetime = \'{item.admin_datetime}\'
                    WHERE public.blacklist.blacklist_id = {item.blacklist_id} """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.put('/approve_whitelist', status_code=200)
async def approve_whitelist(item: ApproveWhitelist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.whitelist
                    SET 
                        admin_approve = {item.admin_approve} -- boolean NULLABLE
                        , admin_reason = \'{item.admin_reason}\'
                        ,admin_datetime = \'{item.admin_datetime}\'
                    WHERE public.whitelist.whitelist_id = {item.whitelist_id}"""
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/whitelist", status_code=200)
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
                    , w.id_card
                    , w.email
                FROM public.whitelist w
                LEFT JOIN public.home h on w.home_id = h.home_id
                ORDER BY  w.home_id, w.whitelist_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/blacklist", status_code=200)
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
                    , b.id_card
                FROM public.blacklist b
                LEFT JOIN public.home h on b.home_id = h.home_id
                ORDER BY b.home_id, b.blacklist_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
#
        return data


@web_api.delete('/delete_whitelist', status_code=200)
async def delete_whitelist(item: DeleteWhitelist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""DELETE FROM
            --ONLY
            public.whitelist
            WHERE public.whitelist.whitelist_id = {item.whitelist_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.delete('/delete_blacklist', status_code=200)
async def delete_blacklist(item: DeleteBlacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""DELETE FROM
            --ONLY
            public.blacklist
            WHERE public.blacklist.blacklist_id = {item.blacklist_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.put('/decline_delete_whitelist', status_code=200)
async def decline_delete_whitelist(item: DeclineDeleteWhitelist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.whitelist
                    SET 
                         admin_decline_reason = \'{item.admin_decline_reason}\'
                        ,admin_decline_datetime = \'{item.admin_decline_datetime}\'
                        ,resident_remove_reason = null
                    WHERE public.whitelist.whitelist_id = {item.whitelist_id}"""
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.put('/decline_delete_blacklist', status_code=200)
async def decline_delete_blacklist(item: DeclineDeleteBlacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.blacklist
                    SET 
                        admin_decline_reason = \'{item.admin_decline_reason}\' 
                        , admin_decline_datetime = \'{item.admin_decline_datetime}\'
                        ,resident_remove_reason = null
                    WHERE public.blacklist.blacklist_id = {item.blacklist_id} """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data


@web_api.get("/get_resident_list", status_code=200)
async def get_project_list(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT t.resident_id
                    , t.firstname
                    , t.lastname
                    , t.username
                    , t.password
                    , t.email
                    , t.create_datetime
                    , rh.home_id
                    , h.home_name
                    , h.home_number
                FROM public.resident_account t
                LEFT JOIN  public.resident_home rh on t.resident_id = rh.resident_id
                LEFT JOIN  public.home h on rh.home_id = h.home_id
                ORDER BY t.resident_id"""

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
#
        return data


@web_api.put('/get_resident_id_select', status_code=200)
async def get_resident_id_select(item: GetIDResident, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""SELECT t.resident_id
            FROM public.resident_account t
            WHERE t.firstname = \'{item.firstname}\' AND t.lastname = \'{item.lastname}\' AND t.username = \'{item.username}\'
            ORDER BY t.resident_id"""

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

# ------------------------------ End Web Application  --------------------------------

# ----------------------- Home -----------------------------


@web_api.get('/home', status_code=200, tags=["Home"])
async def home(token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    query = HOME.select()
    return await db.fetch_all(query)


@web_api.post('/home', status_code=201, tags=["Home"])
async def home(item: CreateHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    query = HOME.insert().values(home_name=item.home_name, home_number=item.home_number,
                                 stamp_count=0, create_datetime=datetime.now())
    last_record_id = await db.execute(query)
    return {"home_id": last_record_id}


@web_api.put('/home', status_code=200, tags=["Home"])
async def home(item: UpdateHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f"SELECT * FROM home WHERE home_id = {item.home_id}"
    data = jsonable_encoder(await db.fetch_one(sql))

    if not data:
        raise HTTPException(status_code=401, detail='not have data')

    query = f'''
            UPDATE home 
                SET 
                    home_name = '{item.home_name}',
                    home_number = '{item.home_number}',
                    stamp_count = {item.stamp_count},
                    update_datetime = '{datetime.now()}'
                WHERE home_id = {item.home_id}
        '''
    await db.execute(query)
    return {'msg': 'update successful'}


@web_api.delete('/home', status_code=200, tags=["Home"])
async def home_delete(item: DeleteHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    # DELETE FROM visitor;
    sql = f"DELETE FROM visitor WHERE home_id = {item.home_id}"
    await db.execute(sql)

    # DELETE FROM whitelist;
    sql = f"DELETE FROM whitelist WHERE home_id = {item.home_id}"
    await db.execute(sql)

    # DELETE FROM blacklist;
    sql = f"DELETE FROM blacklist WHERE home_id = {item.home_id}"
    await db.execute(sql)

    # DELETE FROM resident_home;
    sql = f"DELETE FROM resident_home WHERE home_id = {item.home_id}"
    await db.execute(sql)

    # DELETE FROM home;
    sql = f"DELETE FROM home WHERE home_id = {item.home_id}"
    await db.execute(sql)

    return {'msg': 'successful'}


# -------------------- Register Resident ------------------

@web_api.get('/resident', status_code=200, tags=["Resident"])
async def resident(token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = '''
        SELECT * 
        FROM resident_account AS ra
        LEFT JOIN (
                SELECT * 
                FROM resident_home AS rh
                LEFT JOIN home AS h
                    ON rh.home_id = h.home_id
            ) rh
            ON ra.resident_id = rh.resident_id
        LEFT JOIN resident_car AS rc
            ON ra.resident_id = rc.resident_id
    '''
    query = resident_account.select()
    result = jsonable_encoder(await db.fetch_all(query))

    new_result = []

    for ite in result:
        query = f'''
            SELECT h.home_id, h.home_name, h.home_number
            FROM resident_home AS rh
            LEFT JOIN home AS h
            ON rh.home_id = h.home_id
            WHERE resident_id = {ite['resident_id']}
        '''
        ite['home'] = jsonable_encoder(await db.fetch_all(query))

        query = f"SELECT license_plate FROM resident_car WHERE resident_id = {ite['resident_id']}"
        ite['car'] = jsonable_encoder(await db.fetch_all(query))

        new_result.append(ite)

    return new_result


@web_api.post('/register_resident', status_code=201, tags=["Resident"])
async def resident(item: RegisterResidentAccount, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f"SELECT * FROM resident_account WHERE username = '{item.username}'"
    result = jsonable_encoder(await db.fetch_one(sql))
    if result:
        return {'msg': 'มีข้อมูลผู้ใช้แล้ว'}

    for home_id in item.home_id:
        sql = f"SELECT * FROM home WHERE home_id = {home_id}"
        result = jsonable_encoder(await db.fetch_one(sql))
        if not result:
            return {'msg': 'ไม่มีข้อมูลบ้านหลังนี้'}

    sql = resident_account.insert().values(
        firstname=item.firstname,
        lastname=item.lastname,
        username=item.username,
        password=auth_handler.get_password_hash(item.password),
        email=item.email,
        card_info=item.card_info,
        card_scan_position="position",
        active_user=True,
        id_card=item.id_card,
        home_id=int(item.home_id[0]))
    resident_id = await db.execute(sql)

    for home_id in item.home_id:
        sql = resident_home.insert().values(resident_id=resident_id,
                                            home_id=int(home_id), create_datetime=datetime.now())
        resident_home_id = await db.execute(sql)

    for license in item.license_plate:
        sql = resident_car.insert().values(resident_id=resident_id,
                                           license_plate=license, create_datetime=datetime.now())
        resident_car_id = await db.execute(sql)

    return {'msg': 'register successful'}


@web_api.put('/resident', status_code=200, tags=["Resident"])
async def resident(item: UpdateResidentAccount, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    sql = f'''
        UPDATE resident_account 
            SET firstname = '{item.firstname}',
                lastname = '{item.lastname}',
                username = '{item.username}',
                email = '{item.email}',
                card_info = '{item.card_info}',
                active_user = {item.active_user},
                id_card = '{item.id_card}'
            WHERE resident_id= {item.resident_id}
    '''
    await db.execute(sql)

    # delete resident_home and update resident_home
    sql = f"DELETE FROM resident_home WHERE resident_id = {item.resident_id}"
    await db.execute(sql)
    for home_id in item.home_id:
        sql = f"INSERT INTO resident_home VALUES ({item.resident_id}, {home_id}, '{datetime.now()}')"
        await db.execute(sql)

    # delete resident_car and update resident_car
    sql = f"DELETE FROM resident_car WHERE resident_id = {item.resident_id}"
    await db.execute(sql)
    for license in item.car:
        sql = f"INSERT INTO resident_car VALUES ({item.resident_id}, '{license}', '{datetime.now()}')"
        await db.execute(sql)

    return {'msg': 'update successful'}


@web_api.delete('/resident', status_code=200, tags=["Resident"])
async def resident(item: DeleteResident, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    # delete from resident car
    sql = f"DELETE FROM resident_car WHERE resident_id = {item.resident_id}"
    await db.execute(sql)

    # delete from resident home
    sql = f"DELETE FROM resident_home WHERE resident_id = {item.resident_id}"
    await db.execute(sql)

    # delete from resident account
    sql = f"DELETE FROM resident_account WHERE resident_id = {item.resident_id}"
    await db.execute(sql)

    return {'msg': 'delete successful'}


# ------------------- Whitelist ------------------------------
api = API()


@web_api.get("/get_whitelist/", tags=["Whitelist"], status_code=200)
async def get_whitelist():
    query = '''
        SELECT * 
            FROM whitelist AS w
            LEFT JOIN home AS h
                ON w.home_id = h.home_id
    '''
    return await db.fetch_all(query)


@web_api.post("/register_whitelist/", tags=["Whitelist"],  status_code=201)
async def register_whitelist(register: WhitelistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.register_whitelist(db, register=register, username=username)


@web_api.put("/put_whitelist/", tags=["Whitelist"], status_code=200)
async def put_whitelist(item: UpdateWhitelist):
    sql = f'''
        UPDATE whitelist
            SET
                home_id = {item.home_id},
                class = '{item.Class}',
                class_id = {item.class_id},
                firstname = '{item.firstname}',
                lastname = '{item.lastname}',
                resident_add_reason = '{item.resident_add_reason}',
                license_plate = '{item.license_plate}',
                qr_gen_id = '{item.qr_gen_id}',
                id_card = '{item.id_card}',
                email = '{item.email}'
            WHERE whitelist_id = {item.whitelist_id}
    '''
    await db.execute(sql)
    return {"message": "Update Successful"}


@web_api.delete("/delete_whitelist/", tags=["Whitelist"], status_code=200)
async def delete_whitelist(item: DeleteWhitelist):
    sql = f"DELETE FROM whitelist WHERE whitelist_id = {item.whitelist_id}"
    await db.execute(sql)
    return {"message": "Delete Successful"}

# -------------------- Blacklist -----------------------------


@web_api.get("/get_blacklist/", tags=["Blacklist"], status_code=200)
async def get_blacklist():
    query = '''
        SELECT * 
            FROM blacklist AS b
            LEFT JOIN home AS h
                ON b.home_id = h.home_id
    '''
    return await db.fetch_all(query)


@web_api.post("/register_blacklist/", tags=["Blacklist"],  status_code=201)
async def register_blacklist(register: BlacklistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await api.register_blacklist(db, register=register, username=username)


@web_api.put("/put_blacklist/", tags=["Blacklist"], status_code=200)
async def put_blacklist(item: UpdateBlacklist):
    sql = f'''
        UPDATE blacklist
            SET
                home_id = {item.home_id},
                class = '{item.Class}',
                class_id = {item.class_id},
                firstname = '{item.firstname}',
                lastname = '{item.lastname}',
                resident_add_reason = '{item.resident_add_reason}',
                license_plate = '{item.license_plate}',
                id_card = '{item.id_card}'
            WHERE blacklist_id = {item.blacklist_id}
    '''
    await db.execute(sql)
    return {"message": "Update Successful"}


@web_api.delete("/delete_blacklist/", tags=["Blacklist"], status_code=200)
async def delete_blacklist(item: DeleteBlacklist):
    sql = f"DELETE FROM blacklist WHERE blacklist_id = {item.blacklist_id}"
    await db.execute(sql)
    return {"message": "Delete Successful"}


# ------------------- Profile (Admin, Guard) -----------------------
@web_api.get("/admin/profile/{username}", tags=["Profile"], status_code=200)
async def admin_profile(username: str):
    query = admin_account.select().where(admin_account.c.username == username)
    return await db.fetch_one(query)


@web_api.get("/guard/profile/{username}", tags=["Profile"], status_code=200)
async def guard_profile(username: str):
    query = guard_account.select().where(guard_account.c.username == username)
    return await db.fetch_one(query)


@web_api.get("/guard/profile_image/{image_name}", tags=["Profile"], status_code=200)
async def guard_profile(image_name: str):
    image_name = 'images/profiles/' + image_name

    original_image = Image.open(image_name)
    filtered_image = BytesIO()
    original_image.save(filtered_image, "JPEG")
    filtered_image.seek(0)

    return StreamingResponse(filtered_image, media_type="image/jpeg")


# -------------------- Verify Password --------------------------
@web_api.post("/admin/verify", tags=["Verify Password"], status_code=200)
async def admin_verify(item: VerifySchemas):
    query = admin_account.select().where(admin_account.c.username == item.username)
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if auth_handler.verify_password(item.password, result["password"]):
            return {"message": "the password is correct"}
        else:
            return {"message": "Incorrect password"}
    return {"message": "no item."}


@web_api.post("/guard/verify", tags=["Verify Password"], status_code=200)
async def guard_verify(item: VerifySchemas):
    query = guard_account.select().where(guard_account.c.username == item.username)
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if auth_handler.verify_password(item.password, result["password"]):
            return {"message": "the password is correct"}
        else:
            return {"message": "Incorrect password"}
    return {"message": "no item."}


# ------------- Recovery Password ----------------------------------
@web_api.post("/admin/recovery", tags=["Recovery Password"], status_code=200)
async def admin_recovery(item: RecoverySchemas):
    # check email on table admin_account
    query = admin_account.select().where(admin_account.c.email == item.email)
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        # generage uuid and insert on reset_table
        key = str(uuid.uuid4())
        sql = f'''
            INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                VALUES ('{key}', 'admin', {result['admin_id']}, {False}, '{datetime.now()}')
        '''
        await db.execute(sql)

        # send email to user
        try:
            manageMail.sendMailRecoveryPassword(
                item.email, key, result["firstname"], item.url)
        except:
            return {"message": "Send link to E-mail Failed"}

        return {"message": "Send link to E-mail Successful"}
    else:
        raise HTTPException(
            status_code=401, detail='Invalid E-mail Address')


@web_api.post("/admin/confirm", tags=["Recovery Password"], status_code=200)
async def admin_confirm(item: ConfirmSchemas):
    # check uuid on table
    query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if not result["is_use"]:
            total_seconds = utils.calculaetTwoTime(result['create_datetime'])
            if total_seconds < 54000:
                # update password in admin_account
                sql = f'''
                    UPDATE admin_account
                        SET password = '{auth_handler.get_password_hash(item.new_password)}'
                        WHERE admin_id = {result['role_id']}
                '''
                await db.execute(sql)

                # update is_use in reset_password
                sql = f'''
                    UPDATE reset_password
                        SET is_use = True
                        WHERE key = '{item.key}'
                '''
                await db.execute(sql)

                return {"message": "Recovery Password Successful."}
            else:
                raise HTTPException(
                    status_code=401, detail='This key has timed out.')
        else:
            raise HTTPException(
                status_code=401, detail='This key has already been used.')
    else:
        raise HTTPException(
            status_code=401, detail='Invalid key')


@web_api.post("/guard/recovery", tags=["Recovery Password"], status_code=200)
async def guard_recovery(item: RecoverySchemas):
    # check email on table guard_account
    query = guard_account.select().where(guard_account.c.email == item.email)
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        # generage uuid and insert on reset_table
        key = str(uuid.uuid4())
        sql = f'''
            INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                VALUES ('{key}', 'guard', {result['guard_id']}, {False}, '{datetime.now()}')
        '''
        await db.execute(sql)

        # send email to user
        try:
            manageMail.sendMailRecoveryPassword(
                item.email, key, result["firstname"], item.url)
        except:
            return {"message": "Send link to E-mail Failed"}

        return {"message": "Send link to E-mail Successful"}
    else:
        raise HTTPException(
            status_code=401, detail='Invalid E-mail Address')


@web_api.post("/guard/confirm", tags=["Recovery Password"], status_code=200)
async def guard_confirm(item: ConfirmSchemas):
    # check uuid on table
    query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if not result["is_use"]:
            total_seconds = utils.calculaetTwoTime(result['create_datetime'])
            if total_seconds < 54000:
                # update password in guard_account
                sql = f'''
                    UPDATE guard_account
                        SET password = '{auth_handler.get_password_hash(item.new_password)}'
                        WHERE guard_id = {result['role_id']}
                '''
                await db.execute(sql)

                # update is_use in reset_password
                sql = f'''
                    UPDATE reset_password
                        SET is_use = True
                        WHERE key = '{item.key}'
                '''
                await db.execute(sql)

                return {"message": "Recovery Password Successful."}
            else:
                raise HTTPException(
                    status_code=401, detail='This key has timed out.')
        else:
            raise HTTPException(
                status_code=401, detail='This key has already been used.')
    else:
        raise HTTPException(
            status_code=401, detail='Invalid key')


@web_api.post("/resident/recovery", tags=["Recovery Password"], status_code=200)
async def resident_recovery(item: RecoverySchemas):
    # check email on table resident_account
    query = resident_account.select().where(resident_account.c.email == item.email)
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        # generage uuid and insert on reset_table
        key = str(uuid.uuid4())
        sql = f'''
            INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                VALUES ('{key}', 'resident', {result['resident_id']}, {False}, '{datetime.now()}')
        '''
        await db.execute(sql)

        # send email to user
        try:
            manageMail.sendMailRecoveryPassword(
                item.email, key, result["firstname"], item.url)
        except:
            return {"message": "Send link to E-mail Failed"}

        return {"message": "Send link to E-mail Successful"}
    else:
        raise HTTPException(
            status_code=401, detail='Invalid E-mail Address')


@web_api.post("/resident/confirm", tags=["Recovery Password"], status_code=200)
async def resident_confirm(item: ConfirmSchemas):
    # check uuid on table
    query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
    result = jsonable_encoder(await db.fetch_one(query))

    if result:
        if not result["is_use"]:
            total_seconds = utils.calculaetTwoTime(result['create_datetime'])
            if total_seconds < 54000:
                # update password in resident_account
                sql = f'''
                    UPDATE resident_account
                        SET password = '{auth_handler.get_password_hash(item.new_password)}'
                        WHERE resident_id = {result['role_id']}
                '''
                await db.execute(sql)

                # update is_use in reset_password
                sql = f'''
                    UPDATE reset_password
                        SET is_use = True
                        WHERE key = '{item.key}'
                '''
                await db.execute(sql)

                return {"message": "Recovery Password Successful."}
            else:
                raise HTTPException(
                    status_code=401, detail='This key has timed out.')
        else:
            raise HTTPException(
                status_code=401, detail='This key has already been used.')
    else:
        raise HTTPException(
            status_code=401, detail='Invalid key')
