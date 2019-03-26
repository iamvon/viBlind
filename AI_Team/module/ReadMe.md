DETECT OBJECT WITH THEIR COLOR
==============================

## INSTALLATION
Please see the appropriate for your enviroment of choice:
  * Window 10
  * Python 3.6.3
  * Opencv 3.4.2
  * Download
    * yolov3.cfg
    * yolov3.weights
    * coco.names
    
---

## MODULE
  * yoloModel.py
    * loadl_label
    * load_image
    * load_model
    * detectObjectFromImage
      - Input : Your Image
      - Output : return  Number of Objects, Confidence of Object, coordinate of Object,  ClassID of Object, Centers of bounding box
    * print_text
      - Input: Number of Objects, Labels, ClassID of Object
      - Ouput: name of Objects
    * bounding_box
      - Input: Number of Objects, Confidence of Object, coordinate of Object,  ClassID of Object, Labels, colors
      - Output: bouding box in Image and name of Objects with their color
      
  * color.py
    * get_color
      - Input: Your image
      - Output: color of image   
---

## IMPLEMENT

```
labels, colors = yoloModel.load_label("coco.names")

net, ln = yoloModel.load_model()

image = yoloModel.load_image("tie.jpg")

idxs, boxes, confiences, centers, classIDs = yoloModel.detectObjectFromImage(image, net, ln)

img, text = yoloModel.bouding_box(idxs, image, boxes, colors, labels, classIDs, confiences)

print(text)
```
