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

# apis
from apis.qr_api import qr_api
from apis.web_api import web_api
from apis.app_api import app_api
from apis.imin_api import imin_api
from apis.image_api import image_api

# rounter
# from routers import notification as noti
# from routers import notification_pi as noti_pi
# from routers import ws


auth_handler = AuthHandler()

# from init_app import app

tags_metadata = []

app = FastAPI(
    title="REST API using FastAPI PostgreSQL Async EndPoints (Sammakorn API)",
    openapi_tags=tags_metadata)

# register rounter
# app.include_router(noti.router)
# app.include_router(noti_pi.router)
# app.include_router(ws.router)

# mount server
app.mount('/app_api', app_api)
app.mount('/web_api', web_api)
app.mount('/qr_api', qr_api)
app.mount('/imin_walkin_api', imin_api)
app.mount('/image_api', image_api)
# app.mount('/walkin_api', walkin_api)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=["http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

socketio_app = socket_manage.socketio.ASGIApp(socket_manage.sio, app)

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


@mqtt.on_disconnect()
def disconnect(client, packet, exc=None):
    print("Disconnected")


@mqtt.on_subscribe()
def subscribe(client, mid, qos, properties):
    print("subscribed", client, mid, qos, properties)


@app.get('/gate/open/', status_code=200)
def publishing(token=Depends(auth_handler.get_token)):
    if token == config.token:
        # publishing mqtt topic
        mqtt.publish("/mqtt/gate", "open")
        return {"detail": True, "message": "Published"}
    else:
        raise HTTPException(status_code=401, detail='Invalid token')


@app.get('/gate/close/', status_code=200)
def publishing(token=Depends(auth_handler.get_token)):
    if token == config.token:
        # publishing mqtt topic
        mqtt.publish("/mqtt/gate", "close")
        return {"detail": True, "message": "Published"}
    else:
        raise HTTPException(status_code=401, detail='Invalid token')

# ------------------------------------------------------------------------------


if __name__ == '__main__':
    # ngrok
    if config.enableNgrok:
        from pyngrok import ngrok, conf
        conf.get_default().auth_token = "1Z4FuXChSDd2OAdFcDxTS7h8aeQ_4LVDV8ErSMjeg6aphr1tA"
        conf.get_default().region = "us"
        ngrok_tunnel = ngrok.connect(8080, proto="http", subdomain="vms-service")
        print('Public URL:', ngrok_tunnel.public_url)
    
    uvicorn.run("app:app", host="0.0.0.0", port=8080,
                reload=True, 
                access_log=True, 
                log_level="info",
                # log_config="logs/log.ini"
                # ssl_keyfile="./key.pem",
                # ssl_certfile="./cret.pem"
                )
                