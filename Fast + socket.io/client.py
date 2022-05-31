# client.py
import requests
import socketio
import time

# r = requests.get("http://127.0.0.1:5000/test") # server prints "test"
cl = socketio.Client()


@cl.on("event_name")
def foo(data):
    print(f"client 1 {data}")


cl.connect("http://127.0.0.1:3000/")    # server prints "on connect"
cl.emit("chat message", "Hello, from python") # prints client 1 msg_1


time.sleep(1)
cl.disconnect()