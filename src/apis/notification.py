from pyfcm import FCMNotification
from fastapi.encoders import jsonable_encoder

# dotenv
from dotenv import dotenv_values

# creddentials
creddentials = dotenv_values(".env")


api_key = creddentials['API_KEY']
push_service = FCMNotification(api_key=api_key)


async def get_registration_ids(db, home_id):
    registration_ids = []

    query = f"SELECT device_token FROM resident_account WHERE home_id = {home_id}"
    result = jsonable_encoder(await db.fetch_all(query))

    print(result)

    for device_token in result:
        if device_token['device_token'] is not None:
            registration_ids.append(device_token['device_token'])

    return registration_ids


def thread_callback(registration_ids, title, body, data):
    result = push_service.notify_multiple_devices(
        registration_ids=registration_ids, message_title=title, message_body=body, data_message=data)
    print(result)


async def send_to_device(title, body, data, registration_ids):
    if registration_ids:
        try:
            import threading

            thr = threading.Thread(target=thread_callback, args=(
                registration_ids, title, body, data))
            thr.start()
            return 200
        except:
            print('FCM not work')
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

    return await send_to_device(title, body, data, registration_ids)


async def send_notification_v2(db, item, titleEnum, dataClassEnum, homeId=0):
    titleValue, body, data = createDummy(
        titleEnum, dataClassEnum, item, homeId=homeId)

    if "home_id" in dict(item):
        registration_ids = await get_registration_ids(db, item.home_id)
    else:
        print(f'register walk in: {homeId}')
        registration_ids = await get_registration_ids(db, homeId)

    print(f"registration_ids: {registration_ids}")

    return await send_to_device(titleValue, body, data, registration_ids)


