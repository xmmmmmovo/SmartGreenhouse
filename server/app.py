from flask import Flask
from mqtt import mqtt
from response import response_success
from time import time
from flask_loguru import Logger
from flask_loguru import logger
from exception import exception
from bp.user_app import user_bp
from bp.hardware_app import hardware_bp
from cache import redis


app = Flask(__name__)
app.config['REDIS_URL'] = 'redis://redis:6379/0'
app.register_blueprint(exception)
app.register_blueprint(user_bp, url_prefix='/user')
app.register_blueprint(hardware_bp, url_prefix='/hardware')

app.config['MQTT_BROKER_URL'] = '39.105.110.28'
app.config['MQTT_BROKER_PORT'] = 8083
app.config['MQTT_USERNAME'] = 'emqx'
app.config['MQTT_PASSWORD'] = 'public'
app.config['MQTT_REFRESH_TIME'] = 1.0  # refresh time in seconds
app.config['REDIS_URL'] = 'redis://:7GhVu9i24mjK@39.105.110.28:44443/0'

log = Logger()


@app.route('/')
def hello_world():
    return response_success('success', int(round(time() * 1000)))


if __name__ == '__main__':
    log.init_app(app, {
        'LOG_PATH': '../log',
        'LOG_NAME': 'run.log'
    })
    mqtt.init_app(app)
    logger.info(mqtt.connected)
    redis.init_app(app)
    app.run(host='0.0.0.0', port=8888, debug=False)
