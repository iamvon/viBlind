import numpy as np
import time
import cv2
import os

# load the COCO class labels our YOLO model was trained on
LABELS = open("coco.names").read().strip().split("\n")

# initialize a list of colors to represent each possible class label
np.random.seed(42)
COLORS = np.random.randint(0, 255, size=(len(LABELS), 3),
	dtype="uint8")

# load our YOLO object detector trained on COCO dataset (80 classes)
# and determine only the *output* layer names that we need from YOLO
print("[INFO] loading YOLO from disk...")
net = cv2.dnn.readNetFromDarknet("yolov3.cfg", "yolov3.weights")
ln = net.getLayerNames()
ln = [ln[i[0] - 1] for i in net.getUnconnectedOutLayers()]
image = cv2.imread('images.jpg')
(H, W) = image.shape[:2]
print(H)
# construct a blob from the input image and then perform a forward
# pass of the YOLO object detector, giving us our bounding boxes and
# associated probabilities
blob = cv2.dnn.blobFromImage(image, 1/255.0, (416, 416), swapRB = True, crop=False)
net.setInput(blob)
layerOutputs = net.forward(ln)
# initialize our lists of detected bounding boxes, confidences, and
# class IDs, respectively
boxes = []
confidences = []
classIDs = []
centers = []

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
texts = []
if len(idxs) > 0:
    for i in idxs.flatten():
        centerX, centerY = centers[i][0], centers[i][1]
        if centerX <= W/3:
            W_pos = "left"
        elif centerX <= (W/3*2):
            W_pos = "center"
        else :
            W_pos = "right"
        
        if centerY <= H/3:
            H_pos = 'top'
        elif centerY <= (H/3*2):
            H_pos = "mid"
        else: 
            H_pos = "bottom"
        texts.append(LABELS[classIDs[i]])
print(texts)



