from flask_loguru import logger
import paho.mqtt.client as mqtt
import json

broker_url = '39.105.110.28'
port = 8083
user = 'emqx'
pwd = 'public'
transport = 'websockets'
client_id = 'server-mqtt'

sensor_data_topic = 'sensor_data'

mqtt_client: mqtt.Client = None


def connect_mqtt():
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
            data = json.loads(message.payload.decode())

            pass

    mqtt_client = mqtt.Client(client_id, transport='websockets')
    mqtt_client.username_pw_set(user, pwd)
    mqtt_client.on_connect = handle_mqtt_connect
    mqtt_client.connect(broker_url, port)
    mqtt_client.loop_start()
