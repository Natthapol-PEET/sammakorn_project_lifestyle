from fastapi import FastAPI,  Depends, HTTPException
from fastapi.encoders import jsonable_encoder

from data.schemas import RegisterDetails, LoginDetails, ResidentId, \
    GuardhouseCheckin, GuardhouseAddvisitor, GuardhouseCheckout, \
    Adminstamp, ApproveBlacklist, ApproveWhitelist, startDateendDate,  \
    DeleteWhitelist, DeleteBlacklist, DeclineDeleteWhitelist, DeclineDeleteBlacklist, GetIDResident

from data.database import database as db

from auth.register import Register
from auth.login import Login
from auth.logout import Logout
from auth.auth import AuthHandler

from datetime import datetime, timedelta
from auth.check_token import is_token_blacklisted as isTokenBlacklisted

tags_metadata = [
    {"name": "Register", "description": ""},
    {"name": "Login", "description": ""},
    {"name": "Logout", "description": ""},
]

web_api = FastAPI(openapi_tags=tags_metadata)


register = Register()
login = Login()
auth_handler = AuthHandler()


# ------------------------------------- Register ---------------------------

@web_api.post('/register_admin/', tags=["Register"], status_code=201)
async def register_admin(auth_details: RegisterDetails):
    return await register.register_admin(db, auth_details=auth_details)


@web_api.post('/register_guard/', tags=["Register"], status_code=201)
async def register_guard(auth_details: RegisterDetails):
    return await register.register_guard(db, auth_details=auth_details)

# ------------------------------------- End Register ---------------------------

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
    print(datep)
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
    print(datep)
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
        # print(data[0]['class'])

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
        # print(data[0]['class'])

        return data


@web_api.post('/guardhouse_advisitor', status_code=200)
async def guardhouse_checkin(item: GuardhouseAddvisitor, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    x = datetime.now()
    date = f"{x.year}-{x.month}-{x.day}"
    xdatetime = f"{x.year}-{x.month}-{x.day} {x.hour}:{x.minute}:{x.second}.{x.microsecond}"
    # print(xdatetime)
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
                        , \'{xdatetime}\'
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
                        ,\'{xdatetime}\'
                        
                    )
                    """
        data5 = await db.fetch_all(query5)
        data5 = jsonable_encoder(data5)

        return data


@web_api.put('/admin_stamp', status_code=200)
async def admin_stamp(item: Adminstamp, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):

    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    else:
        query = f"""UPDATE public.history_log
                    SET 
                        admin_approve = {item.admin_approve} -- boolean NULLABLE
                        , admin_reason = \'{item.admin_reason}\'
                        ,admin_datetime = \'{item.admin_datetime}\'
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
        # print(data[0]['class'])

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
                    WHERE public.whitelist.whitelist_id = {item.whitelist_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

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
        # print(data[0]['class'])

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
        # print(data[0]['class'])

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
                    WHERE public.whitelist.whitelist_id = {item.whitelist_id}
        """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])

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
        # print(data[0]['class'])

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
ORDER BY t.resident_id  """

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
ORDER BY t.resident_id
     """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)
        # print(data[0]['class'])123

        return data
# ------------------------------ End Web Application  --------------------------------
