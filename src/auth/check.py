from fastapi import HTTPException

from utils.verify_id_card import isThaiNationalID
from data.models import admin_account, guard_account, resident_account, whitelist, blacklist, home
from fastapi.encoders import jsonable_encoder

class Check:
    async def check_thai_id(self, item):
        if not isThaiNationalID(item.id_card):
            raise HTTPException(status_code=400, detail='Invalid ID card number')


    async def check_in_whitelist(self, db, item, isUpdate=False):
        if isUpdate:
            query = f"SELECT * FROM whitelist WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}' AND whitelist_id != {item.whitelist_id}"
        else:
            # register
            query = f"SELECT * FROM whitelist WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}'"
        
        result =  jsonable_encoder(await db.fetch_one(query))
        if result:
            raise HTTPException(status_code=400, detail='Account is already in Whitelist')


    async def check_in_blacklist(self, db, item, isUpdate=False):
        if isUpdate:
            query = f"SELECT * FROM blacklist WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}' AND blacklist_id != {item.blacklist_id}"
        else:
            # register
            query = f"SELECT * FROM blacklist WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}'"
        
        result =  jsonable_encoder(await db.fetch_one(query))
        if result:
            raise HTTPException(status_code=400, detail='Account is already in Blacklist')
            

    async def check_admin(self, db, item, isUpdate=False):
        if isUpdate:
            query = f"SELECT * FROM admin_account WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}' AND admin_id != {item.admin_id}"
        else:
            # register
            query = f"SELECT * FROM admin_account WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}'"

        result =  jsonable_encoder(await db.fetch_one(query))
        if result:
            raise HTTPException(status_code=400, detail='Account is already in Admin list')


    async def check_guard(self, db, item, isUpdate=False):
        if isUpdate:
            query = f"SELECT * FROM guard_account WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}' AND guard_id != {item.guard_id}"
        # register
        else:
            query = f"SELECT * FROM guard_account WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}'"
        
        result =  jsonable_encoder(await db.fetch_one(query))
        if result:
            raise HTTPException(status_code=400, detail='Account is already in Guard list')


    async def check_resident(self, db, item, isUpdate=False):
        if isUpdate:
            query = f"SELECT * FROM resident_account WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}' AND resident_id != {item.resident_id}"
        else:
            # register
            query = f"SELECT * FROM resident_account WHERE CONCAT(firstname, lastname) = '{item.firstname+item.lastname}'"

        result = jsonable_encoder(await db.fetch_one(query))
        if result:
            raise HTTPException(
                status_code=401, detail='Account is already in Resident list')

    
    async def check_email_resident(self, db, item):
        self.isValidEmail(item.email)

        query = resident_account.select().where(
            resident_account.c.email == item.email)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            raise HTTPException(
                status_code=401, detail='Email is already in Resident list')

    
    async def check_email_guard(self, db, item):
        self.isValidEmail(item.email)

        query = guard_account.select().where(
            guard_account.c.email == item.email)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            raise HTTPException(
                status_code=401, detail='Email is already in Guard list')


    async def check_email_admin(self, db, item):
        self.isValidEmail(item.email)

        query = admin_account.select().where(
            admin_account.c.email == item.email)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            raise HTTPException(
                status_code=401, detail='Email is already in Admin list')


    async def check_email_whitelist(self, db, item):
        self.isValidEmail(item.email)

        query = whitelist.select().where(
            whitelist.c.email == item.email)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            raise HTTPException(
                status_code=401, detail='Email is already in Whitelist')


    async def check_email_blacklist(self, db, item):
        self.isValidEmail(item.email)

        query = blacklist.select().where(
            blacklist.c.email == item.email)
        result = jsonable_encoder(await db.fetch_one(query))

        if result:
            raise HTTPException(
                status_code=401, detail='Email is already in Blacklist')


    def isValidEmail(self, email: str):
        import re
        regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
 
        if not re.fullmatch(regex, email):
            raise HTTPException(
                status_code=401, detail='Invalid Email address')

    
    async def checkHomeIdByHomeNumber(self, db, item):
        query = home.select().where(home.c.home_number == item.home_number)
        result = await db.fetch_one(query)
        return result.home_id