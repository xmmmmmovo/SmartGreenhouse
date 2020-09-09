from flask import Flask
from response import response_success
from time import time
from flask_loguru import Logger
from flask_loguru import logger
from flask_cors import CORS
from exception import exception
from bp.user_app import user_bp
from bp.hardware_app import hardware_bp
from cache import redis
from mqtt import connect_mqtt
from config import config

app = Flask(__name__)
app.register_blueprint(exception)
app.register_blueprint(user_bp)
app.register_blueprint(hardware_bp)

log = Logger()
cors = CORS(app, resources={r"/*": {"origins": "*"}})


@app.route('/')
def hello_world():
    return response_success('success', int(round(time() * 1000)))


if __name__ == '__main__':
    log.init_app(app, {
        'LOG_PATH': '../log',
        'LOG_NAME': 'run.log'
    })
    app.config['REDIS_URL'] = config['redis']['url']
    connect_mqtt()
    redis.init_app(app)
    app.run(host=config['app']['host'], port=config['app']['port'], debug=False)
