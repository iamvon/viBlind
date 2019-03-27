from flask import Flask, request, Response, send_file
# from server import db_helper
import ml_core.yoloModel as yoloModel
import jsonpickle
import numpy as np
import cv2
import os   
import base64
import json
import ast
import time

app = Flask(__name__)

baseURL = 'http://52.163.230.167:5000'
image_to_text_API = '/v1/api/predict'
bounding_box_API = '/v1/resoures/predict_images/'

# Load YOLO model
labels, colors = yoloModel.load_label("coco.names")
net, ln = yoloModel.load_model()

# route http posts to this method
@app.route(image_to_text_API, methods=['GET', 'POST'])
def predict():
    start = time.time()
    # db = db_helper.Database()
    loaded_body = parse_json_from_request(request)
    
    # Convert base64 image back to binary
    img_original = base64.b64decode(loaded_body['image'])

    # convert string of image data to uint8
    jpg_as_np = np.frombuffer(img_original, dtype=np.uint8)
    # decode image
    image = cv2.imdecode(jpg_as_np, cv2.IMREAD_COLOR)

    idxs, boxes, confiences, centers, classIDs = yoloModel.detectObjectFromImage(image, net, ln)

    objectProperty = yoloModel.getObjectProperty(idxs, image, boxes, colors, labels, classIDs, confiences)

    # build a response dict to send back to client
    # response = {'text': '{}'.format(propertyObject['text']), 'confidence':'{}'.format(propertyObject['confidence']), 'x':'{}'.format(propertyObject['x']), 'y':'{}'.format(propertyObject['y']), 'width':'{}'.format(propertyObject['w']), 'height':'{}'.format(propertyObject['h']), 'color':'{}'.format(propertyObject['color'])}
    response = {
        'objectProperty':''
    }
    response['objectProperty'] = objectProperty
    print(response)
    # encode response using jsonpickle
    response_pickled = jsonpickle.encode(response)

    # # Update image database
    # if db.exist_image(loaded_body['name']):
    #     print("Exist")
    #     # # Update predicted image in database
    #     # db.update_predict_image(loaded_body['name'], bouding_image_as_string)
    #     # db = db_helper.Database()
    #     # db.get_predict_image(loaded_body['name'], W, H)   
    #     return Response(response=response_pickled, status=200, mimetype="application/json")
    # else:
    #     db = db_helper.Database()
    #     db.insert_user_image(loaded_body['name'], loaded_body['image'])
    #     # Update predicted image in database
    #     # db = db_helper.Database()
    #     # db.update_predict_image(loaded_body['name'], bouding_image_as_string)
    #     # db = db_helper.Database()
    #     # db.get_predict_image(loaded_body['name'], W, H)   
    end = time.time()
    print('Time:', end - start)
    return Response(response=response_pickled, status=200, mimetype="application/json")

@app.route(bounding_box_API+'<name>', methods=['GET'])
def get_image(name):
    filename = 'predict_images/output_resize_%s.jpg' % name
    print(filename)
    return send_file(filename, mimetype='image/gif')

@app.route('/test', methods=['GET'])
def test():
    response = {'test': 'say Hi!', 'hello': 'Hello guy'}
    response_pickled = jsonpickle.encode(response)
    return Response(response=response_pickled, status=200, mimetype="application/json")

def parse_json_from_request(request):
    body_dict = request.json
    body_str = json.dumps(body_dict)
    loaded_body = ast.literal_eval(body_str)
    return loaded_body

if __name__ == "__main__":
    # start flask app
    app.run()


