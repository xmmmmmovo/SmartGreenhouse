import RPi.GPIO as GPIO
import time

if __name__ == '__main__':
    GPIO.setmode(GPIO.BOARD)
    buzz_pin = 13
    GPIO.setup(buzz_pin, GPIO.OUT)
    GPIO.output(buzz_pin, GPIO.LOW)
    time.sleep(3)
    GPIO.output(buzz_pin, GPIO.HIGH)
    GPIO.cleanup()
    pass
