from fastapi.encoders import jsonable_encoder
from data.schemas import  VisitorId, HistoryLog, ResidentId
from datetime import datetime


class Home:
    async def get_home(self, db, item: ResidentId):
        query = f'''
            SELECT CONCAT(h.home_name, ' - ', h.home_number) AS home, h.home_id
            FROM resident_home AS rh
            LEFT JOIN home AS h
            ON rh.home_id = h.home_id
            WHERE rh.resident_id = {item.resident_id}
            ORDER BY home_id ASC;
        '''
        data = jsonable_encoder(await db.fetch_all(query))
        return data


class LicensePlate:
    async def licensePlate_invite_delete(self, db, item: VisitorId):
        query = f"DELETE FROM visitor WHERE visitor_id = {item.visitor_id}"
        last_record_id = await db.execute(query)
        return {"message": "backlist_whitelist with id: {} deleted successfully!".format(item.visitor_id)}


    async def resident_stamp(self, db, item: HistoryLog):
        query = f"UPDATE history_log SET resident_stamp = '{datetime.now()}' WHERE log_id = {item.log_id}"
        await db.execute(query)
        return {"id": item.log_id}
