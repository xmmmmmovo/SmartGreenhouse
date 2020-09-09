import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import time
import threading
from loguru import logger
import paho.mqtt.client as mqtt
import requests
import os

reader = SimpleMFRC522()

rfid_topic = 'rfid_log'
mqtt_client: mqtt.Client = None

broker_url = '39.105.110.28'
port = 8083
user = 'emqx'
pwd = 'public'
transport = 'websockets'

data = {
    'uuid': None,
    'id': None,
    'text': None
}


def load_config():
    logger.info(f'开始读取配置信息')
    if os.path.exists('./uuid'):
        f = open('./uuid', 'r', encoding='utf-8')
        data['uuid'] = f.read().strip()
        logger.info('读取成功')
    else:
        logger.info('未找到，正在从云端获取')
        data['uuid'] = requests.post('http://192.168.137.1:9000/hardware/code').json()['data']
        f = open('./uuid', 'w', encoding='utf-8')
        f.write(data['uuid'])
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
        finally:
            GPIO.cleanup()
        time.sleep(5)


if __name__ == '__main__':
    RFID_tasks()
