from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from models import visitor, blacklist, whitelist
from schemas import listItem_whitelist_blacklist, deleteBlackWhite, HomeId
from datetime import date, datetime


class ListItem:
    async def listItem_whitelist_blacklist(self, db, list_item: listItem_whitelist_blacklist):
        command = f'''
            SELECT whitelist_id AS id, firstname, lastname, license_plate, 'whitelist' AS type 
            FROM whitelist
            WHERE class_id = {list_item.resident_id}
                AND home_id = {list_item.home_id}  
                AND admin_approve = true
            UNION
            SELECT blacklist_id AS id, firstname, lastname, license_plate, 'blacklist' AS type 
            FROM blacklist
            WHERE class_id = {list_item.resident_id}
                AND admin_approve = true
            UNION
            SELECT blacklist_id AS id, firstname, lastname, license_plate, 'blacklist wait approve' AS type 
            FROM blacklist
            WHERE class_id = {list_item.resident_id}
                AND admin_approve is NULL
            UNION
            SELECT whitelist_id AS id, firstname, lastname, license_plate, 'whitelist wait approve' AS type 
            FROM whitelist
            WHERE class_id = {list_item.resident_id}
                AND admin_approve is NULL
            UNION
            SELECT whitelist_id AS id, firstname, lastname, license_plate, 'whitelist reject' AS type 
            FROM whitelist
            WHERE class_id = {list_item.resident_id}
                AND admin_approve = false
            UNION
            SELECT blacklist_id AS id, firstname, lastname, license_plate, 'blacklist reject' AS type 
            FROM blacklist
            WHERE class_id = {list_item.resident_id}
                AND admin_approve = false
        '''
        return await db.fetch_all(command)

    async def delete_backlist_whitelist(self, db, item: deleteBlackWhite):
        if item.type == 'blacklist' or item.type == 'blacklist wait approve':
            query = f"DELETE FROM blacklist WHERE blacklist_id = {item.index}"
        else:
            query = f"DELETE FROM whitelist WHERE whitelist_id = {item.index}"
            q2 = f"DELETE FROM history_log WHERE class = 'whitelist' AND class_id = {item.index}"
            await db.execute(q2)

        result = await db.execute(query)
        return {"message": "backlist_whitelist with id: {} deleted successfully!".format(item.index)}


class History:
    async def histoly_log(self, db, item: HomeId):
        command = f'''
            -- Whitelist Coming in
            SELECT h.log_id, 
                h.class AS type,
                w.license_plate,
                CONCAT(w.firstname, '  ', w.lastname) AS fullname,
				'Coming in' AS status, 
				NULL AS invite,
				h.datetime_in,
				h.resident_stamp,
				h.resident_send_admin,
				h.resident_reason,
                h.admin_datetime,
				h.admin_reason,
				h.admin_approve,
				h.datetime_out,
                (	
                    SELECT stamp_count
                    FROM home
                    WHERE home_id = {item.home_id}
                ) AS stamp_count
            FROM history_log AS h
            LEFT JOIN whitelist AS w
            ON h.class_id = w.whitelist_id
            WHERE h.resident_stamp is not NULL
                AND h.class = 'whitelist'
                AND w.home_id = {item.home_id}
                AND h.datetime_out is not NULL
				AND h.datetime_out < current_timestamp
            UNION
            SELECT h.log_id, 
                h.class AS type,
                v.license_plate,
                CONCAT(v.firstname, '  ', v.lastname) AS fullname,
				CASE
					WHEN v.id_card is NULL THEN 'Coming in'
					WHEN v.id_card is not NULL THEN 'Walk in'
					ELSE ''
                 END AS status, 
				CONCAT(v.invite_date, 'T', TO_CHAR(h.create_datetime::TIME, 'HH:mm')) AS invite,
				h.datetime_in,
				h.resident_stamp,
				h.resident_send_admin,
				h.resident_reason,
                h.admin_datetime,
				h.admin_reason,
				h.admin_approve,
				h.datetime_out,
                (	
                    SELECT stamp_count
                    FROM home
                    WHERE home_id = {item.home_id}
                ) AS stamp_count
            FROM history_log AS h
            LEFT JOIN visitor AS v
            ON h.class_id = v.visitor_id
            WHERE h.resident_stamp is not NULL
                AND h.class = 'visitor'
                AND v.home_id = {item.home_id}
                AND h.datetime_out is not NULL
				AND h.datetime_out < current_timestamp
        '''
        return await db.fetch_all(command)
