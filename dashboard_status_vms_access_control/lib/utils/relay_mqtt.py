from paho.mqtt import client as mqtt_client
from time import sleep
from smbus import SMBus
from threading import Thread
import RPi.GPIO as GPIO

broker = '54.255.225.178'
port = 1883
client_id = f'mqtt_relay_control'
username = 'user1@vms.com'
password = 'vms-passwd'


# closeGate = True
timeOut = 8
mqtt_work = False


DEVICE_BUS = 1
DEVICE_ADDR = 0x10
bus = SMBus(DEVICE_BUS)


def toggle_relay(client, index):
    if index > 4:
        client.publish("/mqtt_relay_control_reply", "index error")
        return 'index error'
    else:
        try:
            # เปิด gate
            # if index == 1:
            #     closeGate = False
            # elif index == 2:
            #     closeGate = True

            bus.write_byte_data(DEVICE_ADDR, index, 0xFF)
            sleep(1)
            bus.write_byte_data(DEVICE_ADDR, index, 0x00)
            sleep(1)

            client.publish("/mqtt_relay_control_reply", "success")

            return 'ok'

        except KeyboardInterrupt as e:
            client.publish("/mqtt_relay_control_reply", "error")
            return 'error'


def connect_mqtt() -> mqtt_client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def subscribe(client: mqtt_client):
    def on_message(client, userdata, msg):
        print(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")

        index = msg.payload.decode()
        toggle_relay(client, int(index))

    client.subscribe("/mqtt_relay_control")
    client.on_message = on_message


pin = 21
GPIO.setmode(GPIO.BCM)
GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)

closeGate = False

def relay_command(index):
    global closeGate

    if index == 2:
        closeGate = True

    bus.write_byte_data(DEVICE_ADDR, index, 0xFF)
    sleep(1)
    bus.write_byte_data(DEVICE_ADDR, index, 0x00)
    sleep(1)


def loop_check():
    global closeGate

    countTime = 0
    lock = True

    while True:
        print(f"status => {GPIO.input(pin)}")

        # กดปุ่ม => 1
        if lock == True and GPIO.input(pin) == 0:
            lock = False

        # ปล่อยปุ่ม => 0
        if lock == False and GPIO.input(pin) == 1:
            lock = True

            # ปิดไม้กั้น
            relay_command(2)

        # -------------------- MQTT Work ------------------

        if closeGate == True:
            countTime = timeOut

        while countTime > 0:
            # กดปุ่ม => 1
            if lock == True and GPIO.input(pin) == 0:
                lock = False
                # เปิดไม้กั้น
                relay_command(1)

            # ปล่อยปุ่ม => 0
            if lock == False and GPIO.input(pin) == 1:
                lock = True
                # ปิดไม้กั้น
                relay_command(2)
                countTime = timeOut

            if countTime > 0:
                countTime = countTime - 1
            if countTime == 0:
                closeGate = False

            print(f"countTime => {countTime}")
            sleep(1)

        sleep(1)


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    x = Thread(target=loop_check)
    x.start()
    run()