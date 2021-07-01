from fastapi.encoders import jsonable_encoder
from fastapi import HTTPException
from .schemas import LoginDetails
from .models import resident_account, admin_account, guard_account
from .auth import AuthHandler

auth_handler = AuthHandler()


class Login:
    def verify_password(self, query_user, auth_details):
        user = None

        if len(query_user) != 0:
            user = query_user["username"]

        if (user is None) or (not auth_handler.verify_password(auth_details.password, query_user["password"])):
            raise HTTPException(
                status_code=401, detail='Invalid username and/or password')
        token = auth_handler.encode_token(user)
        return {'token': token}

    async def login_resident(self, db,  auth_details: LoginDetails):
        user = None
        query = resident_account.select().where(
            resident_account.c.username == auth_details.username)
        resident = jsonable_encoder(await db.fetch_one(query))

        return Login().verify_password(resident, auth_details)

    async def login_admin(self, db, auth_details: LoginDetails):
        user = None
        query = admin_account.select().where(
            admin_account.c.username == auth_details.username)
        admin = jsonable_encoder(await db.fetch_one(query))

        return Login().verify_password(admin, auth_details)

    async def login_guard(SELF, db, auth_details: LoginDetails):
        user = None
        query = guard_account.select().where(
            guard_account.c.username == auth_details.username)
        guard = jsonable_encoder(await db.fetch_one(query))

        return Login().verify_password(guard, auth_details)
