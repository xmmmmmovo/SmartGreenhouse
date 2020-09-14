from base64 import b64encode
from datetime import datetime

import requests

now = datetime.now()

requests.post('http://192.168.137.1:9000/hardware/code',
              headers={'auth': b64encode(
                  f'{now.hour}/{now.minute}'.encode(encoding='utf-8'))}).json()
