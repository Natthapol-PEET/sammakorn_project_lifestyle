from dataclasses import replace
from fastapi import FastAPI, Depends, status, HTTPException, Header, Request
from fastapi.encoders import jsonable_encoder
from typing import Optional, List
from fastapi import FastAPI, HTTPException, Depends, \
    WebSocket, WebSocketDisconnect

from data.schemas import QRCode
from data.database import database as db

from datetime import datetime, timedelta, date
from auth.auth import AuthHandler

from configs import config
from data.models import resident_account

from icecream import ic
from configs import config

from services import socket_manage

tags_metadata = [
    {"name": "checkIn", "description": ""},
    {"name": "checkOut", "description": ""},
]

qr_api = FastAPI(openapi_tags=tags_metadata)
auth_handler = AuthHandler()


@qr_api.post("/entrance", status_code=201)
async def for_mp86(request: Request):
    qrId = await replaceRequest(request)
    ic(qrId)
    data = await comming_in(qrId)

    # send socket to nodejs server
    await socket_manage.emit_message('entrance', data)

    return {'status_code': 200}


@qr_api.post("/exit", status_code=201)
async def for_mp86(request: Request):
    qrId = await replaceRequest(request)
    ic(qrId)
    data = await checkout_func(qrId)

    # send socket to nodejs server
    await socket_manage.emit_message('exit', data)

    return {'status_code': 200}


@qr_api.post('/coming/', tags=["checkIn"], status_code=200)
async def comming(comming: QRCode, token=Depends(auth_handler.get_token)):
    if token == config.token:
        return await comming_in(comming.qrGenId)
    else:
        # ไม่ยืนยันตัวตน / ยืนยันตัวตนผิดพลาด
        raise HTTPException(status_code=401, detail='Invalid token')


@qr_api.post('/checkout/', tags=["checkOut"], status_code=200)
async def checkout(checkout: QRCode, token=Depends(auth_handler.get_token)):
    if token == config.token:
        return await checkout_func(checkout.qrGenId)
    else:
        # ไม่ยืนยันตัวตน / ยืนยันตัวตนผิดพลาด
        raise HTTPException(status_code=401, detail='Invalid token')


async def comming_in(qrGenId: str):
    #  user_agent: Optional[str] = Header(None),
    '''
        fullname: str
        licensePlate: str
        homeNumber: str
    '''

    if qrGenId == "":
        return {"isInvite": False}

    # search
    if qrGenId[0] == "V":
        today = date.today()
        d = today.strftime("%Y-%m-%d")

        query = f'''
            SELECT 'visitor' AS type, visitor_id AS class_ids, *
                FROM visitor AS v
                LEFT JOIN home AS h
                ON v.home_id = h.home_id
                WHERE qr_gen_id = '{qrGenId}'
                    AND invite_date = '{d}';
        '''

    elif qrGenId == "W":
        query = f'''
            SELECT 'whitelist' AS type, whitelist_id AS class_ids, *
                FROM whitelist AS w
                LEFT JOIN home AS h
                ON w.home_id = h.home_id
                WHERE qr_gen_id = '{qrGenId}'
        '''

    else:
        # card infomation
        query = f'''
            SELECT 'resident' AS type, resident_id AS class_ids, *
                FROM resident_account AS r
                LEFT JOIN home AS h
                ON r.home_id = h.home_id
                WHERE card_info = '{qrGenId}'
                    AND card_scan_position != 'Entrance'
        '''
        item = jsonable_encoder(await db.fetch_one(query))

        if item is not None:
            sql = f"UPDATE resident_account SET card_scan_position = 'Entrance' WHERE resident_id = {item['resident_id']}"
            await db.execute(sql)
            return {"isInvite": True, "data": item, "CLASS": "resident"}
        return {"isInvite": False, "CLASS": "resident"}

    item = jsonable_encoder(await db.fetch_one(query))

    # มีข้อมูล
    if item is not None:
        # เข้าไปหรือยัง
        if qrGenId[0] == "V":
            # check in history
            query = f"SELECT * FROM history_log WHERE class = 'visitor' AND class_id = {item['class_ids']}"
            isComIN = jsonable_encoder(await db.fetch_one(query))

            # coming in is success
            if isComIN is not None:
                if isComIN['datetime_out'] is not None:
                    # หมด session
                    return {"isInvite": False}
                # ข้อมูลนี้ได้ถูกเพิ่มไปแล้ว
                return {"isInvite": False, "data": item, "CLASS": "visitor"}

            else:       # V not coming in and W
                # insert data success
                dt = datetime.now()
                query = f'''INSERT INTO history_log (class, class_id, datetime_in, create_datetime)
                    VALUES ('{item['type']}', {item['class_ids']}, '{dt}', '{dt}');'''
                data = await db.fetch_all(query)
                data = jsonable_encoder(data)

        elif qrGenId[0] == "W":
            # check in history
            query = f"SELECT * FROM history_log WHERE class = 'whitelist' AND class_id = {item['class_ids']} AND datetime_out is NULL;"
            isWalkIN = jsonable_encoder(await db.fetch_one(query))

            # walk in is success
            if isWalkIN is None:
                # no scan
                # insert data success
                dt = datetime.now()
                query = f'''INSERT INTO history_log (class, class_id, datetime_in, create_datetime)
                    VALUES ('{item['type']}', {item['class_ids']}, '{dt}', '{dt}');'''
                data = await db.fetch_all(query)
                data = jsonable_encoder(data)

                return {"isInvite": True, "data": item, "CLASS": "visitor"}
            else:
                return {"isInvite": False, "data": item, "CLASS": "visitor"}

        return {"isInvite": True, "data": item, "CLASS": "visitor"}
    else:
        # ลูกบ้านไม่ได้ invite
        return {"isInvite": False}


