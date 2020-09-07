from flask_loguru import logger
from flask_mqtt import Mqtt

mqtt = Mqtt()


@mqtt.on_connect()
def handle_mqtt_connect(client, userdata, flags, rc):
    mqtt.subscribe('sensor_data')


@mqtt.on_message()
def handle_mqtt_message(client, userdata, message):
    logger.info(message)


@mqtt.on_disconnect()
def handle_disconnect():
    print("CLIENT DISCONNECTED")
