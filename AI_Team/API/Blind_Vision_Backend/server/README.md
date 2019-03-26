# Backend Documentation

Base URL: http://52.163.230.167:5000
## Start Server
```bash
cd ~
cd Blind_Vision_Backend
source venv/bin/activate
cd server/
export FLASK_APP=api.py 
flask run --host=0.0.0.0
```

## API References

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
  'objectProperty': [{
    'color': 'red',
    'height': 615,
    'y': 75,
    'confidence': 0.8863365650177002,
    'width': 1236,
    'x': 840,
    'text': 'dog'
  }, {
    'color': 'red',
    'height': 650,
    'y': 54,
    'confidence': 0.8379455804824829,
    'width': 1004,
    'x': 47,
    'text': 'cat'
  }]
}
```

__2.__ _/v1/resoures/predict_images/<__name__>_ (GET)

GET: http://52.163.230.167:5000/v1/resoures/predict_images/dog-and-cat

And you will recieve an recognized image with bounding box.
