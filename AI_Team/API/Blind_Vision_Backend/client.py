import requests
import json
import cv2
import base64

addr = 'http://52.163.230.167:5000'
test_url = addr + '/v1/api/predict'

# prepare headers for http request
content_type = 'application/json'
headers = {'content-type': content_type}
# Laptop. ca1, 
folderName = 'user_images/'
fileName = 'yellow-car.jpg'
img = cv2.imread(folderName+fileName)
# encode image as jpeg
_, img_buffer = cv2.imencode('.jpg', img)

img_as_string = base64.b64encode(img_buffer)

# send http request with image and receive response
payload = {
    "image" : (img_as_string).decode("utf-8"),  # Convert bytes to string
    "name" : fileName
}

payload = json.dumps(payload)
loaded_payload = json.loads(payload)
# print(loaded_payload['name'])

response = requests.post(test_url,'',json=loaded_payload)
# decode response
print (response.json())

# expected output: {}
