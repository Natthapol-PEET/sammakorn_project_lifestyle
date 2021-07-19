from .models import home, resident_home
from .schemas import HomeIn, ResidentHomeIn, HomeId, VisitorId, HistoryLog
from datetime import datetime


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

    async def get_all_home(self, db):
        query = "SELECT CONCAT(home_name, ' - ', home_number) AS home, home_id FROM home"
        return await db.fetch_all(query)


class LicensePlate:
    async def invite(self, db, home_id: HomeId):
        query = f'''
            SELECT v.visitor_id,
                v.license_plate,
                CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                'visitor' AS type,
                CONCAT(TO_CHAR(v.invite_date::DATE, 'dd-Mon-yyyy'), ' : ', TO_CHAR(v.create_datetime::DATE, 'HH.mm')) AS datetime
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
                    CONCAT(TO_CHAR(v.invite_date::DATE, 'dd-Mon-yyyy'), ' : ', TO_CHAR(v.create_datetime::DATE, 'HH.mm')) AS invite_date,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                    'Coming in' AS status
                FROM history_log AS h
                LEFT JOIN visitor AS v
                ON h.class_id = v.visitor_id
                WHERE h.datetime_in is not NULL
                    AND h.resident_stamp is NULL
                    AND h.class = 'visitor'
                    AND v.id_card is NULL
                    AND v.home_id = {item.home_id}
                    AND TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')
                UNION
                SELECT h.log_id,
                    v.license_plate,
                    h.class AS type,
                    CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                    '-' AS invite_date,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                    'Walk in' AS status
                FROM history_log AS h
                LEFT JOIN visitor AS v
                ON h.class_id = v.visitor_id
                WHERE h.datetime_in is not NULL
                    AND h.resident_stamp is NULL
                    AND h.class = 'visitor'
                    AND v.id_card is not NULL
                    AND v.home_id = {item.home_id}
                    AND TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')
                UNION
                SELECT h.log_id,
                    w.license_plate,
                    h.class AS type,
                    CONCAT(w.firstname, '  ', w.lastname) AS fullname,
                    '' AS invite_date,
                    TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                    'Coming in' AS status
                FROM history_log AS h
                LEFT JOIN whitelist AS w
                ON h.class_id = w.whitelist_id
                WHERE h.datetime_in is not NULL
                    AND h.resident_stamp is NULL
                    AND h.class = 'whitelist'
                    AND w.home_id = {item.home_id}
                    AND TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')
        '''
        return await db.fetch_all(query)

    async def resident_stamp(self, db, item: HistoryLog):
        query = f"UPDATE history_log SET resident_stamp = CURRENT_TIMESTAMP WHERE log_id = {item.log_id}"
        await db.execute(query)
        return {"id": item.log_id}

    async def hsa_stamp(self, db, item: HomeId):
        query = f'''
            -- Whitelist
            SELECT h.log_id, 
                h.class AS type,
                w.license_plate,
                CONCAT(w.firstname, '  ', w.lastname) AS fullname,
                TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                '-' AS invite,
                'Walk in' AS status, 
                TO_CHAR(h.resident_stamp::DATE, 'dd-Mon-yyyy : HH.mm') AS  resident_stamp,
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
                AND h.datetime_out is NULL
                AND TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')
            UNION
            -- visitor Coming in
            SELECT h.log_id, 
                h.class AS type,
                v.license_plate,
                CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                TO_CHAR(v.invite_date::DATE, 'dd-Mon-yyyy : HH.mm') AS invite,
                'Coming in' AS status, 
                TO_CHAR(h.resident_stamp::DATE, 'dd-Mon-yyyy : HH.mm') AS  resident_stamp,
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
                AND v.id_card is NULL
                AND h.datetime_out is NULL
                AND TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')
            UNION
            -- visitor Walk in
            SELECT h.log_id, 
                h.class AS type,
                v.license_plate,
                CONCAT(v.firstname, '  ', v.lastname) AS fullname,
                TO_CHAR(h.datetime_in::DATE, 'dd-Mon-yyyy : HH.mm') AS datetime_in,
                TO_CHAR(v.invite_date::DATE, 'dd-Mon-yyyy : HH.mm') AS invite,
                'Walk in' AS status, 
                TO_CHAR(h.resident_stamp::DATE, 'dd-Mon-yyyy : HH.mm') AS  resident_stamp,
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
                AND v.id_card is not NULL
                AND h.datetime_out is NULL
                AND TO_CHAR(h.datetime_in::DATE, 'yyyy-mm-dd') = TO_CHAR(CURRENT_DATE::DATE, 'yyyy-mm-dd')
        '''
        return await db.fetch_all(query)


    async def send_admin_stamp(self, db, item: HistoryLog):
        query = f"UPDATE history_log SET resident_send_admin = CURRENT_TIMESTAMP WHERE log_id = {item.log_id}"
        last_record_id = await db.execute(query)
        return {'msg': last_record_id}


    async def pms_show_list(self, db, item: HomeId):
        query = f'''
        
        '''
        return await db.fetch_all(query)