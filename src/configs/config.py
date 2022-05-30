
# --------- MQTT cinonfiguretion ----------
'''
    1. mqtt
    2. socket io
    3. postgresql
'''

mqtt_broker = "broker.hivemq.com"
# mqtt_broker = "broker.hivemq.com"
# mqtt_broker = "emqx"
mqtt_port = 1883
mqtt_user = "vms-user@lifestyle.co.th"
mqt_passwd = "P@ssW0rd@lifestyle.co.th"
# mqtt_clientId = "vms-server-" + str(uuid.uuid4().hex)
mqtt_clientId = "vms-server-1"
alpr_publish_topic = "/vms-mqtt/server_to_alpr/"
alpr_subscript_topic = "/vms-mqtt/alpr_to_server/"
x_access_tokens = "x-access-tokens"

# Notification Authentication
token = "nsr0bjfkbmmiarnbkzncvinrabkkvnaddff"

# Raspberry pi Authentication
# token_pi = "ogjvmodvmmaevjdvEVdsVOAERBMSDV0SFKD"

# host.docker.internal
socket_url = "http://localhost:9090/"
# socket_url = "http://node-socketio-service:9090/"
socket_token = "fg1pY_DwF8eZ8HyMAAAD"
