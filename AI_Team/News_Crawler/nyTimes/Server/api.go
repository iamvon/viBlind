package main

import (
	"database/sql"
	_ "fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	_ "net/http"
	"nyTimes/Server/db_helper"
	"nyTimes/Server/errors"
	"nyTimes/Server/models"
	_ "strings"
)

type Env struct {
	db *sql.DB
}

func queryArticle(db *sql.DB, queryStatement string, topicParam string) (*[]models.ArticleModel, uint){
	var (
		id        		uint
		date 			string
		topic 			string
		title			string
		introduction	string
		content			string
		url				string
	)

	var rows sql.Rows
	var africaArticle models.ArticleModel
	var allAfricaArticle []models.ArticleModel
	rows = *db_helper.ScanArticleContent(db, queryStatement, topicParam)

	id = 0
	for rows.Next() {
		rows.Scan(&date, &topic, &title, &introduction, &content, &url)
		africaArticle = models.ArticleModel{id, date, topic, title, introduction, content, url}
		allAfricaArticle = append(allAfricaArticle, africaArticle)
		id++
	}
	return &allAfricaArticle, id
}

func (e *Env) getArticle(c *gin.Context) {
	tables := []string{}
	tables = *db_helper.GetAllTableName(e.db)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"categories" : tables,
	})
}

func (e *Env) getAfricaTopics(c *gin.Context) {
	var africaArticleTopics []string
	queryStatement := "SELECT DISTINCT topic FROM Africa"
	africaArticleTopics = *db_helper.ScanArticleTopic(e.db, queryStatement)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"topic" : africaArticleTopics,
	})
}

func (e *Env) getAfricaArticle(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	topicParam := string(queryParam["topic"][0])

	var (
		allAfricaArticle 	*[]models.ArticleModel
		articleAmount 		uint
	)
	queryStatement := "SELECT date, topic, title, introduction, content, url FROM Africa WHERE topic=?"

	allAfricaArticle, articleAmount = queryArticle(e.db, queryStatement, topicParam)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"articleAmount" : articleAmount,
		"articleDetail" : allAfricaArticle,
	})
}

func (e *Env) getAmericasTopics(c *gin.Context) {
	var americasArticleTopics []string
	queryStatement := "SELECT DISTINCT topic FROM Americas"
	americasArticleTopics = *db_helper.ScanArticleTopic(e.db, queryStatement)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"topic" : americasArticleTopics,
	})
}

func (e *Env) getAmericasArticle(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	topicParam := string(queryParam["topic"][0])

	var (
		allAmericasArticle 	*[]models.ArticleModel
		articleAmount 		uint
	)
	queryStatement := "SELECT date, topic, title, introduction, content, url FROM Americas WHERE topic=?"

	allAmericasArticle, articleAmount = queryArticle(e.db, queryStatement, topicParam)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"articleAmount" : articleAmount,
		"articleDetail" : allAmericasArticle,
	})
}

func (e *Env) getAsiaPacificTopics(c *gin.Context) {
	var asiaPacificArticleTopics []string
	queryStatement := "SELECT DISTINCT topic FROM AsiaPacific"
	asiaPacificArticleTopics = *db_helper.ScanArticleTopic(e.db, queryStatement)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"topic" : asiaPacificArticleTopics,
	})
}

func (e *Env) getAsiaPacificArticle(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	topicParam := string(queryParam["topic"][0])

	var (
		allAsiaPacificArticle 	*[]models.ArticleModel
		articleAmount 		uint
	)
	queryStatement := "SELECT date, topic, title, introduction, content, url FROM AsiaPacific WHERE topic=?"

	allAsiaPacificArticle, articleAmount = queryArticle(e.db, queryStatement, topicParam)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"articleAmount" : articleAmount,
		"articleDetail" : allAsiaPacificArticle,
	})
}

func (e *Env) getEuropeTopics(c *gin.Context) {
	var europeArticleTopics []string
	queryStatement := "SELECT DISTINCT topic FROM Europe"
	europeArticleTopics = *db_helper.ScanArticleTopic(e.db, queryStatement)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"topic" : europeArticleTopics,
	})
}

func (e *Env) getEuropeArticle(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	topicParam := string(queryParam["topic"][0])

	var (
		allEuropeArticle 	*[]models.ArticleModel
		articleAmount 		uint
	)
	queryStatement := "SELECT date, topic, title, introduction, content, url FROM Europe WHERE topic=?"

	allEuropeArticle, articleAmount = queryArticle(e.db, queryStatement, topicParam)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"articleAmount" : articleAmount,
		"articleDetail" : allEuropeArticle,
	})
}

func (e *Env) getMiddleEastTopics(c *gin.Context) {
	var middleEastArticleTopics []string
	queryStatement := "SELECT DISTINCT topic FROM MiddleEast"
	middleEastArticleTopics = *db_helper.ScanArticleTopic(e.db, queryStatement)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"topic" : middleEastArticleTopics,
	})
}

func (e *Env) getMiddleEastArticle(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	topicParam := string(queryParam["topic"][0])

	var (
		allMiddleEastArticle 	*[]models.ArticleModel
		articleAmount 		uint
	)
	queryStatement := "SELECT date, topic, title, introduction, content, url FROM MiddleEast WHERE topic=?"

	allMiddleEastArticle, articleAmount = queryArticle(e.db, queryStatement, topicParam)
	c.JSON(http.StatusOK, gin.H {
		"status" : http.StatusCreated,
		"articleAmount" : articleAmount,
		"articleDetail" : allMiddleEastArticle,
	})
}

func main() {
	//var db sql.DB
	var err error
	db, err := sql.Open("mysql", "root:anhtrang@tcp(127.0.0.1:3306)/nyTimes")
	errors.PanicError(err)
	env := &Env{db: db}

	router := gin.Default()

	article := router.Group("/v1/api/article")

	{
		article.GET("/", env.getArticle)

		article.GET("/africa-topic", env.getAfricaTopics)
		article.GET("/africa", env.getAfricaArticle)

		article.GET("/americas-topic", env.getAmericasTopics)
		article.GET("/americas", env.getAmericasArticle)

		article.GET("/asia-pacific-topic", env.getAsiaPacificTopics)
		article.GET("/asia-pacific", env.getAsiaPacificArticle)

		article.GET("/europe-topic", env.getEuropeTopics)
		article.GET("/europe", env.getEuropeArticle)

		article.GET("/middle-east-topic", env.getMiddleEastTopics)
		article.GET("/middle-east", env.getMiddleEastArticle)
	}

	router.Run()
}