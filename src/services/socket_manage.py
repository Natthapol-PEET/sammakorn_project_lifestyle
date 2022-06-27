from time import sleep
import socketio
from configs import config
import asyncio
from icecream import ic
from threading import Thread

sio = socketio.AsyncClient()


async def signin():
    await sio.emit('signin', 'fastapi-signin')
    await sio.emit('message', 'fastapi-message')


async def some_callback(isConnect, event, msg):
    if isConnect:
        print(f"sent-message: {event, msg}")
        await sio.emit('sent-message', {'room': event, 'topic': msg})
    else:
        sending = False
        count = 0
        while not sending:
            try: await sio.connect(config.socket_url, headers={"authorization": config.socket_token})
            except: 
                print("socket except")
                sleep(2)
                count += 1
                if count == 10:
                    sending = True
                continue
            print(f"sent-message: {event, msg}")
            await sio.emit('sent-message', {'room': event, 'topic': msg})
            sending = True

def between_callback(isConnect, event, msg):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    loop.run_until_complete(some_callback(isConnect, event, msg))
    loop.close()


async def emit_message(event, msg):
    isConnect = sio.connected
    print(f"isConnect >> {isConnect}")

    _thread = Thread(target=between_callback, args=(isConnect, event, msg))
    _thread.start()

    # if isConnect:
    #     print(f"sent-message: {event, msg}")
    #     await sio.emit('sent-message', {'room': event, 'topic': msg})
    # else:
    #     await start_server()
    #     await asyncio.sleep(3)
    #     print(f"sent-message: {event, msg}")
    #     await sio.emit('sent-message', {'room': event, 'topic': msg})

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
            await sio.connect(config.socket_url, headers={"authorization": config.socket_token})
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
