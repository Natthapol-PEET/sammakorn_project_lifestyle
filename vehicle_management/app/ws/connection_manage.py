from fastapi import  WebSocket
from typing import List

class ConnectionManager:
    def __init__(self):
        self.active_connections_app: List[WebSocket] = []
        self.active_connections_web: List[WebSocket] = []

    async def connect(self, websocket: WebSocket, apptype, home_id):
        await websocket.accept()

        if apptype == 'app':
            self.active_connections_app.append({
            "home_id": home_id,
            "websocket": websocket,
            })
        elif apptype == 'web':
            self.active_connections_web.append(websocket)

        print(self.active_connections_app)


    def disconnect(self, websocket: WebSocket, apptype):
        if apptype == 'app':
            data = next(item for item in self.active_connections_app if item["websocket"] == websocket)
            self.active_connections_app.remove(data)
        elif apptype == 'web':
            self.active_connections_web.remove(websocket)

        print(self.active_connections_app)


    # async def send_personal_message(self, message: str, websocket: WebSocket):
    #     await websocket.send_text(message)

    async def broadcast(self, websocket, message: str, send_to, home_id):
        if send_to == 'app':
            for connection in self.active_connections_app:
                if connection['home_id'] == home_id and connection['websocket'] != websocket:
                    await connection['websocket'].send_text(message)
        elif send_to == 'web':
            for connection in self.active_connections_web:
                if connection != websocket:
                    await connection.send_text(message)