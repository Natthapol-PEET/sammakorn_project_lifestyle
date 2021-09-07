from apis.qr_api import qr_api
from apis.web_api import web_api
from apis.app_api import app_api

import uvicorn
from fastapi import FastAPI, HTTPException, Depends, \
    WebSocket, WebSocketDisconnect, Header
from fastapi.middleware.cors import CORSMiddleware
from typing import Optional

from data.database import database as db
from data.schemas import NotificationItem
from apis.notification import Notification
from auth.check_token import is_token_blacklisted as isTokenBlacklisted
from auth.auth import AuthHandler
from ws.connection_manage import ConnectionManager
import json

auth_handler = AuthHandler()
notification = Notification()
manager = ConnectionManager()


tags_metadata = [
    {"name": "Notification", "description": ""}
]

app = FastAPI(
    title="REST API using FastAPI PostgreSQL Async EndPoints (Sammakorn API)",
    openapi_tags=tags_metadata)

app.mount('/app_api', app_api)
app.mount('/web_api', web_api)
app.mount('/qr_api', qr_api)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=[
    #     "http://localhost:8080",
    #     "http://127.0.0.1:8080",
    #     "http://192.168.0.100:8080",
    # ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup():
    await db.connect()


@app.on_event("shutdown")
async def shutdown():
    await db.disconnect()


# ------------------------------ Notification  --------------------------------

@app.post('/notification/', tags=["Notification"], status_code=200)
async def notifications(item: NotificationItem, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await notification.send_notification(db, item=item)


@app.post('/notification_pi/', tags=["Notification"], status_code=200)
async def notification_pi(item: NotificationItem, user_agent: Optional[str] = Header(None)):
    if user_agent == "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff":
        return await notification.send_notification(db, item=item)
    else:
        raise HTTPException(status_code=401, detail='Invalid token')

# ------------------------------ End Notification  --------------------------------


# ------------------------------ Websocket  --------------------------------

@app.websocket("/ws/{token}/{apptype}/{home_id}/{deviceId}")
async def websocket_endpoint(websocket: WebSocket, token: str, apptype: str, home_id: int, deviceId: str):

    # Raspberry Pi Client
    if apptype == "PI" and token == "ogjvmodvmmaevjdvEVdsVOAERBMSDV0SFKD":
        status = 1001
        apptype = apptype.lower()
    else:
        # Web and App Client
        status = auth_handler.auth_wrapper_socket(token)

    if status == 1001:
        await manager.connect(websocket, apptype, home_id, deviceId)

        try:
            while True:
                data = await websocket.receive_text()
                # Convert data to dict
                data = json.loads(data)
                # Convert dict to string
                # data_str = json.dumps(data)
                # await manager.send_personal_message(f"You wrote: {data}", websocket)
                await manager.broadcast(websocket, data['topic'], data['send_to'], data['home_id'])
        except WebSocketDisconnect:
            await manager.disconnect(websocket, apptype)

    elif status == 1008:
        await websocket.close()


# ------------------------------ End Websocket  --------------------------------

if __name__ == '__main__':
    uvicorn.run("main:app", host="0.0.0.0", port=8080,
                workers=True, access_log=True, log_level="info")
