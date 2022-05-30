from fastapi.params import Query
from pyfcm import FCMNotification
from fastapi.encoders import jsonable_encoder
from icecream import ic

api_key = "AAAAxQcORvA:APA91bFH5H91LW2WgfWj_mEf3F_uC6WLnLxgG75cL_lTj9xK6jr2gFAP9f2NERuq3fUr89fVtxudbMcGdDiAFMfKTWHBq2_Xx-yaIEz7TrLMXnNYT0lNiGhMqJqu-8mT_d2LZ5_4XpMs"
push_service = FCMNotification(api_key=api_key)

async def get_registration_ids(db, home_id):
    registration_ids = []

    query = f"SELECT device_token FROM resident_account WHERE home_id = {home_id}"
    result = jsonable_encoder(await db.fetch_all(query))

    for device_token in result:
        if device_token['device_token'] is not None:
            registration_ids.append(device_token['device_token'])

    # print(f"device_token [notification]: {registration_ids}")
    ic(registration_ids)
    # remove all None
    # new_registration_ids = [elem for elem in registration_ids if elem is not None]
    # ic(new_registration_ids)

    return registration_ids

def thread_callback(registration_ids, title, body, data):
    result = push_service.notify_multiple_devices(
                registration_ids=registration_ids, message_title=title, message_body=body, data_message=data)
    ic(result)

async def send_to_device(title, body, data, registration_ids):
    if registration_ids:
        try:
            import threading

            thr = threading.Thread(target=thread_callback, args=(registration_ids, title, body, data))
            thr.start()

            return 200
        except: 
            ic('FCM not work')
            ic(title)
            ic(body)
            ic(data)
            return 200
    else:
        return 200

async def send_notification(db, item):
    # message_title = "แจ้งเตือนจากป้อม รปภ."
    # message_body = "ตอนนี้ visitor กำลังขับรถมาหาคุณ"
    # # message_body = "ตอนนี้ whitelist กำลังขับรถมาหาคุณ"
    # message_body = "ตอนนี้ blacklist มาติดต่อขอพบที่บ้านคุณ"
    # data_message = {
    #     "job": "developer"
    # }

    home_id = item.data.home_id
    title = item.title
    body = item.body
    data = dict(item.data)
    registration_ids = await get_registration_ids(db, home_id)

    result = await send_to_device(title, body, data, registration_ids)

    # print(f"result: {result}")
    # ic(result)

    return result