def createDummy(titleEnum, dataClassEnum, item, homeId=0):
    titleName = titleEnum.name
    titleValue = titleEnum.value

    className = dataClassEnum.name
    classValue = dataClassEnum.value

    dictItem = dict(item)

    body = ""

    if titleName == "admin":
        if className == "registerBlacklist":
            body = f"นิติบุคคลได้ทำการเพิ่มรายชื่อ {item.firstname} {item.lastname} เป็น blacklist"
        elif className == "deleteBlacklist":
            body = f"นิติบุคคลได้ทำการลบรายชื่อ {item.firstname} {item.lastname} ออกจาก blacklist"
        elif className == "registerWhitelist":
            body = f"นิติบุคคลได้ทำการลบรายชื่อ {item.firstname} {item.lastname} เป็น whitelist"
        elif className == "deleteWhitelist":
            body = f"นิติบุคคลได้ทำการเพิ่มรายชื่อ {item.firstname} {item.lastname} ออกจาก whitelist"
        elif className == "adminStamp":
            if "firstname" in dictItem:
                body = f"นิติบุคคลได้ทำการแสตมป์ให้คุณ{item.firstname} {item.lastname}"
            elif "license_plate" in dictItem:
                if item.license_plate != "":
                    body = f"นิติบุคคลได้ทำการแสตมป์ให้หมายเลขทะเบียน {item.license_plate}"
                else:
                    if "qr_gen_id" in dictItem:
                        body = f"นิติบุคคลได้ทำการแสตมป์ให้รายการ {item.qr_gen_id}"
                    elif "code" in dictItem:
                        body = f"นิติบุคคลได้ทำการแสตมป์ให้รายการ {item.code}"
            elif "licensePlate" in dictItem:
                if item.licensePlate != "":
                    body = f"นิติบุคคลได้ทำการแสตมป์ให้หมายเลขทะเบียน {item.licensePlate}"
                else:
                    if "qr_gen_id" in dictItem:
                        body = f"นิติบุคคลได้ทำการแสตมป์ให้รายการ {item.qr_gen_id}"
                    elif "code" in dictItem:
                        body = f"นิติบุคคลได้ทำการแสตมป์ให้รายการ {item.code}"
            elif "qr_gen_id" in dictItem:
                body = f"นิติบุคคลได้ทำการแสตมป์ให้รายการ {item.qr_gen_id}"
            elif "code" in dictItem:
                body = f"นิติบุคคลได้ทำการแสตมป์ให้รายการ {item.code}"

    elif titleName == "guard":
        if className == "comming":
            if "firstname" in dictItem:
                if item.firstname != "" or item.firstname != "None":
                    body = f"คุณ{item.firstname} {item.lastname} เข้ามาในโครงการ"
                elif "license_plate" in dictItem:
                    if item.license_plate != "":
                        body = f"ทะเบียนรถหมายเลข {item.license_plate} เข้ามาในโครงการ"
                    elif "qr_gen_id" in dictItem:
                        body = f"รายการ {item.qr_gen_id} เข้ามาในโครงการ"
                    elif "code" in dictItem:
                        body = f"รายการ {item.code} เข้ามาในโครงการ"
                elif "licensePlate" in dictItem:
                    if item.licensePlate != "":
                        body = f"ทะเบียนรถหมายเลข {item.licensePlate} เข้ามาในโครงการ"
                    elif "qr_gen_id" in dictItem:
                        body = f"รายการ {item.qr_gen_id} เข้ามาในโครงการ"
                    elif "code" in dictItem:
                        body = f"รายการ {item.code} เข้ามาในโครงการ"
                elif "qr_gen_id" in dictItem:
                    body = f"รายการ {item.qr_gen_id} เข้ามาในโครงการ"
                elif "code" in dictItem:
                    body = f"รายการ {item.code} เข้ามาในโครงการ"
            elif "license_plate" in dictItem:
                if item.license_plate != "":
                    body = f"ทะเบียนรถหมายเลข {item.license_plate} เข้ามาในโครงการ"
                elif "qr_gen_id" in dictItem:
                    body = f"รายการ {item.qr_gen_id} เข้ามาในโครงการ"
                elif "code" in dictItem:
                    body = f"รายการ {item.code} เข้ามาในโครงการ"
            elif "licensePlate" in dictItem:
                if item.licensePlate != "":
                    body = f"ทะเบียนรถหมายเลข {item.licensePlate} เข้ามาในโครงการ"
                elif "qr_gen_id" in dictItem:
                    body = f"รายการ {item.qr_gen_id} เข้ามาในโครงการ"
                elif "code" in dictItem:
                    body = f"รายการ {item.code} เข้ามาในโครงการ"
            elif "qr_gen_id" in dictItem:
                body = f"รายการ {item.qr_gen_id} เข้ามาในโครงการ"
            elif "code" in dictItem:
                body = f"รายการ {item.code} เข้ามาในโครงการ"
        elif className == "checkout":
            if "firstname" in dictItem:
                if not (item.firstname != "" and item.firstname != None):
                    body = f"คุณ{item.firstname} {item.lastname} ออกจากโครงการ"
                elif "license_plate" in item:
                    if item.license_plate != "":
                        body = f"ทะเบียนรถหมายเลข {item.license_plate} ออกจากโครงการ"
                    else:
                        if "qr_gen_id" in dictItem:
                            body = f"รายการ {item.qr_gen_id} ออกจากโครงการ"
                        elif "code" in dictItem:
                            body = f"รายการ {item.code} ออกจากโครงการ"
                elif "licensePlate" in item:
                    if item.licensePlate != "":
                        body = f"ทะเบียนรถหมายเลข {item.licensePlate} ออกจากโครงการ"
                    else:
                        if "qr_gen_id" in dictItem:
                            body = f"รายการ {item.qr_gen_id} ออกจากโครงการ"
                        elif "code" in dictItem:
                            body = f"รายการ {item.code} ออกจากโครงการ"
                elif "qr_gen_id" in dictItem:
                    body = f"รายการ {item.qr_gen_id} ออกจากโครงการ"
                elif "code" in dictItem:
                    body = f"รายการ {item.code} ออกจากโครงการ"
            elif "license_plate" in item:
                if item.license_plate != "":
                    body = f"ทะเบียนรถหมายเลข {item.license_plate} ออกจากโครงการ"
                else:
                    if "qr_gen_id" in dictItem:
                        body = f"รายการ {item.qr_gen_id} ออกจากโครงการ"
                    elif "code" in dictItem:
                        body = f"รายการ {item.code} ออกจากโครงการ"
            elif "licensePlate" in item:
                if item.licensePlate != "":
                    body = f"ทะเบียนรถหมายเลข {item.licensePlate} ออกจากโครงการ"
                else:
                    if "qr_gen_id" in dictItem:
                        body = f"รายการ {item.qr_gen_id} ออกจากโครงการ"
                    elif "code" in dictItem:
                        body = f"รายการ {item.code} ออกจากโครงการ"
            elif "qr_gen_id" in dictItem:
                body = f"รายการ {item.qr_gen_id} ออกจากโครงการ"
            elif "code" in dictItem:
                body = f"รายการ {item.code} ออกจากโครงการ"

    if "home_id" in dictItem:
        data = {"Class": classValue, "home_id": item.home_id}
    else:
        data = {"Class": classValue, "home_id": homeId}

    print({
        "title": titleValue,
        "body": body,
        "data": data
    })

    return titleValue, body, data

    # return {
    #     "title": titleValue,
    #     "body": body,
    #     "data": {
    #         "Class": classValue,
    #         "home_id": item.home_id
    #     }
    # }
