# Backend Documentation

Base URL: http://52.163.230.167:5000
## Start Server
### 1. With Docker 
```bash
cd ~
cd Vision_For_Blind/Backend/AI/
docker-compose up
```
### 2. Without Docker
```bash
cd ~
cd Vision_For_Blind/Backend/AI/
virtualenv -p python3 venv
source venv/bin/activate
pip3 install -r requirements.txt
sudo chmod +x run.sh
./run.sh
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
  "objectProperty": [{
    "text": "dog",
    "confidence": 0.8863365650177002,
    //"color": "red",
    "x": 840,        // (x, y) is the coordinates of the upper-left corner of the bounding box
    "y": 75,
    "width": 1236,   //  (width, height) is the bouding box size
    "height": 615
  }, {
    "text": "cat",
    "confidence": 0.8379455804824829,
    //"color": "red",
    "x": 47,        // (x, y) is the coordinates of the upper-left corner of the bounding box
    "y": 54,
    "width": 1004,  //  (width, height) is the bouding box size
    "height": 650 
  }]
}
```

__2.__ _/v1/resoures/predict_images/<__name__>_ (GET)

GET: http://52.163.230.167:5000/v1/resoures/predict_images/dog-and-cat

And you will recieve an recognized image with bounding box.

__3.__ _/v1/api/summarize_ (POST, GET)

__Request:__ 
```js
Header = {
    "content-type": "application/json"
}

Body = {
    "articleContent": "Air pollution is one of the most dangerous forms of pollution..."
}
```
__Response:__

```js
{
    'summarized_article': ""    // article's content which has been summarized
}
```

__4.__ _/v1/api/answer_question_ (POST, GET)

__Request:__ 
```js
Header = {
    "content-type": "application/json"
}

Body = {
    "question": "What did the sailor do?",
    "hash_url": "C5B5300ECED62665ACC6CA32A0BEB39AE942B861"
}
```
__Response:__

```js
{
    'answers':
        [
            {
                'result':'',    // result with highest capacity
                'score':''      // score of the result
            }, 
            {
                'result':'',    // second
                'score':''
            }, 
            {
                'result':'',    // third
                 'score':''
             }
        ]
}
```
