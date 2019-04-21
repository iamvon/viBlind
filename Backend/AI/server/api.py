import os
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
print(ROOT_DIR)
######
from flask import Flask, request, Response, send_file
import sys
sys.path.insert(0,"/home/tung/bang/Blind_Vision_Backend/")
import ml_core.drqa.reader.predictor as predictor
import ml_core.object_detection.yoloModel as yoloModel
import jsonpickle
import numpy as np
import cv2
import base64
import json
import ast
from gensim.summarization.summarizer import summarize
import requests
app = Flask(__name__)

baseURL = 'http://52.163.230.167:5000'
#baseURL = 'localhost:5000'
image_to_text_API = '/v1/api/predict'
bounding_box_API = '/v1/resoures/predict_images/'
summarizing_API =  '/v1/api/summarize'
question_answering_API = '/v1/api/answer_question'
return_article = 'http://52.163.230.167:8080/v1/api/article/content'

# Load YOLO model
labels, colors = yoloModel.load_label("coco.names")
net, ln = yoloModel.load_model()

# route http posts to this method
@app.route(image_to_text_API, methods=['GET', 'POST'])
def predict():
    # db = db_helper.Database()
    loaded_body = parse_json_from_request(request)
    
    # Convert base64 image back to binary
    img_original = base64.b64decode(loaded_body['image'])

    # convert string of image data to uint8
    jpg_as_np = np.frombuffer(img_original, dtype=np.uint8)
    # decode image
    image = cv2.imdecode(jpg_as_np, cv2.IMREAD_COLOR)

    idxs, boxes, confiences, centers, classIDs = yoloModel.detectObjectFromImage(image, net, ln)

    objectProperty = yoloModel.bouding_box(idxs, image, boxes, colors, labels, classIDs, confiences)

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

@app.route(summarizing_API, methods=['GET', 'POST'])
def summarizing():
    loaded_body = parse_json_from_request(request)
    article = loaded_body['articleContent']
    print(article)
    print("___________")
    summarized_response = summarize(article)
    response = {'summarized_article':summarized_response, 'status': '200'}
    response_pickled = jsonpickle.encode(response)
    print(response_pickled)
    print("___________")
    return Response(response=response_pickled, status=200, mimetype="application/json")

@app.route(question_answering_API, methods=['GET','POST'])
def answer_question():
    #get question and hash_url
    loaded_body = parse_json_from_request(request)
    question = loaded_body['question']
    hash_url = loaded_body['hash_url']
    print(question)
    print(hash_url)
    
    #get article
    get_response = requests.get(return_article + "?hash_url=" + hash_url)
    res = get_response.json()
    article = res['articleContent']
    #predict and return
    #predict
    token = "spacy"
    predictions = predictor.Predictor(model=None, tokenizer=token, normalize=True, embedding_file=None, num_workers=None)
    answer = predictions.predict(document=article, question=question, candidates=None, top_n=3)
    #return
    response = {
        'answers':
        [
            {
                'result':'',
                'score':''
            }, 
            {
                'result':'',
                'score':''
            }, 
            {
                'result':'',
                 'score':''
             }
        ], 
        'status': '200'
    }
    response['answers'][0]['result'] = answer[0][0]
    response['answers'][0]['score'] = answer[0][1]
    response['answers'][1]['result'] = answer[1][0]
    response['answers'][1]['score'] = answer[1][1]
    response['answers'][2]['result'] = answer[2][0]
    response['answers'][2]['score'] = answer[2][1]
    
    response_pickled = jsonpickle.encode(response)
    print(response_pickled)
    print(Response(response=response_pickled, status=200, mimetype="application/json"))
    print("________")
    return Response(response=response_pickled, status=200, mimetype="application/json")

def parse_json_from_request(request):
    body_dict = request.json
    body_str = json.dumps(body_dict)
    loaded_body = ast.literal_eval(body_str)
    return loaded_body

if __name__ == "__main__":
    # start flask app
    app.run()
