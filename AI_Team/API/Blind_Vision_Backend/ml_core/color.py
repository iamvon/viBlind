import cv2
import numpy as np



def get_color(image):
    if image is None:
        return "None"
    else:
        lower = {'red':(0, 30, 50), 'green':(40, 100, 100), 'blue':(97, 100, 117), 'yellow':(20, 100, 100), 'orange':(5, 50, 50), 'white':(0,0,0)} 
        upper = {'red':(10,255,255), 'green':(80,255,255), 'blue':(117,255,255), 'yellow':(30,255,255), 'orange':(15,255,255), 'white':(0,0,255)}


        # define standard colors for circle around the object
        colors = {'red':(0,0,255), 'green':(0,255,0), 'blue':(255,0,0), 'yellow':(0, 255, 217), 'orange':(0,140,255), 'white':(255,255,255)}

        im_resize = cv2.resize(image, (600, 600))
        blurred = cv2.GaussianBlur(im_resize, (11,11), 0)
        hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
        radiuss = []
        colorss = []
        for key, value in upper.items():
                # construct a mask for the color from dictionary`1, then perform
                # a series of dilations and erosions to remove any small
                # blobs left in the mask
                kernel = np.ones((9,9),np.uint8)
                mask = cv2.inRange(hsv, lower[key], upper[key])
                mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
                mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)
               
                # find contours in the mask and initialize the current
                # (x, y) center of the ball
                cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,
                    cv2.CHAIN_APPROX_SIMPLE)[-2]
                center = None
       
                # only proceed if at least one contour was found
                if len(cnts) > 0:
                    # find the largest contour in the mask, then use
                    # it to compute the minimum enclosing circle and
                    # centroid
                    c = max(cnts, key=cv2.contourArea)
                    ((x, y), radius) = cv2.minEnclosingCircle(c)
                    radiuss.append(int(radius))
                    colorss.append(key)
                    M = cv2.moments(c)
                    center = (int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"]))
       
                    # only proceed if the radius meets a minimum size. Correct this value for your obect's size
                    #if radius > 0.5:
                    #    # draw the circle and centroid on the frame,
                    #    # then update the list of tracked points
                    #    im = cv2.circle(im_resize, (int(x), int(y)), int(radius), colors[key], 2)
                    #    im = cv2.putText(im,key , (int(x-radius),int(y-radius)), cv2.FONT_HERSHEY_SIMPLEX, 0.4,colors[key],2)
        if (len(radiuss) == 0):
            return "None"
        return  colorss[radiuss.index(max(radiuss))]


#image = cv2.imread('car1.jpg')
#c = get_color(image)
#print( c)
#cv2.imshow('1', im)
#cv2.waitKey(0)
#cv2.destroyAllWindows()

