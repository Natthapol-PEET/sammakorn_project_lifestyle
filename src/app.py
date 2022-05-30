from services import socket_manage
import uvicorn
from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi_mqtt import FastMQTT, MQTTConfig
from typing import Optional


# controllers
from controllers.alpr_controller import reciver_message_from_mqtt
from controllers.alpr_controller import forword_message_rest_to_mqtt


# configs
from configs import config

# authentication
from auth.auth import AuthHandler

# data
from data.database import database as db
from data.schemas import PayloadFromPi

# apis
from apis.qr_api import qr_api
from apis.web_api import web_api
from apis.app_api import app_api
from apis.imin_walkin_api import imin_walkin_api

# rounter
from routers import notification as noti
from routers import notification_pi as noti_pi
# from routers import ws


auth_handler = AuthHandler()

# from init_app import app

tags_metadata = [
    {"name": "Notification", "description": ""}
]

app = FastAPI(
    title="REST API using FastAPI PostgreSQL Async EndPoints (Sammakorn API)",
    openapi_tags=tags_metadata)

# register rounter
app.include_router(noti.router)
app.include_router(noti_pi.router)
# app.include_router(ws.router)

# mount server
app.mount('/app_api', app_api)
app.mount('/web_api', web_api)
app.mount('/qr_api', qr_api)
app.mount('/imin_walkin_api', imin_walkin_api)
# app.mount('/walkin_api', walkin_api)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=["http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

mqtt_config = MQTTConfig(host=config.mqtt_broker,
                         port=config.mqtt_port,
                         keepalive=60,
                         username=config.mqtt_user,
                         password=config.mqt_passwd)

mqtt = FastMQTT(
    config=mqtt_config,
    client_id=config.mqtt_clientId,
)

mqtt.init_app(app)

socketio_app = socket_manage.socketio.ASGIApp(socket_manage.sio, app)


@app.on_event("startup")
async def startup():
    await db.connect()
    await socket_manage.start_server()


@app.on_event("shutdown")
async def shutdown():
    await db.disconnect()
    await socket_manage.stop_server()


# --------------------------------- MQTT --------------------------
@mqtt.on_connect()
def connect(client, flags, rc, properties):
    print("Connected: ", client, flags, rc, properties)

    # join with alpr
    mqtt.client.subscribe(config.alpr_subscript_topic)


@mqtt.on_message()
async def message(client, topic, payload, qos, properties):
    # print("Received message: ", topic, payload.decode(), qos, properties)
    reciver_message_from_mqtt(topic, payload, mqtt)


# post data to alpr
@app.post('/to_alpr', status_code=200)
def to_alpr(payload: dict, x_access_tokens: Optional[str] = Header(None)):
    if x_access_tokens == config.x_access_tokens:
        return forword_message_rest_to_mqtt(payload, mqtt)
    else:
        raise HTTPException(status_code=404, detail="Invalid token.")


@mqtt.on_disconnect()
def disconnect(client, packet, exc=None):
    print("Disconnected")


@mqtt.on_subscribe()
def subscribe(client, mid, qos, properties):
    print("subscribed", client, mid, qos, properties)


@app.post('/mqtt-from-pi', status_code=200)
def publishing(data: PayloadFromPi, token=Depends(auth_handler.get_token)):
    if token == config.token:
        # publishing mqtt topic
        mqtt.publish(data.topic, data.payload)
        return {"result": True, "message": "Published"}
    else:
        raise HTTPException(status_code=401, detail='Invalid token')

# ------------------------------------------------------------------------------


if __name__ == '__main__':
    uvicorn.run("app:app", host="0.0.0.0", port=8080,
                reload=True, access_log=True, log_level="info",
                # log_config="logs/log.ini"
                # ssl_keyfile="ssl/key.pem", 
                # ssl_certfile="ssl/cert.pem"
                )
