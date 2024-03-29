from flask import Flask

from bp.rfid_app import rfid_bp
from bp.sensor_app import sensor_bp
from response import response_success
from time import time
from flask_loguru import Logger
from flask_cors import CORS
from exception import exception
from bp.user_app import user_bp
from bp.hardware_app import hardware_bp
from cache import redis
from config import config
from utils.pwd_utils import bcrypt
from utils.jwt_utils import jwt_manager, JWT_ACCESS_TOKEN_EXPIRES
from datetime import timedelta

app = Flask(__name__)
app.register_blueprint(exception)
app.register_blueprint(user_bp)
app.register_blueprint(hardware_bp)
app.register_blueprint(sensor_bp)
app.register_blueprint(rfid_bp)

app.config['REDIS_URL'] = config['redis']['url']
app.config['JWT_SECRET_KEY'] = config['app']['jwt_secret_key']
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = JWT_ACCESS_TOKEN_EXPIRES

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
    redis.init_app(app)
    jwt_manager.init_app(app)
    bcrypt.init_app(app)
    app.run(host=config['app']['host'], port=config['app']['port'], debug=False)
