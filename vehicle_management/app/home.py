from datetime import datetime
from models import home, resident_home
from schemas import HomeIn, ResidentHomeIn, HomeId, VisitorId, HistoryLog, \
    ResidentId, SendToAdmin, AdminDelete
from fastapi.encoders import jsonable_encoder


class Home:
    async def Add_Home(self, db, Home: HomeIn):
        query = home.insert() \
            .values(home_name=Home.home_name,
                    home_number=Home.home_number,
                    stamp_count=0,
                    create_datetime=datetime.now())
        last_record_id = await db.execute(query)

        return {**Home.dict(), "id": last_record_id}

    async def Add_Resident_Home(self, db, ResidentHome: ResidentHomeIn):
        query = resident_home.insert() \
            .values(resident_id=ResidentHome.resident_id,
                    home_id=ResidentHome.home_id,
                    create_datetime=datetime.now())
        await db.execute(query)

        return {**ResidentHome.dict()}

    async def get_home(self, db, item: ResidentId):
        query = f'''
            SELECT CONCAT(h.home_name, ' - ', h.home_number) AS home, h.home_id
            FROM resident_home AS rh
            LEFT JOIN home AS h
            ON rh.home_id = h.home_id
            WHERE rh.resident_id = {item.resident_id}
        '''
        return await db.fetch_all(query)


class LicensePlate:
    async def invite(self, db, home_id: HomeId):
        query = f'''
            SELECT v.visitor_id,
                v.license_plate,
                CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                'visitor' AS type,
                CONCAT(v.invite_date, 'T', TO_CHAR(v.create_datetime::TIME, 'HH:mm')) AS invite
            FROM visitor AS v
            FULL OUTER JOIN (
                SELECT *
                FROM history_log AS h
                WHERE h.class = 'visitor'
            ) AS h
            ON v.visitor_id = h.class_id
            WHERE h.log_id is NULL
                AND v.home_id = {home_id.home_id};
        '''
        return await db.fetch_all(query)

    async def licensePlate_invite_delete(self, db, visitor: VisitorId):
        query = f"DELETE FROM visitor WHERE visitor_id = {visitor.visitor_id}"
        last_record_id = await db.execute(query)
        return {"message": "backlist_whitelist with id: {} deleted successfully!".format(visitor.visitor_id)}

    async def coming_and_walk(self, db, item: HomeId):
        query = f'''
                SELECT h.log_id,
                    v.license_plate,
                    h.class AS type,
                    CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                    CONCAT(v.invite_date, 'T', TO_CHAR(h.create_datetime::TIME, 'HH:mm')) AS invite,
					h.datetime_in,
                    CASE
						WHEN v.id_card is NULL THEN 'Coming in'
						WHEN v.id_card is not NULL THEN 'Walk in'
					ELSE ''
                 	END AS status
                FROM history_log AS h
                LEFT JOIN visitor AS v
                ON h.class_id = v.visitor_id
                WHERE h.datetime_in is not NULL
                    AND h.resident_stamp is NULL
                    AND h.class = 'visitor'
                    AND v.home_id = {item.home_id}
                    AND h.datetime_out is NULL
                UNION
                SELECT h.log_id,
                    w.license_plate,
                    h.class AS type,
                    CONCAT(w.firstname, '  ', w.lastname) AS fullname,
                    NULL AS invite,
					h.datetime_in,
                    'Coming in' AS status
                FROM history_log AS h
                LEFT JOIN whitelist AS w
                ON h.class_id = w.whitelist_id
                WHERE h.datetime_in is not NULL
                    AND h.resident_stamp is NULL
                    AND h.class = 'whitelist'
                    AND w.home_id = {item.home_id}
                    AND h.datetime_out is NULL
        '''
        return await db.fetch_all(query)

    async def resident_stamp(self, db, item: HistoryLog):
        query = f"UPDATE history_log SET resident_stamp = CURRENT_TIMESTAMP WHERE log_id = {item.log_id}"
        await db.execute(query)
        return {"id": item.log_id}

    # get data resident stamp
    async def get_resident_stamp(self, db, item: HomeId):
        query = f'''
            -- Whitelist Coming in
            SELECT h.log_id, 
                h.class AS type,
                w.license_plate,
                CONCAT(w.firstname, '  ', w.lastname) AS fullname,
                'Coming in' AS status, 
                NULL AS invite,
				h.datetime_in,
                h.resident_stamp,
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
                AND h.resident_send_admin is NULL
                AND h.datetime_out is NULL
                AND TO_CHAR(h.resident_stamp::DATE, 'yyyy-dd-mm') = TO_CHAR(current_timestamp::DATE, 'yyyy-dd-mm')
            UNION
            -- visitor Coming in OR Walk in
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
                AND h.resident_send_admin is NULL
                AND h.datetime_out is NULL
                AND TO_CHAR(h.resident_stamp::DATE, 'yyyy-dd-mm') = TO_CHAR(current_timestamp::DATE, 'yyyy-dd-mm')
        '''
        return await db.fetch_all(query)

    async def send_admin_stamp(self, db, item: SendToAdmin):
        query = f'''
            UPDATE history_log 
                SET resident_send_admin = CURRENT_TIMESTAMP,
                    resident_reason = '{item.reason}'
            WHERE log_id = {item.log_id}'''
        last_record_id = await db.execute(query)
        return {'msg': last_record_id}

    async def send_admin_delete(self, db, item: AdminDelete):
        print(item)

        if item.type == 'blacklist' or item.type == 'whitelist':
            query = f'''
                UPDATE {item.type} 
                    SET resident_remove_datetime = CURRENT_TIMESTAMP,
                        resident_remove_reason = '{item.reason}'
                WHERE {item.type}_id = {item.id}'''
            last_record_id = await db.execute(query)
            return {'msg': last_record_id}

    # wait admin
    async def get_resident_send_admin(self, db, item: HomeId):
        query = f'''
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
                AND h.resident_send_admin is not NULL
                AND h.admin_approve is NULL
                AND h.datetime_out is NULL
            UNION
            -- visitor Coming in OR Walk in
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
                AND h.resident_send_admin is not NULL
                AND h.admin_approve is NULL
                AND h.datetime_out is NULL
        '''
        return await db.fetch_all(query)

    async def resident_cancel_send_admin(self, db, item: HistoryLog):
        query = f"UPDATE history_log SET resident_send_admin = NULL WHERE log_id = {item.log_id}"
        await db.execute(query)
        return {"id": item.log_id}

    # admin stamp and not stamp
    async def pms_show_list(self, db, item: HomeId):
        query = f'''
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
                AND h.resident_send_admin is not NULL
				AND h.admin_approve is not NULL
                AND h.datetime_out is NULL
            UNION
            -- visitor Coming in OR Walk in
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
                AND h.resident_send_admin is not NULL
				AND h.admin_approve is not NULL
                AND h.datetime_out is NULL
        '''
        return await db.fetch_all(query)

    async def checkout(self, db, item: HomeId):
        query = f'''
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
                AND TO_CHAR(h.datetime_out::DATE, 'yyyy-dd-mm') = TO_CHAR(current_timestamp::DATE, 'yyyy-dd-mm')
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
                AND TO_CHAR(h.datetime_out::DATE, 'yyyy-dd-mm') = TO_CHAR(current_timestamp::DATE, 'yyyy-dd-mm')
        '''

        return await db.fetch_all(query)




# TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')