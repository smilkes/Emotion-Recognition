from picamera import PiCamera
from time import sleep
import os
import cv2
import drawSvg
import numpy as np
from google.cloud import vision



os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = '/home/pi/thematic-envoy-319518-95fe136b7595.json'

image_filename = '/home/pi/Desktop/image_GoogleVision.jpg'

camera = PiCamera()

sleep(2) # to let the camera adjust to ambient light
camera.capture(image_filename)

with open(image_filename, 'rb') as image_file:
    image_content = image_file.read()

client = vision.ImageAnnotatorClient()

my_image = vision.Image(content=image_content)

response = client.face_detection(image=my_image)

print(response)
