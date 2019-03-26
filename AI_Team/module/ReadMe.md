DETECT OBJECT WITH THEIR COLOR
==============================

## INSTALLATION
Please see the appropriate for your enviroment of choice:
  * Window 10
  * Python 3.6.3
  * Opencv 3.4.2
  * Download
    * yolov3.cfg
    * yolov3.weight
    * coco.names
    
---

## MODULE
  * yoloModel.py
    * loadl_abel
    * load_image
    * load_model
    * detectObjectFromImage
    * print_text
    * bounding_box
  * color.py
    * get_color
    
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
