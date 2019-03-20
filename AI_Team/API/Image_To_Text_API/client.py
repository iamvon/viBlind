import requests
import json
import cv2
import base64

addr = 'http://localhost:5000'
test_url = addr + '/v1/api/predict'

# prepare headers for http request
content_type = 'image/jpeg'
headers = {'content-type': content_type}
# Laptop. ca1, 
fileName = 'ca1.jpg'
img = cv2.imread(fileName)
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

response = requests.post(test_url, data=payload.encode("utf-8"), headers=headers)
# decode response
print (response.json())

# expected output: {}
