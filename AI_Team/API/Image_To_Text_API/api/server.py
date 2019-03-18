from flask import Flask, request, Response, send_file
import jsonpickle
import numpy as np
import cv2
import os
import pymysql
import base64
import json
import ast
import time

app = Flask(__name__)


class Database:
    def __init__(self):
        host = 'localhost'
        user = 'root'
        password = 'anhtrang'
        db = 'AI_For_Blind'
        charset = 'utf8'

        self.connection = pymysql.connect(host=host, user=user, password=password, db=db, charset=charset, cursorclass=pymysql.cursors.
                                          DictCursor)

    def insert_user_image(self, name, user_image):
        with self.connection.cursor() as cursor1:
            query = "INSERT INTO `image_to_text` (`name`, `user_image`) VALUES (%s, %s)"
            cursor1.execute(query, (name, user_image))
        self.connection.commit()
        cursor1.close()
        self.connection.close()

    def update_predict_image(self, name, predict_image):
        with self.connection.cursor() as cursor2:
            query = "UPDATE `image_to_text` SET `predict_image`=%s WHERE `name`=%s"
            cursor2.execute(query, (predict_image, name))
        self.connection.commit()
        cursor2.close()
        self.connection.close()
    
    def exist_image(self, name):
        with self.connection.cursor() as cursor3:
            query = "SELECT DISTINCT `name` from `image_to_text` WHERE `name`=%s"
            res = cursor3.execute(query, name)  
            if res == 1:
                return True
            else:
                return False 
        cursor3.close()        
        self.connection.close()  

    def get_predict_image(self, name, width, height):
        with self.connection.cursor() as cursor4:
            query = "SELECT DISTINCT `predict_image` from `image_to_text` WHERE `name`=%s"
            cursor4.execute(query, name)
            img_dict = cursor4.fetchone()
            img_base64 = img_dict['predict_image']
            
            img_original = base64.b64decode(img_base64)
            # Write to a file
            print(type(name))
            fileNameBounding = 'bounding_images/output_'+ name[:-4] +'.jpg'
            with open(fileNameBounding, 'wb') as f_output:
                f_output.write(img_original)

            test_img = cv2.imread(fileNameBounding, 1)
            test_resize_img = cv2.resize(test_img,(int(width),int(height)))
            fileNameResize = 'predict_images/output_resize_'+ name[:-4]+ '.jpg' 
            cv2.imwrite(fileNameResize, test_resize_img)
        cursor4.close()            
        self.connection.close()

# initialize our lists of detected bounding boxes, confidences, and
# class IDs, respectively
boxes = []
confidences = []
classIDs = []
centers = []

# load the COCO class labels our YOLO model was trained on
labels = open("coco.names").read().strip().split("\n")

# initialize a list of colors to represent each possible class label
np.random.seed(42)
colors = np.random.randint(0, 255, size=(len(labels), 3),
                           dtype="uint8")

# load our YOLO object detector trained on COCO dataset (80 classes)
# and determine only the *output* layer names that we need from YOLO
print("[INFO] loading YOLO from disk...")
net = cv2.dnn.readNetFromDarknet("yolov3.cfg", "yolov3.weights")
ln = net.getLayerNames()
ln = [ln[i[0] - 1] for i in net.getUnconnectedOutLayers()]

# route http posts to this method
@app.route('/v1/api/predict', methods=['GET', 'POST'])
def predict():
    db = Database()
    
    r = request
    
    loaded_body = parse_json_from_request(r)
    # Convert base64 image back to binary
    img_original = base64.b64decode(loaded_body['image'])
    print(loaded_body['name'])

    # convert string of image data to uint8
    jpg_as_np = np.frombuffer(img_original, dtype=np.uint8)
    # decode image
    image = cv2.imdecode(jpg_as_np, cv2.IMREAD_COLOR)

    (H, W) = image.shape[:2]
    # construct a blob from the input image and then perform a forward
    # pass of the YOLO object detector, giving us our bounding boxes and
    # associated probabilities
    blob = cv2.dnn.blobFromImage(
        image, 1/255.0, (416, 416), swapRB=True, crop=False)
    net.setInput(blob)
    layerOutputs = net.forward(ln)

    for output in layerOutputs:
        for detection in output:
            scores = detection[5:]
            classID = np.argmax(scores)
            confidence = scores[classID]
            if confidence > 0.5:
                box = detection[0:4]*np.array([W, H, W, H])
                (centerX, centerY, width, height) = box.astype('int')

                x = int(centerX - width/2)
                y = int(centerY - height/2)
                boxes.append([x, y, int(width), int(height)])
                confidences.append(float(confidence))
                classIDs.append(classID)
                centers.append((centerX, centerY))

    idxs = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.3)

    texts = print_text(idxs, classIDs, labels)

    bouding_image = bouding_box(idxs, image, boxes, colors)
    _, bouding_image = cv2.imencode('.jpg', bouding_image)
    bouding_image_as_string = base64.b64encode(bouding_image)

    # build a response dict to send back to client
    response = {'imageSize': '{}x{}'.format(image.shape[1], image.shape[0]), 'predict': '{}'.format(texts)}

    # encode response using jsonpickle
    response_pickled = jsonpickle.encode(response)

    # TODO
    # Update image database
    if db.exist_image(loaded_body['name']):
        print("Exist")
        # Update predicted image in database
        db.update_predict_image(loaded_body['name'], bouding_image_as_string)
        db = Database()
        db.get_predict_image(loaded_body['name'], W, H)   
        return Response(response=response_pickled, status=200, mimetype="application/json")
    else:
        db = Database()
        db.insert_user_image(loaded_body['name'], loaded_body['image'])
        # Update predicted image in database
        db = Database()
        db.update_predict_image(loaded_body['name'], bouding_image_as_string)
        db = Database()
        db.get_predict_image(loaded_body['name'], W, H)   

    return Response(response=response_pickled, status=200, mimetype="application/json")

# TODO
@app.route('/v1/resoures/predict_images/<name>', methods=['GET'])
def get_image(name):
    filename = 'predict_images/output_resize_%s.jpg' % name
    print(filename)
    return send_file(filename, mimetype='image/gif')

def parse_json_from_request(request):
    # Convert bytes to string 
    body = request.data.decode("utf-8")
    # Convert string to dict 
    body_dict = ast.literal_eval(body)

    # Convert dict to json
    body_json = json.dumps(body_dict)
    loaded_body_json = json.loads(body_json)
    return loaded_body_json

def print_text(idxs, classids, labels):
    texts = []
    if len(idxs) > 0:
        for i in idxs.flatten():
            texts.append(labels[classids[i]])
    return texts

def bouding_box(idxs, image, boxes, colors):
    H, W = image.shape[:2]
    if len(idxs) > 0:
            # loop over the indexes we are keeping
        for i in idxs.flatten():
            # extract the bounding box coordinates
            (x, y) = (boxes[i][0], boxes[i][1])
            (w, h) = (boxes[i][2], boxes[i][3])

            # draw a bounding box rectangle and label on the image
            color = [int(c) for c in colors[classIDs[i]]]
            cv2.rectangle(image, (x, y), (x + w, y + h), color, 2)
            text = "{}: {:.4f}".format(labels[classIDs[i]], confidences[i])
            cv2.putText(image, text, (x, y - 5), cv2.FONT_HERSHEY_SIMPLEX,
                        0.5, color, 2)
    # return the output image as numpy array
    img = cv2.resize(image, (H, W))
    return img


if __name__ == "__main__":
    # start flask app
    app.run()