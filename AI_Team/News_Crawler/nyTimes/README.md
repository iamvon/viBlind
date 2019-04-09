# Backend Documentation

Base URL: http://52.163.230.167:8080
## Start Crawler Service
```bash
cd ~
cd golang/src/nyTimes
./runCrawler.sh
```
## Start API Service
```bash
cd ~
cd golang/src/nyTimes
./run.sh
```

## API References

| HTTP Method |            Resource URL            |                                Notes                               |  Data Type |
|:-----------:|:----------------------------------:|:------------------------------------------------------------------:|:----------:|
|     GET     |           /v1/api/article          | Return a list categories of article |    JSON    |
|     GET     |    /v1/api/article/africa-topic    |      Return a list article topic of Africa category   | JSON |
|     GET     |    /v1/api/article/africa?topic=<__topic__>    |      Return a list articles of Africa category with correspondind topic  | JSON |
|     GET     |    /v1/api/article/americas-topic    |      Return a list article topic of Americas category   | JSON |
|     GET     |    /v1/api/article/americas?topic=<__topic__>    |      Return a list articles of Americas category with correspondind topic  | JSON |
|     GET     |    /v1/api/article/asia-pacific-topic    |      Return a list article topic of Asia Pacific category   | JSON |
|     GET     |    /v1/api/article/asia-pacific?topic=<__topic__>    |      Return a list articles of Asia Pacific category with correspondind topic  | JSON |
|     GET     |    /v1/api/article/europe-topic    |      Return a list article topic of Europe category   | JSON |
|     GET     |    /v1/api/article/europe?topic=<__topic__>    |      Return a list articles of Europe category with correspondind topic  | JSON |
|     GET     |    /v1/api/article/middle-east-topic    |      Return a list article topic of Middle East category   | JSON |
|     GET     |    /v1/api/article/middle-east?topic=<__topic__>    |      Return a list articles of Middle East category with correspondind topic  | JSON |

### Examples
