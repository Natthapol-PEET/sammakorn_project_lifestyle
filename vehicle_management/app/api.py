from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from .models import visitor, blacklist, whitelist
from .schemas import VisitorIN, WhitelistIN, BlacklistIN
from datetime import date, datetime

# ------------------------------------- Application ---------------------------


class API:
    async def Invite_Visitor(self, db, invite: VisitorIN, username):
        # check whitelist UNION blacklist
        command = f'''
           SELECT type FROM (
                SELECT *, 'blacklist' AS type FROM blacklist
                WHERE home_id = {invite.home_id} and license_plate = '{invite.license_plate.strip().replace(' ', '')}'
                UNION
                SELECT *, 'whitelist' AS type FROM whitelist
                WHERE home_id = {invite.home_id} and license_plate = '{invite.license_plate.strip().replace(' ', '')}'
            ) wb
        '''
        result = jsonable_encoder(await db.fetch_one(command))

        if result is None:
            # ตรวจสอบว่า visitor นี้เพิ่มเข้ามาหรือยัง
            command = f'''
               SELECT COALESCE(MAX(visitor_id), 0) AS visitor_id FROM visitor
                    WHERE class = '{invite.Class}'
                        AND class_id = {invite.class_id}
                        AND license_plate = '{invite.license_plate}'
                        AND invite_date = '{invite.invite_date}';
            '''
            visitor_id = jsonable_encoder(await db.fetch_one(command))['visitor_id']

            # ยังไม่มีในรายการ
            if visitor_id == 0:
                # insert visitor
                command = f'''
                        INSERT INTO visitor (home_id, class, class_id, firstname, lastname, license_plate, invite_date, create_datetime)
	                        VALUES ({invite.home_id}, '{invite.Class}', {invite.class_id}, '{invite.firstname}', '{invite.lastname}', '{invite.license_plate.strip().replace(' ', '')}', '{invite.invite_date}', CURRENT_TIMESTAMP)
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
                        INSERT INTO visitor (home_id, class, class_id, firstname, lastname, license_plate, invite_date, create_datetime)
	                        VALUES ({invite.home_id}, '{invite.Class}', {invite.class_id}, '{invite.firstname}', '{invite.lastname}', '{invite.license_plate.strip().replace(' ', '')}', '{invite.invite_date}', CURRENT_TIMESTAMP)
                    '''
                    await db.execute(command)
                    return 201
                else:
                    raise HTTPException(
                        status_code=202, detail=f'ป้ายทะเบียนนี้ได้ลงทะเบียนไว้ก่อนหน้านี้แล้ว')
        else:
            raise HTTPException(
                status_code=202, detail=f'ป้ายทะเบียนนี้เป็นของ {result["type"]}')

    async def register_whitelist(self, db, register: WhitelistIN, username):
        # check whitelist UNION blacklist
        command = f'''
           SELECT type FROM (
                SELECT *, 'blacklist' AS type FROM blacklist
                WHERE home_id = {register.home_id} and license_plate = '{register.license_plate.strip().replace(' ', '')}'
                UNION
                SELECT *, 'whitelist' AS type FROM whitelist
                WHERE home_id = {register.home_id} and license_plate = '{register.license_plate.strip().replace(' ', '')}'
            ) wb
        '''
        result = jsonable_encoder(await db.fetch_one(command))

        if result is None:
            command = f'''
                INSERT INTO whitelist (home_id, class, class_id, firstname, lastname, license_plate, create_datetime)
                    VALUES ({register.home_id}, '{register.Class}', {register.id}, '{register.firstname}', '{register.lastname}', '{register.license_plate.strip().replace(' ', '')}', CURRENT_TIMESTAMP);
            '''
            await db.execute(command)
            return 201
        else:
            raise HTTPException(
                status_code=202, detail=f'ป้ายทะเบียนนี้เป็นของ {result["type"]}')

    async def register_blacklist(self, db, register: BlacklistIN, username):
        # check whitelist UNION blacklist
        command = f'''
           SELECT type FROM (
                SELECT *, 'blacklist' AS type FROM blacklist
                WHERE home_id = {register.home_id} and license_plate = '{register.license_plate.strip().replace(' ', '')}'
                UNION
                SELECT *, 'whitelist' AS type FROM whitelist
                WHERE home_id = {register.home_id} and license_plate = '{register.license_plate.strip().replace(' ', '')}'
            ) wb
        '''
        result = jsonable_encoder(await db.fetch_one(command))

        if result is None:
            command = f'''
                INSERT INTO blacklist (home_id, class, class_id, firstname, lastname, license_plate, create_datetime)
                    VALUES ({register.home_id}, '{register.Class}', {register.id}, '{register.firstname}', '{register.lastname}', '{register.license_plate.strip().replace(' ', '')}', CURRENT_TIMESTAMP);
            '''
            await db.execute(command)
            return 201
        else:
            raise HTTPException(
                status_code=202, detail=f'ป้ายทะเบียนนี้เป็นของ {result["type"]}')
