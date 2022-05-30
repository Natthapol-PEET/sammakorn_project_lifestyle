import socketio
from configs import config
import asyncio
from icecream import ic

sio = socketio.AsyncClient()


async def signin():
    await sio.emit('signin', 'fastapi-signin')
    await sio.emit('message', 'fastapi-message')


async def emit_message(event, msg):
    isConnect = sio.connected
    print(f"isConnect >> {isConnect}")

    if isConnect:
        await sio.emit(event, msg)
    else:
        await start_server()
        await asyncio.sleep(3)
        await emit_message(event, msg)


@sio.event
async def disconnect():
    print("I'm disconnected!")
    await start_server()


@sio.event
def connect_error(data):
    print("The connection failed!")


@sio.event
async def connect():
    print('connected to server')
    # await signin()


async def start_server():
    isConnect = sio.connected
    print(f"isConnect >> {isConnect}")

    if not isConnect:
        try:
            await sio.connect(config.socket_url, headers={"Authorization": "Bearer "+config.socket_token})
        except:
            await asyncio.sleep(3)
            await start_server()
        # await sio.wait()
    else:
        print('restart socket server ...')
        await sio.disconnect()
        await asyncio.sleep(3)
        await start_server()


async def stop_server():
    if sio.connected:
        await sio.disconnect()
