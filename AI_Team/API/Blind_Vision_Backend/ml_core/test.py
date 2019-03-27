import numpy as np
import time
import cv2
import os
import ml_core as yoloModel 
from ml_core import color

#############################_main_####################################

labels, colors = yoloModel.load_label("coco.names")

net, ln = yoloModel.load_model()

image = yoloModel.load_image("dog-and-cat.png")

idxs, boxes, confiences, centers, classIDs = yoloModel.detectObjectFromImage(image, net, ln)

t = yoloModel.bouding_box(idxs, image, boxes, colors, labels, classIDs, confiences)

print(t)


    
  