async def checkout_func(qrGenId):
    if qrGenId[0] == "V":
        query = f'''SELECT *
                FROM (
                    SELECT 'visitor' AS type, visitor_id AS class_ids, *
                    FROM visitor AS v
                    LEFT JOIN history_log AS h
                    ON v.visitor_id = h.class_id
                    WHERE h.class = 'visitor'
                        AND h.datetime_out is NULL
                        AND qr_gen_id = '{qrGenId}'
                ) AS vh
                LEFT JOIN home AS h
                ON vh.home_id = h.home_id;
                '''
    elif qrGenId[0] == "W":
        query = f'''
                SELECT *
                FROM (
                    SELECT 'whitelist' AS type, whitelist_id AS class_ids, *
                    FROM whitelist AS w
                    LEFT JOIN history_log AS h
                    ON w.whitelist_id = h.class_id
                    WHERE h.class = 'whitelist'
                        AND h.datetime_out is NULL
                        AND qr_gen_id = '{qrGenId}'
                ) AS wh
                LEFT JOIN home AS h
                ON wh.home_id = h.home_id;
                '''
    else:
        # card info
        query = f'''
            SELECT * 
                FROM resident_account AS r
                LEFT JOIN home AS h
                ON h.home_id = r.home_id
                WHERE card_info = '{qrGenId}'
                    AND card_scan_position != 'Exit'
        '''
        data = jsonable_encoder(await db.fetch_one(query))

        if data is None:
            return {"msg": "No information in the system"}
        else:
            sql = f"UPDATE resident_account SET card_scan_position = 'Exit' WHERE resident_id = {data['resident_id']}"
            await db.execute(sql)
            return {"msg": "Card_Pass", "data": data}

    data = jsonable_encoder(await db.fetch_one(query))

    # มีข้อมูลในระบบ
    if data is not None:
        # car people or car
        # check resident is stamp
        if data['resident_stamp'] is not None:
            await updateTimeoutProject(data['log_id'])
            return {
                "msg": "Pass",
                "data": data,
            }

            # diff_time = calculateDiffTime(data['datetime_in'])

            # เกินเวลา
            # if diff_time.total_seconds() > (3 * 60 * 60):   # 3 hour
            #     # check นิติ stamp
            #     if data['admin_approve'] is None:
            #         # จ่ายเงิน
            #         day, hour = calDayTime(
            #             diff_time.total_seconds() - (3 * 60 * 60))

            #         return {"msg": "payment", "day": day, "time": hour, "data": data}

            #     elif data['admin_approve'] == True:
            #         # calculate difference time
            #         diff_time = calculateDiffTime(data['admin_datetime'])

            #         if diff_time.total_seconds() > (24 * 60 * 60):
            #             # เกินเวลา ต้องจ่ายเงิน
            #             day, hour = calDayTime(
            #                 diff_time.total_seconds() - ((3 * 60 * 60) + (24 * 60 * 60)))

            #             return {"msg": "payment", "day": day, "time": hour, "data": data}
            #         # ไม่เกินเวลาที่นิติกำหนด
            #         else:
            #             await updateTimeoutProject(data['log_id'])
            #             return {
            #                 "msg": "Pass",
            #                 "data": data,
            #             }

            # # ไม่เกินเวลา
            # else:
            #     await updateTimeoutProject(data['log_id'])
            #     return {
            #         "msg": "Pass",
            #         "data": data,
            #     }

        # ลูกบ้านยังไม่สแตมป์
        else:
            return {"msg": "resident not stamp", "data": data}
    # ไม่มีข้อมูลในระบบ
    else:
        return {"msg": "No information in the system"}


