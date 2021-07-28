from pyfcm import FCMNotification
from fastapi.encoders import jsonable_encoder


class Notification:
    def __init__(self):
        self.api_key = "AAAAxQcORvA:APA91bFH5H91LW2WgfWj_mEf3F_uC6WLnLxgG75cL_lTj9xK6jr2gFAP9f2NERuq3fUr89fVtxudbMcGdDiAFMfKTWHBq2_Xx-yaIEz7TrLMXnNYT0lNiGhMqJqu-8mT_d2LZ5_4XpMs"
        self.push_service = FCMNotification(api_key=self.api_key)

        self.home_id = ""
        self.title = ""
        self.body = ""
        self.data = ""
        self.registration_ids = []

    async def get_registration_ids(self, db):
        query = f'''
            SELECT ra.device_token
            FROM resident_home AS rh
            LEFT JOIN resident_account AS ra
            ON rh.resident_id = ra.resident_id
            WHERE home_id = {self.home_id}
                AND ra.is_login = true;
        '''
        result = jsonable_encoder(await db.fetch_all(query))

        for device_token in result:
            self.registration_ids.append(device_token['device_token'])

        # self.registration_ids = [
        #     "dMsGnvPqRTOVyOU0K4557I:APA91bFLCAtxlZR8whLanzfbhrw2hRXvV7VVEFZZX-8NqSaWexCnTNlF1vvW5rjEvojNXNyT_Re6rrlDO_LYMv3U4hMyFCqnXBgXx5CWedCj5yNhFymQKHBY2_q-Bx9_Ne0irN0C2b-v"]
        return self.registration_ids

    def send_to_device(self):
        if self.registration_ids:
            result = self.push_service.notify_multiple_devices(
                registration_ids=self.registration_ids, message_title=self.title, message_body=self.body, data_message=self.data)
            self.registration_ids = []
            return result
        else:
            return 200

    async def send_notification(self, db, item):
        # message_title = "แจ้งเตือนจากป้อม รปภ."
        # message_body = "ตอนนี้ visitor กำลังขับรถมาหาคุณ"
        # # message_body = "ตอนนี้ whitelist กำลังขับรถมาหาคุณ"
        # message_body = "ตอนนี้ blacklist มาติดต่อขอพบที่บ้านคุณ"
        # data_message = {
        #     "job": "developer"
        # }

        self.home_id = item.data.home_id
        self.title = item.title
        self.body = item.body
        self.data = dict(item.data)
        self.registration_ids = await self.get_registration_ids(db)

        return self.send_to_device()
