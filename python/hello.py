import json
import datetime

def lambda_handler(event, context):
    result = {
        'message': 'Hello, Lambda World',
        'stamp' : str(datetime.datetime.now()),
    }

    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }
