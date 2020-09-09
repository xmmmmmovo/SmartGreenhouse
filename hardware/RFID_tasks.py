import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import time
import threading
from loguru import logger
import paho.mqtt.client as mqtt

reader = SimpleMFRC522()

sensor_data_topic = 'rfid_log'
mqtt_client: mqtt.Client = None

broker_url = '39.105.110.28'
port = 8083
user = 'emqx'
pwd = 'public'
transport = 'websockets'


def connect_mqtt():
    global mqtt_client

    def handle_mqtt_connect(client, userdata, flags, rc):
        if rc == 0:
            logger.info('Connected to mqtt broker!')
        else:
            logger.info('Failed to connect to mqtt broker!')

    mqtt_client = mqtt.Client(data['uuid'] + '_sensor_client', transport='websockets')
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
            print(id)
            print(text)
        finally:
            GPIO.cleanup()
        time.sleep(5)


if __name__ == '__main__':
    RFID_tasks()
