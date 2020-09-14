from base64 import b64encode
from datetime import datetime
from json import dumps, loads

import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import time
import threading
from loguru import logger
import paho.mqtt.client as mqtt
import requests
import os
from config import config_

reader = SimpleMFRC522()

rfid_topic = 'rfid_log'
mqtt_client: mqtt.Client = None
mqtt_config = config_['mqtt']

broker_url = mqtt_config['broker_url']
port = mqtt_config['port']
user = mqtt_config['user']
pwd = mqtt_config['pwd']
transport = mqtt_config['transport']

data = {
    'uuid': '',
    'id': '',
    'text': ''
}


def load_config():
    logger.info(f'开始读取配置信息')
    if os.path.exists('./c.json'):
        f = open('./c.json', 'r', encoding='utf-8')
        j = loads(f.read())
        data['uuid'] = j['uuid']
        res = requests.get(f"http://192.168.137.1:9000/hardware/code/{data['uuid']}")
        if res.json()['code'] != 200:
            now = datetime.now()
            data['uuid'] = requests.post('http://192.168.137.1:9000/hardware/code',
                                         headers={'auth': b64encode(
                                             f'{now.hour}/{now.minute}'.encode(encoding='utf-8'))}).json()['data']
            f = open('./c.json', 'w', encoding='utf-8')
            f.write(dumps({'uuid': data['uuid'], 'temperature_limit': 35.00, 'humidity_limit': 50.00}))
            f.close()
        data['temperature_limit'] = j['temperature_limit']
        data['humidity_limit'] = j['humidity_limit']
        logger.info('读取成功')
        f.close()
    else:
        logger.info('未找到，正在从云端获取')
        now = datetime.now()
        data['uuid'] = requests.post('http://192.168.137.1:9000/hardware/code',
                                     headers={'auth': b64encode(
                                         f'{now.hour}/{now.minute}'.encode(encoding='utf-8'))}).json()['data']
        if data['uuid'] is None:
            logger.error('获取失败！请检查网络或验证数据！')
        else:
            f = open('./c.json', 'w', encoding='utf-8')
            f.write(dumps({'uuid': data['uuid'], 'temperature_limit': 35.00, 'humidity_limit': 50.00}))
            f.close()


def connect_mqtt():
    global mqtt_client

    def handle_mqtt_connect(client, userdata, flags, rc):
        if rc == 0:
            logger.info('Connected to mqtt broker!')
        else:
            logger.info('Failed to connect to mqtt broker!')

    mqtt_client = mqtt.Client(data['uuid'] + '_rfid_client', transport='websockets')
    mqtt_client.username_pw_set(user, pwd)
    mqtt_client.on_connect = handle_mqtt_connect
    mqtt_client.connect(broker_url, port)
    mqtt_client.loop_start()


class RFIDThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)

    def run(self):
        logger.info('Starting RFID thread')
        RFID_tasks()


def RFID_tasks():
    while True:
        try:
            id, text = reader.read()
            data['id'] = id
            data['text'] = text
            mqtt_client.publish(rfid_topic, data)
            logger.info(f'push data {data}')
        finally:
            GPIO.cleanup()
        time.sleep(5)


if __name__ == '__main__':
    load_config()
    connect_mqtt()
    RFID_tasks()
