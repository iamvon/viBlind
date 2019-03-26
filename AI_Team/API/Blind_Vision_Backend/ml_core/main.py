import numpy as np
import time
import cv2
import os
import ml_core.yoloModel as yoloModel
import ml_core.color

#############################_main_####################################

labels, colors = yoloModel.load_label("coco.names")

net, ln = yoloModel.load_model()

image = yoloModel.load_image("tie.jpg")

idxs, boxes, confiences, centers, classIDs = yoloModel.detectObjectFromImage(image, net, ln)

img, text = yoloModel.bouding_box(idxs, image, boxes, colors, labels, classIDs, confiences)

print(text)



    
  






