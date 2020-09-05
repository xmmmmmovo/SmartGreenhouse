from flask_loguru import logger
from flask_mqtt import Mqtt

mqtt = Mqtt()


@mqtt.on_connect()
def handle_mqtt_connect():
    mqtt.subscribe('a')


@mqtt.on_message()
def handle_mqtt_message():
    pass
