import base64
import os
from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from fastapi.responses import StreamingResponse
from auth.auth import AuthHandler
from auth.check import Check

from data.schemas import VisitorIN, WhitelistIN, BlacklistIN
from datetime import date, datetime, timedelta

from utils import utils, manageMail
from icecream import ic

from utils.verify_id_card import isThaiNationalID

import uuid
from io import BytesIO
from PIL import Image

from data.models import home as HOME, resident_account, resident_car, resident_home, admin_account, guard_account
# from utils.CroppingThaiPersonalDrivingLicense.Personal import Personal
# from utils.CroppingThaiPersonalDrivingLicense.DrivingLicense import DrivingLicense

from configs import config

auth_handler = AuthHandler()
check = Check()

# personalCard = Personal(path_to_save="images/Extract")
# drivingLicense = DrivingLicense()

# ------------------------------------- Application ---------------------------


class API:
    async def Invite_Visitor(self, db, item: VisitorIN, username):
        # verify thai personal
        if not isThaiNationalID(item.id_card):
            raise HTTPException(
                status_code=202, detail='หมายเลขบัตรประจำตัวประชาชนไม่ถูกต้อง')

        # check whitelist UNION blacklist
        command = f'''
            SELECT whitelist_id FROM whitelist as w
                WHERE CONCAT(w.firstname, w.lastname) = '{item.firstname + item.lastname}'
            UNION
            SELECT blacklist_id FROM blacklist as b
                WHERE CONCAT(b.firstname, b.lastname) = '{item.firstname + item.lastname}'
        '''
        result = jsonable_encoder(await db.fetch_one(command))

        if result is None:
            # ตรวจสอบว่า visitor นี้เพิ่มเข้ามาหรือยัง
            command = f'''
               SELECT COALESCE(MAX(visitor_id), 0) AS visitor_id FROM visitor AS v
                    WHERE CONCAT(v.firstname, v.lastname) = '{item.firstname + item.lastname}'
                        AND invite_date = '{item.invite_date}'
            '''
            visitor_id = jsonable_encoder(await db.fetch_one(command))['visitor_id']

            # ยังไม่มีในรายการ
            if visitor_id == 0:
                # insert visitor
                command = f'''
                        INSERT INTO visitor (home_id, class, class_id, firstname, lastname, license_plate, id_card, invite_date, create_datetime, qr_gen_id)
	                        VALUES ({item.home_id}, '{item.Class}', {item.class_id}, '{item.firstname}', '{item.lastname}', '{item.license_plate.strip()}', '{item.id_card}', '{item.invite_date}', '{datetime.now()}', '{item.qrGenId}')
                    '''
                await db.execute(command)
                return 201
            else:
                # มีใน visitor แต่ไม่มีใน history_log                       ไม่เพิ่ม [None]
                # มีทั้ง visitor และ history_log แต่ datetime_out = NULL    ไม่เพิ่ม [None]
                # มีทั้ง visitor และ history_log และ datetime_out NOT NULL     เพิ่ม [Not null]
                command = f'''
                    SELECT v.visitor_id 
                    FROM visitor AS v
                    LEFT JOIN history_log AS h
                    ON v.visitor_id = h.class_id
                    WHERE v.visitor_id = {visitor_id}
                        AND h.class = 'visitor'
                        AND h.datetime_out is not NULL
                '''
                result = jsonable_encoder(await db.fetch_one(command))

                if result is not None:
                    # insert visitor
                    command = f'''
                        INSERT INTO visitor (home_id, class, class_id, firstname, lastname, license_plate, id_card, invite_date, create_datetime, qr_gen_id)
	                        VALUES ({item.home_id}, '{item.Class}', {item.class_id}, '{item.firstname}', '{item.lastname}', '{item.license_plate.strip()}', '{item.id_card}', '{item.invite_date}', '{datetime.now()}', '{item.qrGenId}')
                    '''
                    await db.execute(command)
                    return 201
                else:
                    raise HTTPException(
                        status_code=202, detail='บุคคลนี้ได้ลงทะเบียนไว้ก่อนหน้านี้แล้ว')
        else:
            raise HTTPException(
                status_code=202, detail=f'บุคคลนี้เป็น {result["type"]}')

    async def register_whitelist(self, db, item: WhitelistIN, username):
        await check.check_in_whitelist(db, item)
        await check.check_in_blacklist(db, item)
        await check.check_resident(db, item)
        await check.check_guard(db, item)
        await check.check_thai_id(item)
        await check.check_email_whitelist(db, item)

        qrGenId = utils.generage_qr_code('W')
        cdt = datetime.now()

        command = f'''
            INSERT INTO whitelist (
                home_id, 
                class, 
                class_id, 
                firstname, 
                lastname, 
                license_plate, 
                create_datetime, 
                resident_add_reason, 
                admin_approve,
                admin_datetime,
                qr_gen_id,
                id_card,
                email
            )
                VALUES (
                    {item.home_id}, 
                    '{item.Class}', 
                    {item.id}, 
                    '{item.firstname.replace(" ", "")}', 
                    '{item.lastname.replace(" ", "")}', 
                    '{item.license_plate.strip()}',
                    '{cdt}', 
                    '', 
                    '{True}',
                    '{datetime.now()}', 
                    '{qrGenId}',
                    '{item.id_card.replace(" ", "")}',
                    '{item.email.replace(" ", "")}'
                );
        '''
        await db.execute(command)

        sql = f"SELECT * FROM home WHERE home_id = {item.home_id}"
        home = await db.fetch_one(sql)

        # Send Email to Whitelist
        manageMail.sendMailToWhitelist(
            item, home, qrGenId, f"{cdt.year}-{cdt.month}-{cdt.day}")

        return 201

    async def register_blacklist(self, db, item: BlacklistIN, username):
        await check.check_admin(db, item)
        await check.check_resident(db, item)
        await check.check_guard(db, item)
        await check.check_in_whitelist(db, item)
        await check.check_in_blacklist(db, item)

        command = f'''
                INSERT INTO blacklist (
                    home_id, 
                    class, 
                    class_id, 
                    firstname, 
                    lastname, 
                    license_plate, 
                    create_datetime, 
                    resident_add_reason,
                    admin_approve,
                    admin_datetime,
                    id_card
                )
                    VALUES (
                        {item.home_id}, 
                        '{item.Class}', 
                        {item.id}, 
                        '{item.firstname.replace(" ", "")}', 
                        '{item.lastname.replace(" ", "")}', 
                        '{item.license_plate.strip()}', 
                        '{datetime.now()}', 
                        '',
                        {True},
                        '{datetime.now()}',
                        '{item.id_card.replace(" ", "")}'
                    )
            '''
        await db.execute(command)
        return 201

    async def v2_update_home(self, db, item):
        query = f"UPDATE resident_account SET home_id = {item.home_id} WHERE resident_id = {item.resident_id};"
        return await db.fetch_one(query)

    async def v2_get_whitelist(self, db, item):
        query = f'''
            -- whitelist
            SELECT w.whitelist_id, w.home_id, w.class as addby, w.class_id as addby_id, w.firstname, w.lastname, w.license_plate, w.qr_gen_id, w.id_card, w.email, w.create_datetime as whitelist_create_datetime
                ,h.log_id, h.class, h.datetime_in, h.resident_stamp, h.datetime_out, h.create_datetime
                FROM whitelist AS w
                RIGHT JOIN history_log AS h
                    ON w.whitelist_id = h.class_id
                WHERE w.home_id = {item.home_id}
                ORDER BY h.log_id DESC
        '''
        return await db.fetch_all(query)

    async def v2_get_visitor(self, db, item):
        query = f'''
            -- visitor
            SELECT v.visitor_id, v.home_id, v.class as addby, v.class_id as addby_id, v.firstname, v.lastname, v.license_plate, v.id_card, v.invite_date, v.qr_gen_id, v.create_datetime as visitor_create_datetime
                ,h.log_id, h.class, h.class_id, h.datetime_in, h.resident_stamp, h.datetime_out, h.create_datetime
            FROM visitor AS v
            LEFT JOIN history_log AS h
                ON v.visitor_id = h.class_id
            WHERE v.home_id = {item.home_id}
            ORDER BY v.visitor_id DESC
        '''
        return await db.fetch_all(query)

    # ------------------------------------- Admin ---------------------------
    async def get_admin(self, db):
        sql = admin_account.select()
        return await db.fetch_all(sql)

    async def delete_admin(self, db, item):
        sql = f"DELETE FROM admin_account WHERE admin_id = {item.admin_id}"
        await db.execute(sql)
        return {"detail": "delete successful"}

    async def update_admin(self, db, item):
        await check.check_thai_id(item)
        await check.check_in_blacklist(db, item)
        await check.check_admin(db, item, isUpdate=True)

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
        return {"detail": "update successful"}

    # ------------------------------------- Guard ---------------------------

    async def get_guard(self, db):
        sql = guard_account.select()
        return await db.fetch_all(sql)

    async def delete_guard(self, db, item):
        sql = f"DELETE FROM guard_account WHERE guard_id = {item.guard_id}"
        await db.execute(sql)
        return {"detail": "delete successful"}

    async def update_guard(self, db, item):
        await check.check_thai_id(item)
        await check.check_in_blacklist(db, item)
        await check.check_guard(db, item, isUpdate=True)

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
        return {"detail": "update successful"}

    # --------------------------- Change Password ------------------------------------------
    async def change_password_resident(self, db, item):
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

        return {"detail": "Update Password Successful"}

    async def change_password_admin(self, db, item):
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

        return {"detail": "Update Password Successful"}

    async def change_password_guard(self, db, item):
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

        return {"detail": "Update Password Successful"}

    # --------------------- Reset Password -----------------------------------------
    async def reset_password_resident(self, db, item):
        query = f'''
            SELECT ra.resident_id, email, firstname, lastname, id_card, home_name, home_number, license_plate
                FROM resident_account AS ra
                LEFT JOIN (
                    SELECT * FROM resident_home
                    LEFT JOIN home
                        ON resident_home.home_id = home.home_id
                ) rh
                ON ra.resident_id = rh.resident_id
                LEFT JOIN resident_car AS rc
                    ON ra.resident_id = rc.resident_id
                WHERE email = '{item.email}'
              '''

        result = await db.fetch_one(query)

        if jsonable_encoder(result):
            # insert token table reset password
            key = str(uuid.uuid4())
            sql = f'''
                INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                    VALUES ('{key}', 'resident', {result.resident_id}, {True}, '{datetime.now()}')
            '''
            await db.execute(sql)

            # send mail
            manageMail.resetPasswordAndSendmail(result, key)
        else:
            raise HTTPException(
                status_code=401, detail='Invalid E-mail Address')

        return {"detail": "Send link to E-mail Successful"}

    async def reset_password_resident_confirm(self, db, item):
        if item.new_pass == item.confirm_pass:
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

        return {"detail": "Update Password Successful"}

    # ------------------------- Web Application ---------------------------------------

    async def visitorlist_log(self, db):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
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

    async def whitelist_log(self, db):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
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

    async def all_home(self, db):
        query = "SELECT home_id AS id, home_name AS project, home_number AS address FROM home;"
        return await db.fetch_all(query)

    async def blacklist_log(self, db):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
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

    async def history_visitorlist(self, db):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
        dayhis = x - timedelta(days=5)
        datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"

        query = f"""SELECT *
                    FROM   public.visitor v
                    LEFT JOIN  public.home h on v.home_id = h.home_id
                    LEFT JOIN public.history_log hl  on hl.class = 'visitor' AND hl.class_id = v.visitor_id
                    WHERE v.invite_date > \'{datehis}\' and v.invite_date < \'{datep}\'
                    --WHERE invite_date = now()
                    ORDER BY v.visitor_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def history_visitorlist_date(self, db, item):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
        dayhis = x - timedelta(days=5)
        datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"

        query = f"""SELECT *
                    FROM   public.visitor v
                    LEFT JOIN  public.home h on v.home_id = h.home_id
                    LEFT JOIN public.history_log hl  on hl.class = 'visitor' AND hl.class_id = v.visitor_id
                    WHERE v.invite_date > \'{item.datestart}\' and v.invite_date <= \'{item.dateend} 23:59\'
                    --WHERE invite_date = now()
                    ORDER BY v.visitor_id  """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def history_whitelist(self, db):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
        dayhis = x - timedelta(days=5)
        datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"

        query = f'''
            SELECT *
                FROM public.whitelist w
                LEFT JOIN public.home h 
                    ON w.home_id = h.home_id
                LEFT JOIN public.history_log hl 
                    ON hl.class = 'whitelist' AND hl.class_id = w.whitelist_id and hl.datetime_in > '{datehis}'  and hl.datetime_in < '{datep}'
            ORDER BY w.whitelist_id
        '''

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def history_whitelist_date(self, db, item):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
        dayhis = x - timedelta(days=5)
        datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"

        query = f"""SELECT *
                    FROM public.whitelist w
                    LEFT JOIN public.home h on w.home_id = h.home_id
                    LEFT JOIN public.history_log hl on hl.class = 'whitelist' AND hl.class_id = w.whitelist_id and hl.datetime_in > \'{item.datestart}\'  and hl.datetime_in <= \'{item.dateend}\'
                    --WHERE hl.datetime_in > '2021-07-14'  and hl.datetime_in < '2021-07-15'
                    ORDER BY w.whitelist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def history_blacklist(self, db):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
        dayhis = x - timedelta(days=5)
        datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"

        query = f"""SELECT *
                FROM public.blacklist b
                LEFT JOIN  public.home h on b.home_id = h.home_id
                LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{datehis}\'  and hl.datetime_in < \'{datep}\'
                ORDER BY b.blacklist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def history_blacklist_date(self, db, item):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        dayp = x + timedelta(days=1)
        datep = f"{dayp.year}-{dayp.month}-{dayp.day}"
        dayhis = x - timedelta(days=5)
        datehis = f"{dayhis.year}-{dayhis.month}-{dayhis.day}"

        query = f"""SELECT *
                FROM public.blacklist b
                LEFT JOIN  public.home h on b.home_id = h.home_id
                LEFT JOIN public.history_log hl on hl.class = 'blacklist' AND hl.class_id = b.blacklist_id and hl.datetime_in > \'{item.datestart}\'  and hl.datetime_in <= \'{item.dateend}\'
                ORDER BY b.blacklist_id """

        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def guardhouse_checkin(self, db, item):
        x = datetime.now()
        date = f"{x.year}-{x.month}-{x.day}"
        xdatetime = f"{x.year}-{x.month}-{x.day} {x.hour}:{x.minute}:{x.second}.{x.microsecond}"

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

    async def guardhouse_checkout(self, db, item):
        query = f"""UPDATE public.history_log
                    SET  datetime_out = \'{item.datetime_out}\' -- timestamp without time zone NULLABLE
                    WHERE public.history_log.log_id = {item.log_id} """
        data = await db.fetch_all(query)
        data = jsonable_encoder(data)

        return data

    async def guardhouse_advisitor(self, db, item):
        await check.check_thai_id(item)
        await check.check_in_whitelist(db, item)
        await check.check_in_blacklist(db, item)

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

    #  -------------------------- Home -------------------------------------------------

    async def get_home(self, db):
        query = HOME.select()
        return await db.fetch_all(query)

    async def create_home(self, db, item):
        query = HOME.insert().values(home_name=item.home_name, home_number=item.home_number,
                                     stamp_count=0, create_datetime=datetime.now())
        last_record_id = await db.execute(query)
        return {"home_id": last_record_id}

    async def update_home(self, db, item):
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
        return {'detail': 'update successful'}

    async def delete_home(self, db, item):
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

        return {'detail': 'successful'}

    # -------------------- Register Resident ------------------

    async def get_resident(self, db):
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

    async def register_resident(self, db, item):
        await check.check_resident(db, item)
        await check.check_in_blacklist(db, item)
        await check.check_in_whitelist(db, item)
        await check.check_thai_id(item)
        await check.check_email_resident(db, item)

        for home_id in item.home_id:
            sql = f"SELECT * FROM home WHERE home_id = {home_id}"
            result = jsonable_encoder(await db.fetch_one(sql))
            if not result:
                raise HTTPException(
                    status_code=401, detail='There is no information about this house')

        sql = resident_account.insert().values(
            firstname=item.firstname.replace(" ", ""),
            lastname=item.lastname.replace(" ", ""),
            username=item.username.replace(" ", ""),
            password=auth_handler.get_password_hash(
                item.password.replace(" ", "")),
            email=item.email.replace(" ", ""),
            card_info=item.card_info.replace(" ", ""),
            card_scan_position="position",
            active_user=True,
            id_card=item.id_card.replace(" ", ""),
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

        query = f'''
            SELECT * 
                FROM resident_home AS rh
                LEFT JOIN home AS h
                    ON rh.home_id = h.home_id
                WHERE rh.resident_id = {resident_id}
        '''

        listHome = []
        home = await db.fetch_all(query)
        for h in home:
            listHome.append(f"{h.home_name} {h.home_number}")

        manageMail.register_resident(item, listHome)

        return {'detail': 'register successful'}

    async def update_resident(self, db, item):
        await check.check_thai_id(item)
        await check.check_in_blacklist(db, item)
        await check.check_resident(db, item, isUpdate=True)

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

        return {'detail': 'update successful'}

    async def delete_resident(seld, db, item):
        # delete from resident car
        sql = f"DELETE FROM resident_car WHERE resident_id = {item.resident_id}"
        await db.execute(sql)

        # delete from resident home
        sql = f"DELETE FROM resident_home WHERE resident_id = {item.resident_id}"
        await db.execute(sql)

        # delete from resident account
        sql = f"DELETE FROM resident_account WHERE resident_id = {item.resident_id}"
        await db.execute(sql)

        return {'detail': 'delete successful'}

    # ---------------------- Whitelist ------------------------------------------

    async def get_whitelist(self, db):
        query = '''
            SELECT * 
                FROM whitelist AS w
                LEFT JOIN home AS h
                    ON w.home_id = h.home_id
        '''
        return await db.fetch_all(query)

    async def update_whitelist(self, db, item):
        await check.check_in_whitelist(db, item, isUpdate=True)
        await check.check_resident(db, item)
        await check.check_in_blacklist(db, item)
        await check.check_thai_id(item)

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
        return {"detail": "Update Successful"}

    async def delete_whitelist(self, db, item):
        sql = f"DELETE FROM whitelist WHERE whitelist_id = {item.whitelist_id}"
        await db.execute(sql)
        return {"detail": "Delete Successful"}

    # ---------------------- Blacklist ------------------------------------------

    async def get_blacklist(self, db):
        query = '''
            SELECT * 
                FROM blacklist AS b
                LEFT JOIN home AS h
                    ON b.home_id = h.home_id
        '''
        return await db.fetch_all(query)

    async def update_blacklist(self, db, item):
        await check.check_in_blacklist(db, item, isUpdate=True)
        await check.check_admin(db, item)
        await check.check_resident(db, item)
        await check.check_in_whitelist(db, item)

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
        return {"detail": "Update Successful"}

    async def delete_blacklist(self, db, item):
        sql = f"DELETE FROM blacklist WHERE blacklist_id = {item.blacklist_id}"
        await db.execute(sql)
        return {"detail": "Delete Successful"}

    # ------------------- Profile (Admin, Guard) -----------------------
    async def admin_profile(self, db, username):
        query = admin_account.select().where(admin_account.c.username == username)
        return await db.fetch_one(query)

    async def guard_profile(self, db, username):
        query = guard_account.select().where(guard_account.c.username == username)
        return await db.fetch_one(query)

    async def guard_profile_image(self, image_name):
        try:
            type = image_name.split('.')[1]
            print(f"type: {type}")
            print("JPEG" if type == 'jpg' else 'PNG')

            # image_name = f"images/profiles/{image_name}"
            image_name =  os.path.join(config.pathProfile, image_name)
            print(f"image_name: {image_name}")


            original_image = Image.open(image_name)
            filtered_image = BytesIO()
            original_image.save(
                filtered_image, "JPEG" if type == "jpg" else "PNG")
            filtered_image.seek(0)

            media_type = "image/jpeg" if type == "jpg" else  "image/png"
            print(f"media_type: {media_type}")

            return StreamingResponse(filtered_image, media_type=media_type)
        except:
            raise HTTPException(
                status_code=400, detail='Invalid filename.')

    # -------------------- Verify Password --------------------------

    async def admin_verify(self, db, item):
        query = admin_account.select().where(admin_account.c.username == item.username)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            if auth_handler.verify_password(item.password, result["password"]):
                return {"detail": "the password is correct"}
            else:
                raise HTTPException(
                    status_code=401, detail='Incorrect password')
        raise HTTPException(
            status_code=401, detail='no item')

    async def guard_verify(self, db, item):
        query = guard_account.select().where(guard_account.c.username == item.username)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            if auth_handler.verify_password(item.password, result["password"]):
                return {"detail": "the password is correct"}
            else:
                raise HTTPException(
                    status_code=401, detail='Incorrect password')
        raise HTTPException(
            status_code=401, detail='no item')

    # ------------- Recovery Password ----------------------------------

    async def admin_recovery(self, db, item):
        # check email on table admin_account
        query = admin_account.select().where(admin_account.c.email == item.email)
        result = await db.fetch_one(query)

        if jsonable_encoder(result):
            # generage uuid and insert on reset_table
            key = str(uuid.uuid4())
            sql = f'''
                INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                    VALUES ('{key}', 'admin', {result.admin_id}, {False}, '{datetime.now()}')
            '''
            await db.execute(sql)

            # send email to admin
            try:
                manageMail.sendMailRecoveryPassword(result, key, 'admin')
            except:
                raise HTTPException(
                    status_code=401, detail='Send link to E-mail Failed')

            return {"detail": "Send link to E-mail Successful"}
        else:
            raise HTTPException(
                status_code=401, detail='Invalid E-mail Address')

    # async def admin_confirm(self, db, item):
    #     # check uuid on table
    #     query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
    #     result = jsonable_encoder(await db.fetch_one(query))

    #     if result:
    #         if not result["is_use"]:
    #             total_seconds = utils.calculaetTwoTime(result['create_datetime'])
    #             if total_seconds < 54000:
    #                 # update password in admin_account
    #                 sql = f'''
    #                     UPDATE admin_account
    #                         SET password = '{auth_handler.get_password_hash(item.new_password)}'
    #                         WHERE admin_id = {result['role_id']}
    #                 '''
    #                 await db.execute(sql)

    #                 # update is_use in reset_password
    #                 sql = f'''
    #                     UPDATE reset_password
    #                         SET is_use = True
    #                         WHERE key = '{item.key}'
    #                 '''
    #                 await db.execute(sql)

    #                 return {"detail": "Recovery Password Successful."}
    #             else:
    #                 raise HTTPException(
    #                     status_code=401, detail='This key has timed out.')
    #         else:
    #             raise HTTPException(
    #                 status_code=401, detail='This key has already been used.')
    #     else:
    #         raise HTTPException(
    #             status_code=401, detail='Invalid key')

    async def guard_recovery(self, db, item):
        # check email on table guard_account
        query = guard_account.select().where(guard_account.c.email == item.email)
        result = await db.fetch_one(query)

        if jsonable_encoder(result):
            # generage uuid and insert on reset_table
            key = str(uuid.uuid4())
            sql = f'''
                INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                    VALUES ('{key}', 'guard', {result.guard_id}, {False}, '{datetime.now()}')
            '''
            await db.execute(sql)

            # send email to admin
            try:
                manageMail.sendMailRecoveryPassword(result, key, 'guard')
            except:
                raise HTTPException(
                    status_code=401, detail='Send link to E-mail Failed')

            return {"detail": "Send link to E-mail Successful"}
        else:
            raise HTTPException(
                status_code=401, detail='Invalid E-mail Address')

    async def confirm(self, db, item):
        # check uuid on table
        query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
        result = await db.fetch_one(query)

        if jsonable_encoder(result):
            if not result.is_use:
                total_seconds = utils.calculaetTwoTime(result.create_datetime)
                if total_seconds < 54000:
                    # check & update password

                    if result.role == 'admin':
                        sql = f'''
                            UPDATE admin_account
                                SET password = '{auth_handler.get_password_hash(item.new_password)}'
                                WHERE admin_id = {result.role_id}
                        '''
                    elif result.role == 'guard':
                        sql = f'''
                            UPDATE guard_account
                                SET password = '{auth_handler.get_password_hash(item.new_password)}'
                                WHERE guard_id = {result.role_id}
                        '''
                    elif result.role == 'resident':
                        sql = f'''
                            UPDATE resident_account
                                SET password = '{auth_handler.get_password_hash(item.new_password)}'
                                WHERE resident_id = {result.role_id}
                        '''
                    await db.execute(sql)

                    # update is_use in reset_password
                    sql = f"UPDATE reset_password SET is_use = True WHERE key = '{item.key}'"
                    await db.execute(sql)

                    return {"detail": "Recovery Password Successful."}
                else:
                    raise HTTPException(
                        status_code=401, detail='This key has timed out.')
            else:
                raise HTTPException(
                    status_code=401, detail='This key has already been used.')
        else:
            raise HTTPException(
                status_code=401, detail='Invalid key')

    async def guard_confirm(self, db, item):
        # check uuid on table
        query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            if not result["is_use"]:
                total_seconds = utils.calculaetTwoTime(
                    result['create_datetime'])
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

                    return {"detail": "Recovery Password Successful."}
                else:
                    raise HTTPException(
                        status_code=401, detail='This key has timed out.')
            else:
                raise HTTPException(
                    status_code=401, detail='This key has already been used.')
        else:
            raise HTTPException(
                status_code=401, detail='Invalid key')

    async def resident_recovery(self, db, item):
        # check email on table resident_account
        query = resident_account.select().where(resident_account.c.email == item.email)
        result = await db.fetch_one(query)

        if jsonable_encoder(result):
            # generage uuid and insert on reset_table
            key = str(uuid.uuid4())
            sql = f'''
                INSERT INTO reset_password (key, role, role_id, is_use, create_datetime) 
                    VALUES ('{key}', 'resident', {result.resident_id}, {False}, '{datetime.now()}')
            '''
            await db.execute(sql)

            # send email to resident
            try:
                manageMail.sendMailRecoveryPassword(result, key, 'resident')
            except:
                raise HTTPException(
                    status_code=401, detail='Send link to E-mail Failed')

            return {"detail": "Send link to E-mail Successful"}
        else:
            raise HTTPException(
                status_code=401, detail='Invalid E-mail Address')

    async def resident_confirm(self, db, item):
        # check uuid on table
        query = f"SELECT * FROM reset_password WHERE key = '{item.key}'"
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            if not result["is_use"]:
                total_seconds = utils.calculaetTwoTime(
                    result['create_datetime'])
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

                    return {"detail": "Recovery Password Successful."}
                else:
                    raise HTTPException(
                        status_code=401, detail='This key has timed out.')
            else:
                raise HTTPException(
                    status_code=401, detail='This key has already been used.')
        else:
            raise HTTPException(
                status_code=401, detail='Invalid key')

    async def admin_stamp(self, db, item):
        print(item)

        # stamp history log
        sql = f"UPDATE history_log SET resident_stamp = '{datetime.now()}' WHERE log_id = {item.log_id}"
        await db.execute(sql)

        return {'detail': 'stamp successful'}

    # ------------------- Imin API ----------------------------------

    async def exit_project(self, db):
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

        return {
            "resultVisitor": resultVisitor,
            "resultWhitelist": resultWhitelist,
        }

    async def post_exit_project(self, db, item):
        sql = f'''
            UPDATE history_log
                SET datetime_out = '{datetime.now()}'
            WHERE log_id = {item.logId}
        '''
        await db.execute(sql)
        return {'message': 'update datetime out to exit project'}

    async def register_walkin(self, db, item):
        if not isThaiNationalID(item.idCard):
            raise HTTPException(
                status_code=401, detail='หมายเลขบัตรประจำตัวประชาชนไม่ถูกต้อง')

        # get home_id from home_number
        query = f"SELECT home_id FROM home WHERE home_number = '{item.home_number}'"
        home = jsonable_encoder(await db.fetch_one(query))

        if home is None:
            raise HTTPException(
                status_code=401, detail=f'ไม่มีบ้านเลขที่ {item.home_number} ในระบบ')

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

    def load_stream_image(self, image_name, type: str):
        original_image = Image.open(image_name)
        filtered_image = BytesIO()
        original_image.save(filtered_image, type.upper())
        filtered_image.seek(0)

        return StreamingResponse(filtered_image, media_type=f"image/{type}")

    async def get_card_image(self, image_name):
        try:
            # image_name = 'images/card/' + image_name + '.jpg'
            image_name =  os.path.join(config.pathCard, f"{image_name}.jpg")
            return self.load_stream_image(image_name, 'jpeg')
        except:
            # image_name = 'images/id-card-image.png'
            image_name =  os.path.join(config.pathImage, "id-card-image.png")
            return self.load_stream_image(image_name, 'png')

    async def decode_image(self, image):
        # Read image
        # original_image = Image.open(image.file)
        # print(image.filename)

        # crop the image according to the frame.
        '''
        left = 2407
        top = 804
        width = 300
        height = 200
        box = (left, top, left+width, top+height)
        area = img.crop(box)
        '''

        # # image to base64
        # buffered = BytesIO()
        # original_image.save(buffered, format="JPEG")
        # img_str = base64.b64encode(buffered.getvalue())

        # # generage code
        # code = utils.generage_qr_code("V")

        # print("croping & extract fullname, id code")
        # # croping & extract fullname, id code
        # if image.filename == 'บัตรประจำตัวประชาชน':
        #     image_scan = personalCard.cropping_front_personal(img_str)
        # else:
        #     image_scan = drivingLicense.extractInfo(img_str)

        # print("save image id card")
        # # save image id card
        # cv2.imwrite(f"images/card/{code}.jpg", image_scan)
        # # ------------- end write json file --------------------
        # sleep(1)
        # return {"code": code}

        code = utils.generage_qr_code("V")

        try:
            original_image = Image.open(image.file)
            # img = original_image.save(f"images/card/{code}.jpg")
            path_save =  os.path.join(config.pathCard, f"{code}.jpg")
            img = original_image.save(path_save)
            return {"code": code}
        except:
            raise HTTPException(
                status_code=401, detail='Image cannot be saved.')

    async def upload_profile(self, db, item):
        try:
            imagBase64 = item.image_base64.replace(
                "data:image/jpeg;base64,", "")
            # im_bytes is a binary image
            im_bytes = base64.b64decode(imagBase64)
            im_file = BytesIO(im_bytes)  # convert image to file-like object
            img = Image.open(im_file)   # img is now PIL Image object
            img = img.save(f"images\profiles\{item.filename}")
        except:
            raise HTTPException(
                status_code=401, detail='Image cannot be saved.')

        try:
            nameList = item.filename.split('.')
            print(item.filename)
            print(nameList)

            id = nameList[0].split('-')[1]
            print(id)

            if 'admin' in item.filename:
                sql = f"UPDATE admin_account SET profile_path = '{item.filename}' WHERE admin_id = {id}"
                await db.execute(sql)
            elif 'guard' in item.filename:
                sql = f"UPDATE guard_account SET profile_path = '{item.filename}' WHERE guard_id = {id}"
                await db.execute(sql)
        except:
            raise HTTPException(
                status_code=401, detail='Invalid filename.')

        return {"detail": "upload successful"}

    async def decode_image_base64(self, image):
        # generage code
        code = utils.generage_qr_code("V")

        try:
            imagBase64 = image.image_base64.replace(
                "data:image/jpeg;base64,", "")
            # im_bytes is a binary image
            im_bytes = base64.b64decode(imagBase64)
            im_file = BytesIO(im_bytes)  # convert image to file-like object
            img = Image.open(im_file)   # img is now PIL Image object
            img = img.rotate(360, expand = 1)
            # img = img.save(f"images/card/{code}.jpg")
            path_save =  os.path.join(config.pathCard, f"{code}.jpg")
            img = img.save(path_save)
            return {"code": code}
        except:
            raise HTTPException(
                status_code=401, detail='Image cannot be saved.')

        # imagBase64 = image.image_base64.replace("data:image/jpeg;base64,", "")

        # try:
        #     # croping & extract fullname, id code
        #     if image.classs == 'บัตรประจำตัวประชาชน':
        #         image_scan = personalCard.cropping_front_personal(imagBase64)
        #     else:
        #         image_scan = drivingLicense.extractInfo(imagBase64)

        #     # save image id card
        #     cv2.imwrite(f"images/card/{code}.jpg", image_scan)
        #     # ------------- end write json file --------------------
        #     sleep(1)

        #     return {"code": code}
        # except:
        #     raise HTTPException(
        #         status_code=401, detail='Error decode image')
