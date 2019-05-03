# Backend Release Documentation

## Prerequirements
__1.__ Install [phpMyAdmin](https://www.phpmyadmin.net/) and [MySQL](https://www.mysql.com/) 

__2.__ Install [Docker](https://docs.docker.com/install/)

__3.__ Clone this repository.

## Installing viBlind Backend
### Start AI service
Open your terminal at __viBlind__ repository you have cloned:
```bash
cd Backend/Releases/viBlind/AI
chmod +x run.sh
./run.sh
```
___NOTE:___ You can find __AI service__ documentation [here](https://github.com/iamvon/viBlind/blob/master/Backend/AI/README.md)

### Start News service
Open your terminal at __viBlind__ repository you have cloned:
```bash
cd Backend/Releases/viBlind/News/nyTimes  
chmod +x runAPI.sh
chmod +x runCrawler.sh
```
__1.__ Run __Crawler Service__
```bash
./runCrawler.sh
```
__2.__ Run __News API Service__
```bash
./runAPI.sh
``` 
___NOTE:___ You can find __News service__ documentation [here](https://github.com/iamvon/viBlind/blob/master/Backend/News/nyTimes/README.md)
