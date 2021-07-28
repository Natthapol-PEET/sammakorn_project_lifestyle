# Send to single device.
from pyfcm import FCMNotification

api_key = "AAAAxQcORvA:APA91bFH5H91LW2WgfWj_mEf3F_uC6WLnLxgG75cL_lTj9xK6jr2gFAP9f2NERuq3fUr89fVtxudbMcGdDiAFMfKTWHBq2_Xx-yaIEz7TrLMXnNYT0lNiGhMqJqu-8mT_d2LZ5_4XpMs"

push_service = FCMNotification(api_key=api_key)

# proxy_dict = {
#           "http"  : "http://127.0.0.1",
#           "https" : "http://127.0.0.1",
#         }

push_service = FCMNotification(api_key=api_key)

# registration_id = "/topics/NEWS"
# registration_id = "/topics/NEWS"
registration_id = "dMsGnvPqRTOVyOU0K4557I:APA91bFLCAtxlZR8whLanzfbhrw2hRXvV7VVEFZZX-8NqSaWexCnTNlF1vvW5rjEvojNXNyT_Re6rrlDO_LYMv3U4hMyFCqnXBgXx5CWedCj5yNhFymQKHBY2_q-Bx9_Ne0irN0C2b-v"
message_title = "แจ้งเตือนจากป้อม รปภ."
message_body = "ตอนนี้ visitor กำลังขับรถมาหาคุณ"
# message_body = "ตอนนี้ whitelist กำลังขับรถมาหาคุณ"
message_body = "ตอนนี้ blacklist มาติดต่อขอพบที่บ้านคุณ"
data_message = {
    "job": "developer"
}

# result = push_service.notify_single_device(registration_id=registration_id,
#                                            message_title=message_title, message_body=message_body,
#                                            data_message=data_message)

# Send to multiple devices by passing a list of ids.
registration_ids = [
    "dMsGnvPqRTOVyOU0K4557I:APA91bFLCAtxlZR8whLanzfbhrw2hRXvV7VVEFZZX-8NqSaWexCnTNlF1vvW5rjEvojNXNyT_Re6rrlDO_LYMv3U4hMyFCqnXBgXx5CWedCj5yNhFymQKHBY2_q-Bx9_Ne0irN0C2b-v"]
result = push_service.notify_multiple_devices(
    registration_ids=registration_ids, message_title=message_title, message_body=message_body)

print(result)
