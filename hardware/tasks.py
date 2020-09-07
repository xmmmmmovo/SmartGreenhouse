from flask_apscheduler import APScheduler
from flask_loguru import logger
import board
import adafruit_dht
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522

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

data = {}
fire_regular = True
solid_regular = True
illumination_regular = True
is_init = False


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
    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        logger.error(error.args[0])
    except Exception as error:
        dht_device.exit()
        logger.error(error)


@scheduler.task('interval', id='fire_task', seconds=7, misfire_grace_time=1)
def fire_task():
    global fire_regular
    fire_regular = True
    logger.info('start fire check!')
    if GPIO.input(fire_pin) == 0:
        logger.info(f'fire!fire!fire!')
        fire_regular = False


@scheduler.task('interval', id='solid_task', minutes=10, misfire_grace_time=1)
def solid_task():
    global solid_regular
    solid_regular = True
    logger.info('start solid check!')
    if GPIO.input(solid_pin) == 1:
        logger.info(f'需要进行灌溉！')
        solid_regular = False


@scheduler.task('interval', id='illumination_task', seconds=10, misfire_grace_time=5)
def illumination_task():
    global illumination_regular
    illumination_regular = True
    logger.info('start illumination check')
    is_regular = False
    if GPIO.input(illumination_pin) == 1:
        logger.info('需要光照！')
        illumination_regular = False


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
