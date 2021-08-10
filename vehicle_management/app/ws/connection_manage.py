from fastapi import  WebSocket

class ConnectionManager:
    def __init__(self):
        self.active_connections_app = []
        self.active_connections_web = []


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


    async def disconnect(self, websocket: WebSocket, apptype):
        if apptype == 'app':
            self.remove_connection_app(websocket)
        elif apptype == 'web':
            self.remove_connection_web(websocket)

        await websocket.close()


    # async def send_personal_message(self, message: str, websocket: WebSocket):
    #     await websocket.send_text(message)


    async def broadcast(self, websocket, message, send_to, home_id):
        if send_to == 'app':
            for connection in self.active_connections_app:
                if connection['home_id'] == home_id and connection['websocket'] != websocket:
                    try:
                        print('send to app')
                        await connection['websocket'].send_text(message)
                    except:
                        self.remove_connection_app(connection['websocket'])
        elif send_to == 'web':
            for connection in self.active_connections_web:
                if connection != websocket:
                    try:
                        print('send to web')
                        await connection.send_text(message)
                    except:
                        self.remove_connection_web(websocket)


    def remove_connection_web(self, websocket):
        self.active_connections_web.remove(websocket)


    def remove_connection_app(self, websocket):
        data = next(item for item in self.active_connections_app if item["websocket"] == websocket)
        self.active_connections_app.remove(data)
