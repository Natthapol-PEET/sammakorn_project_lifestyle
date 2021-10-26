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
                status_code=401, detail='Invalid username and/or password and/or home')
        token = auth_handler.encode_token(user)

        if 'resident_id' in query_user:
            return {"token": token, "statusCode": 200, "id": query_user['resident_id'], "username": query_user['username']}
        else:
            return {"token": token}

    async def login_resident(self, db,  auth_details: LoginResident):
        query = resident_account.select().where(
            resident_account.c.username == auth_details.username)

        # home_name = auth_details.home.split(' - ')[0]
        # home_number = auth_details.home.split(' - ')[1]

        # query = f""" SELECT RA.username, RA.password, RA.resident_id, RA.username FROM resident_account AS RA
        #             RIGHT JOIN resident_home AS RH
        #             ON RA.resident_id = RH.resident_id
        #             RIGHT JOIN home AS H
        #             ON RH.home_id = H.home_id
        #             WHERE RA.username = '{auth_details.username}' and H.home_name = '{home_name}' and H.home_number = '{home_number}' """

        resident = jsonable_encoder(await db.fetch_one(query))

        if resident is not None:
            # update login
            if resident["is_login"] is True:
                if resident["device_id"] == auth_details.deviceId:
                    return {"detail": 'login'}
                else:
                    raise HTTPException(
                        status_code=401, detail='this user account already logged in')
            else:
                query = resident_account.update()   \
                    .where(resident_account.c.username == auth_details.username)    \
                    .values(login_datetime=datetime.now(), device_token=auth_details.device_token,
                            device_id=auth_details.deviceId, is_login=True)
                await db.execute(query)

        return Login().verify_password(resident, auth_details)

    async def login_admin(self, db, auth_details: LoginDetails):
        query = admin_account.select().where(
            admin_account.c.username == auth_details.username)
        admin = jsonable_encoder(await db.fetch_one(query))

        if admin is not None:
            query = admin_account.update()   \
                .where(admin_account.c.username == auth_details.username)    \
                .values(login_datetime=datetime.now())
            await db.execute(query)

        return Login().verify_password(admin, auth_details)

    async def login_guard(SELF, db, auth_details: LoginDetails):
        query = guard_account.select().where(
            guard_account.c.username == auth_details.username)
        guard = jsonable_encoder(await db.fetch_one(query))

        if guard is not None:
            query = guard_account.update()   \
                .where(guard_account.c.username == auth_details.username)    \
                .values(login_datetime=datetime.now())
            await db.execute(query)

        return Login().verify_password(guard, auth_details)
