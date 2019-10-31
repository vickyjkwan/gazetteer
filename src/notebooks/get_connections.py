import requests
import json
import os


def main(domain, url):

    conn_dict = dict()

    dir_path = os.path.dirname(os.path.abspath(__file__))

    with open(f'{dir_path}/../../.secrets/looker_secrets.json') as f:
        j = json.load(f)

    data = {
        'client_id': j['client_id'],
        'client_secret': j['client_secret']
    }

    response = requests.post(f'{domain}/login', data=data)

    access_token = response.json()['access_token']

    headers = {
        'Authorization': f'token {access_token}'
    }

    response = requests.get(domain+url, headers=headers)

    for r in response.json():
        conn_dict[r['name']] = {'database': r['database'], 'type': r['dialect']['label']}

    return conn_dict
