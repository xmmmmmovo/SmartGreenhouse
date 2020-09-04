from flask_apscheduler import APScheduler
from flask_loguru import logger
import board
import adafruit_dht
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522

reader = SimpleMFRC522()
scheduler = APScheduler()
dht_device = adafruit_dht.DHT11(board.D4)

fire_pin = 26
solid_pin = 16
GPIO.setup(fire_pin, GPIO.IN)
GPIO.setup(solid_pin, GPIO.IN)

data = {}


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
    logger.info('start fire check!')
    if GPIO.input(fire_pin) == 0:
        logger.info(f'fire!fire!fire!')


@scheduler.task('interval', id='solid_task', minutes=10, misfire_grace_time=1)
def solid_task():
    logger.info('start solid check!')
    if GPIO.input(solid_pin) == 1:
        logger.info(f'需要进行灌溉！')
