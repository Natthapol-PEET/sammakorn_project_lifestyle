# from fastapi import APIRouter, WebSocket, WebSocketDisconnect
# import json

# # authentication
# from auth.auth import AuthHandler

# # websocket
# from ws.connection_manage import ConnectionManager

# # configs
# from configs import config

# auth_handler = AuthHandler()
# manager = ConnectionManager()

# router = APIRouter(
#     prefix="/ws",
#     tags=["Websocket"],
#     responses={404: {"message": "Not found"}}
# )


# @router.websocket("/{token}/{apptype}/{home_id}/{deviceId}")
# async def websocket_endpoint(websocket: WebSocket, token: str, apptype: str, home_id: int, deviceId: str):
#     # Raspberry Pi Client
#     if apptype == "PI" and token == config.token_pi:
#         status = 1001
#         apptype = apptype.lower()
#     else:
#         # Web and App Client
#         status = auth_handler.auth_wrapper_socket(token)

#     if status == 1001:
#         await manager.connect(websocket, apptype, home_id, deviceId)

#         try:
#             while True:
#                 data = await websocket.receive_text()
#                 # Convert data to dict
#                 data = json.loads(data)
#                 # Convert dict to string
#                 # data_str = json.dumps(data)
#                 # await manager.send_personal_message(f"You wrote: {data}", websocket)
#                 await manager.broadcast(websocket, data['topic'], data['send_to'], data['home_id'])
#         except WebSocketDisconnect:
#             await manager.disconnect(websocket, apptype)

#     elif status == 1008:
#         await websocket.close()
