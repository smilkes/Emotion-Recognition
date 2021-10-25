from pynput import keyboard
from picamera import PiCamera

camera = PiCamera()
count = 0

def on_press(key):
    try:
        global count
        count += 1
        im_name = str(count)+ "image.jpg"
        camera.capture(im_name)
        print('alphanumeric key {0} pressed'.format(
            key.char))
    except AttributeError:
        print('special key {0} pressed'.format(
            key))

def on_release(key):
    print('{0} released'.format(
        key))
    if key == keyboard.Key.esc:
        # Stop listener
        return False

# Collect events until released
with keyboard.Listener(
        on_press=on_press,
        on_release=on_release) as listener:
    listener.join()
