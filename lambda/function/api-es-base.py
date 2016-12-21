import json

def handler(event, context):
    print("Received event: ")
    print json.dumps(event)
    # return { "message": "Hello, World!" }
