from flask_apscheduler import APScheduler
from flask_loguru import logger
import board
import adafruit_dht
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import json
import paho.mqtt.client as mqtt

scheduler = APScheduler()

reader = SimpleMFRC522()
dht_device = adafruit_dht.DHT11(board.D4)

fire_pin = 19
solid_pin = 16
illumination_pin = 17
GPIO.setup(fire_pin, GPIO.IN)
GPIO.setup(solid_pin, GPIO.IN)
GPIO.setup(illumination_pin, GPIO.IN)

r_pin = 13
g_pin = 6
b_pin = 9
GPIO.setup(r_pin, GPIO.OUT)
GPIO.setup(g_pin, GPIO.OUT)
GPIO.setup(b_pin, GPIO.OUT)

pwm_r = GPIO.PWM(r_pin, 70)
pwm_g = GPIO.PWM(g_pin, 70)
pwm_b = GPIO.PWM(b_pin, 70)

pwm_r.start(0)
pwm_g.start(100)
pwm_b.start(100)

data = {
    'temperature': '0',
    'humidity': '0',
    'fire': True,
    'illumination': True,
    'solid': True
}
fire_regular = True
solid_regular = True
illumination_regular = True
is_init = False

sensor_data_topic = 'sensor_data'
mqtt_client: mqtt.Client = None

broker_url = '39.105.110.28'
port = 8083
user = 'emqx'
pwd = 'public'
transport = 'websockets'


def connect_mqtt():
    global mqtt_client

    def handle_mqtt_connect(client, userdata, flags, rc):
        if rc == 0:
            logger.info('Connected to mqtt broker!')
        else:
            logger.info('Failed to connect to mqtt broker!')

    mqtt_client = mqtt.Client(data['uuid'], transport='websockets')
    mqtt_client.username_pw_set(user, pwd)
    mqtt_client.on_connect = handle_mqtt_connect
    mqtt_client.connect(broker_url, port)
    mqtt_client.loop_start()


# interval examples
@scheduler.task('interval', id='alive_task', seconds=20, misfire_grace_time=15)
def alive_task():
    logger.info('still alive!')


@scheduler.task('interval', id='temperature_task', seconds=30, misfire_grace_time=25)
def temperature_task():
    logger.info('start temperature collect!')
    try:
        # Print the values to the serial port
        temperature_c = dht_device.temperature
        temperature_f = temperature_c * (9 / 5) + 32
        humidity = dht_device.humidity
        logger.info(
            "Temp: {:.1f} F / {:.1f} C    Humidity: {}% ".format(
                temperature_f, temperature_c, humidity
            )
        )
        data['temperature'] = "{:.1f}".format(temperature_c)
        data['humidity'] = "{}".format(humidity)
    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        logger.error(error.args[0])
    except Exception as error:
        dht_device.exit()
        logger.error(error)


@scheduler.task('interval', id='fire_task', seconds=7, misfire_grace_time=1)
def fire_task():
    global fire_regular
    logger.info('start fire check!')
    fire_regular = True
    if GPIO.input(fire_pin) == 0:
        logger.info(f'fire!fire!fire!')
        fire_regular = False
    data['fire'] = not fire_regular


@scheduler.task('interval', id='solid_task', minutes=1, misfire_grace_time=1)
def solid_task():
    global solid_regular
    logger.info('start solid check!')
    solid_regular = True
    if GPIO.input(solid_pin) == 1:
        logger.info(f'需要进行灌溉！')
        solid_regular = False
    data['solid'] = not solid_regular


@scheduler.task('interval', id='illumination_task', seconds=10, misfire_grace_time=5)
def illumination_task():
    global illumination_regular
    logger.info('start illumination check')
    illumination_regular = True
    if GPIO.input(illumination_pin) == 1:
        logger.info('需要光照！')
        illumination_regular = False
    data['illumination'] = not illumination_regular


@scheduler.task('interval', id='regular_task', seconds=3, misfire_grace_time=1)
def regular_task():
    global is_init
    if fire_regular and solid_regular and illumination_regular:
        if not is_init:
            # change to green
            pwm_r.ChangeDutyCycle(0)
            pwm_g.ChangeDutyCycle(100)
            pwm_b.ChangeDutyCycle(100)
    else:
        pwm_r.ChangeDutyCycle(100)
        pwm_g.ChangeDutyCycle(0)
        pwm_b.ChangeDutyCycle(100)
        is_init = False

    logger.info(f"{fire_regular}/{solid_regular}/{illumination_regular}")


@scheduler.task('interval', id='upload_task', minutes=1, misfire_grace_time=30)
def upload_task():
    logger.info('start upload sensor data!')
    mqtt_client.publish(sensor_data_topic, json.dumps(data))
