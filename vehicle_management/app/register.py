from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from sqlalchemy import select, func, Integer, Table, Column, MetaData

from .auth import AuthHandler
from .schemas import RegisterDetails
from .models import resident_account, admin_account, guard_account

from datetime import datetime

auth_handler = AuthHandler()


class Register:
    async def register_resident(self, db, auth_details: RegisterDetails):
        query = resident_account.select().where(
            resident_account.c.username == auth_details.username)
        resident = jsonable_encoder(await db.fetch_all(query))

        if len(resident) != 0:
            raise HTTPException(status_code=400, detail='Username is taken')
        else:
            hashed_password = auth_handler.get_password_hash(
                auth_details.password)
            query = resident_account.insert().values(firstname=auth_details.firstname,
                                                     lastname=auth_details.lastname, username=auth_details.username,
                                                     password=hashed_password, email=auth_details.email,
                                                     create_datetime=datetime.now())
            last_record_id = await db.execute(query)
            return {'detail': 'Create success'}

    async def register_admin(self, db, auth_details: RegisterDetails):
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
                                                  create_datetime=datetime.now())
            last_record_id = await db.execute(query)
            return {'detail': 'Create success'}

    async def register_guard(self, db, auth_details: RegisterDetails):
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
                                                  create_datetime=datetime.now())
            last_record_id = await db.execute(query)
            return {'detail': 'Create success'}
