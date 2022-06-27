
# --------- MQTT cinonfiguretion ----------
'''
    1. mqtt
    2. socket io
    3. postgresql
'''

container = True

if container:
    socket_url = "http://vms_socketio:9090"
    mqtt_broker = "vms_mqtt"
    db_server = "vms_db"
    enableNgrok = False
else:
    db_server = "localhost"
    mqtt_broker = "broker.hivemq.com"
    socket_url = "https://socketio-service.ngrok.io/"
    # enableNgrok = True
    enableNgrok = False

mqtt_port = 1883
mqtt_user = "vms-user@lifestyle.co.th"
mqt_passwd = "P@ssW0rd@lifestyle.co.th"
mqtt_clientId = "vms-server-1"
alpr_publish_topic = "/vms-mqtt/server_to_alpr/"
alpr_subscript_topic = "/vms-mqtt/alpr_to_server/"
x_access_tokens = "x-access-tokens"

# host.docker.internal
socket_token = "0edf3e46-8c78-49da-8980-a96eb3263941"

# token gate barier
token = "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff"

# forgot password link
forgotUrl = "https://artani-vms-guard.netlify.app/recoverypassword"



# Get path
import os

path = os.path.abspath(os.getcwd())

pathImage = os.path.join(path, "images")
pathProfile = os.path.join(path, "images", "profiles")
pathCard = os.path.join(path, "images", "card")
pathEmail = os.path.join(path, "images", "email")


# WSL
# /mnt/e/Vehicle_Management_System/sammakorn_project_lifestyle/fastapi-vms-service/src

# Windows
# E:\Vehicle_Management_System\sammakorn_project_lifestyle\fastapi-vms-service\src

