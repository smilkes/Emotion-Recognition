import time
from PIL import Image
import numpy as np
import face_recognition
import tensorflow as tf
#pip3 install keyboard
import keyboard
import cv2
from picamera import PiCamera
#function to capture image
count = 0
image_filename = "/home/pi/Desktop/temp_image.jpg"
model = tf.keras.models.load_model("/home/pi/model_v6_23.hdf5")
camera = PiCamera()

emotion_dict= {'Angry': 0, 'Sad': 5, 'Neutral': 4, 'Disgust': 1, 'Surprise': 6, 'Fear': 2, 'Happy': 3}



start = time.time()

fourcc = cv2.VideoWriter_fourcc(*'mp4v') 
video = cv2.VideoWriter('video.avi', fourcc, 1, (900, 550))

# while True:
#     if keyboard.is_pressed("p"):

for i in range (5):
                
        count = count + 1
        
        camera.capture(image_filename)
        image = cv2.imread(image_filename)
        face_locations = face_recognition.face_locations(image)

        top, right, bottom, left = face_locations[0]
        image_cropped= image[top:bottom, left:right]
        image_cropped= cv2.resize(image_cropped, (48,48))
        image_cropped= cv2.cvtColor(image_cropped, cv2.COLOR_BGR2GRAY)
        image_cropped= np.reshape(image_cropped, [1, image_cropped.shape[0], image_cropped.shape[1],1])
        model.predict(image_cropped)
        
        predicted_class = np.argmax(model.predict(image_cropped))
        
        label_map = dict((v,k) for k,v in emotion_dict.items())
        predicted_label = label_map[predicted_class]
        predicted_label_text = str(predicted_label)
        print(predicted_label)
        cv2.putText(image, predicted_label_text, (50,100), cv2.FONT_HERSHEY_SIMPLEX,4,(255,255,255),4,cv2.LINE_AA)
        im_name = str(count)+predicted_label_text+".jpg"
        cv2.imwrite(im_name,image)
        print('loop')
        video.write(image)

cv2.destroyAllWindows()
video.release()     

end = time.time()


print(f"The runtime of this script is {end-start}")