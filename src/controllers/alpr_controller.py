from icecream import ic

# configs
from configs import config

# utils
from utils.byte_to_json import byte_to_json


def reciver_message_from_mqtt(topic, payload, mqtt):
    ic(topic)
    payload = byte_to_json(payload)
    print(f"payload >> {payload}")

    if topic == config.alpr_subscript_topic:
        if payload['action'] == 'check-in':
            ic(payload['action'])

            # update to database >> check-in

            response = {
                "vehicle_id": "dae32031-5845-446e-a8fd-015a6398606c",
                "message": "check-in successful",
            }

            mqtt.publish(config.alpr_publish_topic, response)

        elif payload['action'] == 'checkout':
            ic(payload['action'])

            # update to database >> checkout

            response = {
                "vehicle_id": "dae32031-5845-446e-a8fd-015a6398606c",
                "message": "checkout successful",
            }

            mqtt.publish(config.alpr_publish_topic, response)


def forword_message_rest_to_mqtt(payload, mqtt):
    '''
        Action
            register >> ["resident", "guest", "whilelist", "backlist"]
            delete 
            stamp 
    '''

    # redister >> insert data to db

    # delete >> delete data from db

    # stamp >> update data to db
    
    ic(payload)
    mqtt.publish(config.alpr_publish_topic, payload)

    return True
