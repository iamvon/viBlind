import pymysql
import cv2
import base64

class Database:
    def __init__(self):
        host = 'localhost'
        user = 'tuanpmhd'
        password = 'anhtrang'
        db = 'Blind_Vision'
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
            fileNameBounding = 'bounding_images/output_'+ name[:-4] +'.jpg'
            with open(fileNameBounding, 'wb') as f_output:
                f_output.write(img_original)

            test_img = cv2.imread(fileNameBounding, 1)
            test_resize_img = cv2.resize(test_img,(int(width),int(height)))
            fileNameResize = 'predict_images/output_resize_'+ name[:-4]+ '.jpg' 
            cv2.imwrite(fileNameResize, test_resize_img)
        cursor4.close()            
        self.connection.close()