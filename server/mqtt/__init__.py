from flask_loguru import logger
import paho.mqtt.client as mqtt
import json
from db.hardware_dao import insert_sensor_data
from config import config

sensor_data_topic = 'sensor_data'
mqtt_config = config['mqtt']

mqtt_client: mqtt.Client = None


def handle_mqtt_connect(client, userdata, flags, rc):
    if rc == 0:
        logger.info('Connected to mqtt broker!')
    else:
        logger.info('Failed to connect to mqtt broker!')

    client.subscribe(sensor_data_topic)
    client.on_message = handle_mqtt_message


def handle_mqtt_message(client, userdata, message):
    logger.info(f'topic: {message.topic}, message: {message.payload.decode()}')
    if message.topic == sensor_data_topic:
        data = json.loads(message.payload)
        eff_row = insert_sensor_data(data['humidity'], data['temperature'], data['uuid'], data['fire'],
                                     data['illumination'],
                                     data['solid'])
        logger.info(f'eff_row: {eff_row}')


def connect_mqtt():
    global mqtt_client
    mqtt_client = mqtt.Client(mqtt_config['client_id'], transport=mqtt_config['transport'])
    mqtt_client.username_pw_set(mqtt_config['user'], mqtt_config['pwd'])
    mqtt_client.on_connect = handle_mqtt_connect
    mqtt_client.connect(mqtt_config['broker_url'], mqtt_config['port'])
    mqtt_client.loop_start()
