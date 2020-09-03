from flask import Flask
import RPi.GPIO as GPIO
from config import Config
from tasks import scheduler
from flask_loguru import Logger
from flask_loguru import logger

app = Flask(__name__)
log = Logger()


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    log.init_app(app, {
        'LOG_PATH': './log',
        'LOG_NAME': 'run.log'
    })
    logger.info(f'''
------------------智能大棚启动！------------------
PI VERSION: {GPIO.RPI_REVISION}
GPIO VERSION: {GPIO.VERSION}
------------------初始化！------------------
    ''')
    app.config.from_object(Config())
    scheduler.init_app(app)
    scheduler.start()
    logger.info(f'''
------------------初始化完成！------------------
tasks state:{scheduler.state}
hostname: {scheduler.host_name}
------------------启动服务器！------------------
        ''')
    app.run(host='0.0.0.0', port=9000, debug=False)
