from picamera import PiCamera
from time import sleep
import os
import cv2
import numpy as np
from google.cloud import vision



os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = '/home/pi/thematic-envoy-319518-95fe136b7595.json'

image_filename = '/home/pi/Desktop/image_mycamfun.jpg'

camera = PiCamera()

#sleep(2) # to let the camera adjust to ambient light
camera.capture(image_filename)

with open(image_filename, 'rb') as image_file:
    image_content = image_file.read()

client = vision.ImageAnnotatorClient()

my_image = vision.Image(content=image_content)

response = client.face_detection(image=my_image)

print(response)
#faces_response = client.face_detection(image=my_image)


    
image = cv2.imread(image_filename)

cv2.imwrite('imagefx_pre.jpg',cv2.bitwise_not(image))

for face in response.face_annotations:
    if face.joy_likelihood.name == "VERY_LIKELY" or face.joy_likelihood.name == "LIKELY" :
        print("joy: "+face.joy_likelihood.name)
        cv2.imwrite('imagefx_joy.jpg',cv2.cvtColor(image,cv2.COLOR_BGR2GRAY))
    elif face.sorrow_likelihood.name == "VERY_LIKELY" or face.sorrow_likelihood.name == "LIKELY":
        print("sorrow: "+face.sorrow_likelihood.name)
        color1,color2 = cv2.pencilSketch(image,sigma_s=60, sigma_r=0.07, shade_factor=0.1)
        cv2.imwrite('imagefx_sorrow.jpg',color1)
    elif face.anger_likelihood.name == "VERY_LIKELY" or face.anger_likelihood.name == "LIKELY" :
        print("anger: "+face.anger_likelihood.name)
        cv2.imwrite('imagefx_anger.jpg',cv2.bitwise_not(image))
    elif face.surprise_likelihood.name == "VERY_LIKELY" or face.surprise_likelihood.name == "LIKELY":
        print("surprise: "+face.surprise_likelihood.name)
        cv2.imwrite('imagefx_surprise.jpg',cv2.adaptiveThreshold(cv2.medianBlur(cv2.cvtColor(image,cv2.COLOR_BGR2GRAY),7),255,cv2.ADAPTIVE_THRESH_MEAN_C,cv2.THRESH_BINARY,7,7))      
    else:
        print("pokerface")
        cv2.putText(image, "POKERFACE",(59,109),cv2.FONT_HERSHEY_SIMPLEX,4,(255,255,255),4,cv2.LINE_AA)
        cv2.imwrite('imagefx.jpg',image)

                       
