from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from .models import visitor, blacklist, whitelist
from .schemas import listItem_whitelist_blacklist, deleteBlackWhite, HomeId
from datetime import date, datetime


class ListItem:
    async def listItem_whitelist_blacklist(self, db, list_item: listItem_whitelist_blacklist):
        command = f'''
            SELECT whitelist_id AS id, firstname, lastname, license_plate, 'whitelist' AS type FROM whitelist
            WHERE home_id = {list_item.home_id} 
                AND class = 'resident'
                AND class_id = {list_item.resident_id}
            UNION
            SELECT blacklist_id AS id, firstname, lastname, license_plate, 'blacklist' AS type FROM blacklist
            WHERE home_id = {list_item.home_id} 
                AND class = 'resident'
                AND class_id = {list_item.resident_id}
        '''
        return await db.fetch_all(command)

    async def delete_backlist_whitelist(self, db, item: deleteBlackWhite):
        if item.type == 'blacklist':
            query = f"DELETE FROM blacklist WHERE blacklist_id = {item.index}"
        else:
            query = f"DELETE FROM whitelist WHERE whitelist_id = {item.index}"
            q2 = f"DELETE FROM history_log WHERE class = 'whitelist' AND class_id = {item.index}"
            await db.execute(q2)

        result = await db.execute(query)
        return {"message": "backlist_whitelist with id: {} deleted successfully!".format(item.index)}


class History:
    async def histoly_log(self, db, home_id: HomeId):
        command = f'''
            SELECT * 
            FROM (
                SELECT CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                    v.license_plate, 'visitor' AS type,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_out
                FROM history_log AS h
                LEFT JOIN visitor AS v
                ON h.class_id = v.visitor_id
                WHERE h.class = 'visitor'
                    AND h.resident_stamp is not NULL
                    AND datetime_out is not NULL
                    AND v.home_id = {home_id.home_id}
                    AND h.datetime_in < CURRENT_DATE
                UNION
                SELECT CONCAT(w.firstname, '  ', w.lastname) AS fullname,
                    w.license_plate, 'whitelist' AS type,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_out
                FROM history_log AS h
                LEFT JOIN whitelist AS w
                ON h.class_id = w.whitelist_id
                WHERE h.class = 'whitelist'
                    AND h.resident_stamp is not NULL
                    AND datetime_out is not NULL
                    AND w.home_id = {home_id.home_id}
                    AND h.datetime_in < CURRENT_DATE
            ) his
            ORDER BY datetime_in DESC
        '''
        return await db.fetch_all(command)
