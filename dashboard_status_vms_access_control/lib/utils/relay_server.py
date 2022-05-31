from flask import Flask
from time import sleep
from smbus import SMBus

app = Flask(__name__)

DEVICE_BUS = 1
DEVICE_ADDR = 0x10
bus = SMBus(DEVICE_BUS)

def toggle_relay(index):
    if index > 4:
        return 'index error'
    else:
        try:
            bus.write_byte_data(DEVICE_ADDR, index, 0xFF)
            sleep(1)
            bus.write_byte_data(DEVICE_ADDR, index, 0x00)
            sleep(1)

            return 'ok'

        except KeyboardInterrupt as e:
            return 'error'

@app.route('/relay-toggle/<index>')
def hello_world(index):
    try:
        return toggle_relay(int(index))
    except:
        return 'index as int'

if __name__ == '__main__':
    app.run(host='0.0.0.0')
