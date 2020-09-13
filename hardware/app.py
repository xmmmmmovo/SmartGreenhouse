from flask import Flask
import RPi.GPIO as GPIO
from config import Config
from tasks import scheduler
from flask_loguru import Logger
from flask_loguru import logger
import time
import os
import requests
from tasks import data, connect_mqtt
from base64 import encodebytes
from datetime import datetime

app = Flask(__name__)
log = Logger()


@app.route('/')
def hello_world():
    return int(round(time.time() * 1000))


def load_config():
    logger.info(f'开始读取配置信息')
    if os.path.exists('./uuid'):
        f = open('./uuid', 'r', encoding='utf-8')
        data['uuid'] = f.read().strip()
        logger.info('读取成功')
        f.close()
    else:
        logger.info('未找到，正在从云端获取')
        now = datetime.now()
        data['uuid'] = requests.post('http://192.168.137.1:9000/hardware/code',
                                     headers={'auth': encodebytes(f'{now.hour}/{now.minute}')}).json()['data']
        if data['uuid'] is None:
            logger.error('获取失败！请检查网络或验证数据！')
        else:
            f = open('./uuid', 'w', encoding='utf-8')
            f.write(data['uuid'])
            f.close()


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
    load_config()
    connect_mqtt()
    logger.info(f'''
------------------初始化完成！------------------
tasks state:{scheduler.state}
hostname: {scheduler.host_name}
------------------启动服务器！------------------
        ''')
    app.run(host='0.0.0.0', port=9000, debug=False)
