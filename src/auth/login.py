from unittest import result
from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from sqlalchemy.sql.expression import true

from data.schemas import LoginDetails, LoginResident
from data.models import resident_account, admin_account, guard_account
from auth.auth import AuthHandler

from datetime import datetime

auth_handler = AuthHandler()


class Login:
    def verify_password(self, query_user, auth_details):
        user = None

        if query_user is not None:
            user = query_user["username"]

        if (user is None) or (not auth_handler.verify_password(auth_details.password, query_user["password"])):
            raise HTTPException(
                status_code=401, detail='อีเมลหรือรหัสผ่านไม่ถูกต้อง')
        token = auth_handler.encode_token(user)

        if 'resident_id' in query_user:
            return {"token": token, "statusCode": 200, "id": query_user['resident_id'], "username": query_user['username'], "email": query_user['email']}
        else:
            return {"token": token}

    async def clear_account(self, db, deviceId):
        query = f'''
                    UPDATE resident_account 
                        SET device_token = NULL, 
                            device_id = NULL, 
                            is_login = False 
                        WHERE device_id = '{deviceId}'
                '''
        result = await db.execute(query)

        print(f"clear_account: {result}")

        return True

    async def login_resident(self, db,  auth_details: LoginResident):
        query = resident_account.select().where(
            resident_account.c.username == auth_details.username)
        resident = jsonable_encoder(await db.fetch_one(query))

        if resident is not None:
            # update login
            if resident["device_id"] is None or resident["device_id"] == auth_details.deviceId:
                # First Login
                query = resident_account.update()   \
                    .where(resident_account.c.username == auth_details.username)    \
                    .values(login_datetime=datetime.now(), device_token=auth_details.device_token,
                            device_id=auth_details.deviceId, is_login=True)
                await db.execute(query)

                query = resident_account.select().where(
                    resident_account.c.username == auth_details.username)
                result = jsonable_encoder(await db.fetch_one(query))

                verify = Login().verify_password(resident, auth_details)
                if 'token' in verify:
                    result["token"] = verify["token"]
                    return result
                else:
                    raise HTTPException(
                        status_code=401, detail='อีเมลหรือรหัสผ่านไม่ถูกต้อง')
            else:
                raise HTTPException(
                    status_code=401, detail='บัญชีผู้ใช้นี้เข้าสู่ระบบแล้ว')
        else:
            raise HTTPException(
                status_code=401, detail='ไม่มีบัญชีผู้ใช้นี้')

    async def login_admin(self, db, auth_details: LoginDetails):
        query = admin_account.select().where(
            admin_account.c.username == auth_details.username)
        admin = jsonable_encoder(await db.fetch_one(query))

        if admin is not None:
            query = admin_account.update()   \
                .where(admin_account.c.username == auth_details.username)    \
                .values(login_datetime=datetime.now())
            await db.execute(query)

        result = Login().verify_password(admin, auth_details)

        if 'token' in result:
            data = jsonable_encoder(await db.fetch_one(admin_account.select().where(admin_account.c.username == auth_details.username)))
            data['token'] = result['token']
            return data

        return result

    async def login_guard(SELF, db, auth_details: LoginDetails):
        query = guard_account.select().where(
            guard_account.c.username == auth_details.username)
        guard = jsonable_encoder(await db.fetch_one(query))

        if guard is not None:
            query = guard_account.update()   \
                .where(guard_account.c.username == auth_details.username)    \
                .values(login_datetime=datetime.now())
            await db.execute(query)

        result = Login().verify_password(guard, auth_details)

        if 'token' in result:
            data = jsonable_encoder(await db.fetch_one(guard_account.select().where(guard_account.c.username == auth_details.username)))
            data['token'] = result['token']
            return data

        return result
