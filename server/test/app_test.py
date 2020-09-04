import unittest
import requests as r
import json
from pprint import pprint

BASE_URL = 'http://127.0.0.1:5000'
headers = {
    'Content-Type': 'application/json'
}


class MyTestCase(unittest.TestCase):
    def test_post_user(self):
        d = {}
        res = r.post(f'{BASE_URL}/user', headers=headers,
                     data=json.dumps(
                         {
                             "email": "123",
                             "name": "111"
                         }
                     ))
        self.assertEqual(res.status_code, 200)
        pprint(json.loads(res.text))

    def test_post_post(self):
        pass


if __name__ == '__main__':
    unittest.main()
