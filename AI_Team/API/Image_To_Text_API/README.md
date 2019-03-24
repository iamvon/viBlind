# Backend Documentation

Base URL: http://52.163.230.167:5000
## Start Server
```bash
cd ~
cd Image_To_Text_API/
source venv/bin/activate
cd api/
export FLASK_APP=server.py 
flask run --host=0.0.0.0
```

## References

| HTTP Method |            Resource URL            |                                Notes                               |  Data Type |
|:-----------:|:----------------------------------:|:------------------------------------------------------------------:|:----------:|
|  POST, GET  |           /v1/api/predict          | Send an image want to recognize, return objects recognition texts  |    JSON    |
|     GET     | /v1/resoures/predict_images/<__name__> |            Return an recognized image with bounding box            | image/jpeg |

### Examples
Assume we have an ```dog-and-cat.png``` in local.

__1.__ _/v1/api/predict_ (POST, GET)

__Request:__ 
```js
Header = {
    "content-type": "application/json"
}

Body = {
    "image" : "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQEBAQIBAQECAg..."   // Encode image as base64 
    "name" :  "dog-and-cat.png"
}
```
__Response:__

```js
{
    "predict": "['dog', 'cat']",
    "imageSize": "2200x760",
    "bounding: "http://52.163.230.167:5000/v1/resoures/predict_images/dog-and-cat" 
}
```

__2.__ _/v1/resoures/predict_images/<__name__>_ (GET)

GET: http://52.163.230.167:5000/v1/resoures/predict_images/dog-and-cat

And you will recieve an recognized image with bounding box.
