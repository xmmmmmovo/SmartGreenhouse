from flask_loguru import logger
import paho.mqtt.client as mqtt
import json
from db.hardware_dao import insert_sensor_data, insert_rfid_log
from config import config
from re import match

sensor_data_topic = 'sensor_data'
rfid_topic = 'rfid_log'
mqtt_config = config['mqtt']


def handle_mqtt_connect(client, userdata, flags, rc):
    if rc == 0:
        logger.info('Connected to mqtt broker!')
    else:
        logger.info('Failed to connect to mqtt broker!')

    client.subscribe(sensor_data_topic)
    client.subscribe(rfid_topic)
    client.on_message = handle_mqtt_message


def handle_mqtt_message(client, userdata, message):
    logger.info(f'topic: {message.topic}, message: {message.payload.decode()}')
    if message.topic == sensor_data_topic:
        data = json.loads(message.payload)
        insert_sensor_data(data['temperature'], data['humidity'], data['uuid'], data['fire'],
                           data['illumination'],
                           data['solid'])
    elif message.topic == rfid_topic:
        data = json.loads(message.payload)
        insert_rfid_log(match(r'(\d+)', data['text']).group(1), data['uuid'])


def connect_mqtt():
    mqtt_client = mqtt.Client(mqtt_config['client_id'], transport=mqtt_config['transport'])
    mqtt_client.username_pw_set(mqtt_config['user'], mqtt_config['pwd'])
    mqtt_client.on_connect = handle_mqtt_connect
    mqtt_client.connect(mqtt_config['broker_url'], mqtt_config['port'])
    mqtt_client.loop_start()
    return mqtt_client


mqtt_client: mqtt.Client = connect_mqtt()
