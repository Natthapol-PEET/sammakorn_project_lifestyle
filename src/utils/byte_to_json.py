import json


def byte_to_json(payload):
    my_json = payload.decode('utf8').replace("'", '"')
    data = json.loads(my_json)
    # data = json.dumps(data, indent=4, sort_keys=True)
    
    return data