# Backend Release Documentation

## Prerequirements
1. Install [phpMyAdmin](https://www.phpmyadmin.net/) and [MySQL](https://www.mysql.com/) 
2. Install [Docker](https://docs.docker.com/install/)
3. Clone this repository.

## Installing viBlind Backend
### Start AI service
Open your terminal at __viBlind__ repository you have cloned:
```bash
cd Backend/Releases/viBlind/AI
chmod +x run.sh
./run.sh
```
You can find AI service documentation (here)[https://github.com/iamvon/viBlind/blob/master/Backend/AI/README.md]

### Start News service
Open your terminal at __viBlind__ repository you have cloned:
```bash
cd Backend/Releases/viBlind/News/nyTimes  
chmod +x runAPI.sh
chmod +x runCrawler.sh
```
1. Run Crawler Service
```bash
./runCrawler.sh
```
2. Run News API Service
```bash
./runAPI.sh
``` 
You can find News service documentation (here)[https://github.com/iamvon/viBlind/blob/master/Backend/News/nyTimes/README.md]
