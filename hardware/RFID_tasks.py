import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import time
import threading
from loguru import logger

reader = SimpleMFRC522()


class RFIDThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)

    def run(self):
        logger.info('Starting RFID thread')
        RFID_tasks()


def RFID_tasks():
    while True:
        try:
            id, text = reader.read()
            print(id)
            print(text)
        finally:
            GPIO.cleanup()
        time.sleep(5)


if __name__ == '__main__':
    RFID_tasks()
