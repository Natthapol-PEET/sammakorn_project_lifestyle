from fastapi import WebSocket


class ConnectionManager:
    def __init__(self):
        self.active_connections_app = []
        self.active_connections_web = []
        self.active_connections_pi = []

    def isDuplicate(self, deviceId):
        # find deviceId in list
        for item in self.active_connections_app:
            if item["deviceId"] == deviceId:
                return item
            else:
                return []

    def add_connection_app(self, websocket, deviceId, home_id):
        self.active_connections_app.append({
            "deviceId": deviceId,
            "home_id": home_id,
            "websocket": websocket,
        })

    async def connect(self, websocket: WebSocket, apptype, home_id, deviceId):
        await websocket.accept()

        if apptype == 'app':
            if deviceId == 'temporary':
                self.add_connection_app(websocket, deviceId, home_id)
            else:
                data = self.isDuplicate(deviceId)

                if data is not None:
                    # find index in list
                    try:
                        index = self.active_connections_app.index(data)
                        # update websocket in data
                        data['websocket'] = websocket
                        # update data in list
                        self.active_connections_app[index] = data
                    except:
                        pass
                else:
                    # append
                    self.add_connection_app(websocket, deviceId, home_id)

        elif apptype == 'web':
            self.active_connections_web.append(websocket)

        elif apptype == 'pi':
            self.active_connections_pi.append(websocket)

    async def disconnect(self, websocket: WebSocket, apptype):
        if apptype == 'app':
            self.remove_connection_app(websocket)
        elif apptype == 'web':
            self.remove_connection_web(websocket)
        elif apptype == 'pi':
            self.active_connections_pi.remove(websocket)

        await websocket.close()

    # async def send_personal_message(self, message: str, websocket: WebSocket):
    #     await websocket.send_text(message)

    async def broadcast(self, websocket, message, send_to, home_id):
        if send_to == 'app':
            try:
                self.sendToApp(self, websocket, message, home_id)
            except:
                pass
        elif send_to == 'web':
            try:
                self.sendToWeb(websocket, message)
            except:
                pass
        elif send_to == 'webapp':
            try:
                await self.sendToApp(websocket, message, home_id)
            except:
                pass
            try:
                await self.sendToWeb(websocket, message)
            except:
                pass

    async def sendToApp(self, websocket, message, home_id):
        for connection in self.active_connections_app:
            if connection['home_id'] == home_id and connection['websocket'] != websocket:
                try:
                    await connection['websocket'].send_text(message)
                except:
                    self.remove_connection_app(connection['websocket'])

    async def sendToWeb(self, websocket, message):
        for connection in self.active_connections_web:
            if connection != websocket:
                try:
                    await connection.send_text(message)
                except:
                    self.remove_connection_web(websocket)

    def remove_connection_web(self, websocket):
        self.active_connections_web.remove(websocket)

    def remove_connection_app(self, websocket):
        try:
            data = next(
                item for item in self.active_connections_app if item["websocket"] == websocket)
            self.active_connections_app.remove(data)
        except:
            pass
