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
__1.__ ___GET___ http://52.163.230.167:8080/v1/api/article
Response:
```js
{
  "categories": [
    "Africa",
    "Americas",
    "Asia Pacific",
    "Europe",
    "Middle East"
  ],
  "status": 201
}
```
__2.__ ___GET___ http://52.163.230.167:8080/v1/api/article/africa-topic
Response:
```js
{
  "status": 201,
  "topic": [
    "Africa",
    "Europe",
    "Lens",
    "Obituaries",
    "Art & Design",
    "Science"
  ]
}
```

__3.__ ___GET___ http://52.163.230.167:8080/v1/api/article/africa?topic=Lens
Response:
```js
{
  "articleAmount": 1,
  "articleDetail": [
    {
      "id": 0,
      "date": "2019-03-29",
      "topic": "Lens",
      "title": "Finding Fraternity and Politics in Algerian Soccer",
      "introduction": "Fethi Sahraoui has been photographing young Algerians who rush to local stadiums for biweekly soccer matches and for a chance to be heard.",
      "content": "Arms raised high. Crowds united in song. Riot police armed with batons. These images could have been taken at political rallies or protests. But they weren’t. They were from soccer matches in northwestern Algeria.The sport is so popular in the North African nation and the region, that it’s been given the Marxist treatment: “We call it the opium of the people,” Fethi Sahraoui said. Since 2015, Mr. Sahraoui has photographed roughly 30 games in his hometown, Mascara, and in neighboring Relizane. The result is “Stadiumphilia.”During soccer season — which runs from late August until the end of May — young men storm stadiums to watch local teams face off in biweekly matches. Unlike those fans, Mr. Sahraoui isn’t concerned with the athletes. He turns his lens toward the surrounding commotion, the fervent faces in the stands.The atmosphere is electric, to say the least. Algerian law prohibits anyone under 18 to enter the stadiums without a guardian, Mr. Sahraoui said. But that doesn’t stop young boys from trying to jump over fences to see the action.On the surface, the takeaway is that Algerians are soccer fanatics. But Mr. Sahraoui sees beyond the entertainment. He says the stadiums have become platforms for young men to find a sense of brotherhood and to escape the pressures of daily life. After spending years among those crowds, he adds,  he can’t help but link the energy of those games to current protests.In February, President Abdelaziz Bouteflika announced that he would run for a fifth term. Algerians had been living under his rule for 20 years, and they had had enough. Thousands of demonstrators have been taking to the streets demanding his resignation, citing problems like corruption and stifling unemployment.Life is particularly rough for Algerian youth. According to the International Monetary Fund, the unemployment rate among Algerians between the ages of 15 and 24 is more than 28 percent. And a third of youth are either unemployed or not in school. “We need to admit that what’s happening in Algeria, this popular movement or popular uprising, it’s orchestrated mainly by youth,” Mr. Sahraoui said.He feels that before the protests, young Algerians took out their frustrations in the soccer stadiums. Their songs and chants were highly political and socially conscious: They would imagine better lives or call for local politicians to step down. Some would sing tribute songs to friends who had perished trying to cross the Mediterranean, Mr. Sahroui said.Politics has long been intertwined with the sport. In one image, a boy peers out from behind a poster of Zougari Taher, a man who died during the Algerian war for independence from France in the 1950s and ’60s. Locals herald Mr. Taher as a martyr, and the stadium in Relizane is named after him.With the recent protests, Algerians have turned to the streets. “I’m happy for them because it’s a larger space and a lot of people are hearing them and paying attention to them,” Mr. Sahraoui said. The streets also allows for more unity. Women have openly taken part in the demonstrations, while soccer has always been a “manly” sport in the country, Mr. Sahraoui said. He wanted this essay to focus on young fans, and most if not all of those happened to be boys.Mr. Sahraoui couldn’t exactly see himself in those youngsters. Growing up, his family thought the games were dangerous and prohibited him from going. “Working on this project, it was like a delayed exploration of this universe,” he said. “I went there as a photographer, but there was the young child who was inside me.”Fun fact: These images — and all of his personal projects — were taken with smartphones. But he says if no one notices, “it’s a good sign.” He feels at ease with the device. Plus, carrying a larger digital camera would have drawn the curiosity of riot police, while a phone helped him blend in with the crowds.“I think that a photographer will remain a photographer,” he said. “Even with an iPhone.”Follow @nytimesphoto and @_SaraAridi on Twitter. You can also find us on Facebook and Instagram.",
      "url": "https://www.nytimes.com/2019/03/29/lens/finding-fraternity-and-politics-in-algerian-soccer.html?partner=rss&emc=rss"
    }
  ],
  "status": 201
}
```
