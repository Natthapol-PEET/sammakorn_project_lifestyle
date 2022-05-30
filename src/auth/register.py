from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from sqlalchemy.sql.expression import case, true
from datetime import datetime

# auth
from auth.auth import AuthHandler
from data.admin_schemas import CreateAdmin
from data.guard_schemas import CreateGuard

# data
from data.schemas import RegisterDetails, ChangePassword
from data.models import resident_account, admin_account, guard_account

# utils
from utils.manageMail import resetPasswordAndSendmail, get_random_string


auth_handler = AuthHandler()


class Register:
    async def register_resident(self, db, item: RegisterDetails):
        query = resident_account.select().where(
            resident_account.c.username == item.username or resident_account.c.email == item.email)
        resident = jsonable_encoder(await db.fetch_all(query))

        if len(resident) != 0:
            raise HTTPException(
                status_code=400, detail='Username or Email is taken')
        else:
            hashed_password = auth_handler.get_password_hash(item.password)
            query = resident_account.insert().values(firstname=item.firstname,
                                                     lastname=item.lastname, username=item.username,
                                                     password=hashed_password, email=item.email,
                                                     card_info=item.card_info,
                                                     create_datetime=datetime.now())
            last_record_id = await db.execute(query)
            # print(f"last_record_id: {last_record_id}")
            return {'detail': 'Create success'}

    async def resident_reset_password_(self, db, email):
        # check email
        sql = f"SELECT * FROM resident_account WHERE email = '{email}'"
        result = jsonable_encoder(await db.fetch_one(sql))

        if not result:
            raise HTTPException(
                status_code=403, detail="อีเมลนี้ไม่ได้ลงทะเบียนไว้")

        try:
            # cerate password
            password = get_random_string(6)
            print(f"password >> {password}")
            resetPasswordAndSendmail(email, password)

            # hash password
            hashed_password = auth_handler.get_password_hash(password)
            print(f"hashed_password >> {hashed_password}")

            # check and update password, is_login to database
            query = f"UPDATE resident_account SET password = '{hashed_password}', is_login = false WHERE email = '{email}'"
            await db.execute(query)

            return {"status": True}
        except:
            raise HTTPException(
                status_code=403, detail="ไม่สามารถส่งอีเมลได้ กรุณาลองใหม่อีกครั้ง")

    async def resident_change_password(self, db, items: ChangePassword):
        # check password is conrec
        hashed_old_password = auth_handler.get_password_hash(
            items.old_password)
        sql = f"SELECT password FROM resident_account WHERE resident_id = {items.resident_id}"
        result = jsonable_encoder(await db.fetch_one(sql))
        # print(f"hashed_old_password >> {hashed_old_password}")
        # print(f"result >> {result}")
        # print(f"items.old_password >> {items.old_password}")
        print(f"password >> {result['password']}")

        if not result or (not auth_handler.verify_password(items.old_password, result['password'])):
            raise HTTPException(
                status_code=401, detail="รหัสผ่านไม่ถูกต้อง")

        # change password
        hashed_new_password = auth_handler.get_password_hash(
            items.new_password)
        sql = f"UPDATE resident_account SET password = '{hashed_new_password}' WHERE resident_id = {items.resident_id}"
        await db.execute(sql)

        return {"status": True}

    async def register_admin(self, db, auth_details: CreateAdmin):
        query = admin_account.select().where(
            admin_account.c.username == auth_details.username)
        admin = jsonable_encoder(await db.fetch_all(query))

        if len(admin) != 0:
            raise HTTPException(status_code=400, detail='Username is taken')
        else:
            hashed_password = auth_handler.get_password_hash(
                auth_details.password)
            query = admin_account.insert().values(firstname=auth_details.firstname,
                                                  lastname=auth_details.lastname, username=auth_details.username,
                                                  password=hashed_password, email=auth_details.email,
                                                  active_user=True, role=auth_details.role, id_card=auth_details.id_card,
                                                  create_datetime=datetime.now())
            last_record_id = await db.execute(query)
            return {'detail': 'Create success'}

    async def register_guard(self, db, auth_details: CreateGuard):
        query = guard_account.select().where(
            guard_account.c.username == auth_details.username)
        guard = jsonable_encoder(await db.fetch_all(query))

        if len(guard) != 0:
            raise HTTPException(status_code=400, detail='Username is taken')
        else:
            hashed_password = auth_handler.get_password_hash(
                auth_details.password)
            query = guard_account.insert().values(firstname=auth_details.firstname,
                                                  lastname=auth_details.lastname, username=auth_details.username,
                                                  password=hashed_password, email=auth_details.email,
                                                  active_user=True, role=auth_details.role, id_card=auth_details.id_card,
                                                  create_datetime=datetime.now())
            last_record_id = await db.execute(query)
            return {'detail': 'Create success'}