async def replaceRequest(request):
    # b'3307626965\r
    replaceList = ["b'", "r", "\r", "\r'", "\\r'", "\\", "'", "\n"]
    qrId = str(await request.body())

    for re in replaceList:
        qrId = qrId.replace(re, '')
    
    return qrId


async def updateTimeoutProject(log_id):
    query = f'''UPDATE history_log
                SET  datetime_out = '{datetime.now()}'
                WHERE history_log.log_id = {log_id};'''
    await db.execute(query)


# def calDayTime(seconds_input):
#     conversion = timedelta(seconds=int(seconds_input))
#     listTime = str(conversion).split(', ')

#     if len(listTime) == 1:
#         day = "0 day"
#         sp = listTime[0].split(':')
#         hour = f"{sp[0]}.{sp[1]}"
#     else:
#         day, hour = listTime
#         sp = hour.split(':')
#         hour = f"{sp[0]}.{sp[1]}"

#     return day, hour


# def calculateDiffTime(data):
#     date, time = data.split('T')
#     year, mon, day = date.split('-')
#     time, _ = time.split('.')
#     datetime_str = f"{int(day)-0}/{mon}/{year[2:]} {time}"
#     diff_time = datetime.now() - datetime.strptime(datetime_str, '%d/%m/%y %H:%M:%S')

#     return diff_time


# class ConnectionManager:
#     def __init__(self):
#         self.active_connections: List = []

#     async def connect(self, websocket: WebSocket, position: str):
#         await websocket.accept()
#         self.active_connections.append({
#             "position": position,
#             "websocket": websocket,
#         })

#     def disconnect(self, websocket: WebSocket, position: str):
#         try:
#             self.active_connections.remove({
#                 "position": position,
#                 "websocket": websocket,
#             })
#         except:
#             pass

#     async def send_personal_message(self, message: str, websocket: WebSocket):
#         await websocket.send_text(message)

#     async def broadcast(self, message: str, websocket: WebSocket):
#         for dict in self.active_connections:
#             if dict['position'] == "IN" and dict['websocket'] is not websocket:
#                 await dict['websocket'].send_text(message)
#             elif dict['position'] == "OUT" and dict['websocket'] is not websocket:
#                 await dict['websocket'].send_text(message)


# manager = ConnectionManager()


# @qr_api.websocket("/ws/{key}/{position}")
# async def websocket_endpoint(websocket: WebSocket, key: str, position: str):
#     if key == 'ogjvmodvmmaevjdvEVdsVOAERBMSDV0SFKD':
#         await manager.connect(websocket, position)
#         try:
#             while True:
#                 data = await websocket.receive_text()
#                 # await manager.send_personal_message(f"You wrote: {data}", websocket)

#                 await manager.broadcast(data, websocket)
#         except WebSocketDisconnect:
#             manager.disconnect(websocket, position)
#             # await manager.broadcast(f"Client #{client_id} left the chat")
#     else:
#         await websocket.close()
