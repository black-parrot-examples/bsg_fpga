import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

GPIO.setup(18, GPIO.OUT)
GPIO.output(18, False)
print("Button Pressed")
time.sleep(0.4)

GPIO.setup(18, GPIO.IN)
print("Button Released")