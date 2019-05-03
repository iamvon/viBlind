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
	"nyTimes/utils"
	_ "strings"
)

type Env struct {
	db *sql.DB
}

func (e *Env) getArticle(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	amountArticle := utils.StringToInt(queryParam["amount"][0])

	articleLatest := []models.ArticleModel{}

	articleLatest = *db_helper.ScanArticleLatest(e.db, amountArticle)
	c.JSON(http.StatusOK, gin.H{
		"status":        http.StatusCreated,
		"articleDetail": articleLatest,
		"articleAmount": amountArticle,
	})
}

func (e *Env) getArticleContent(c *gin.Context) {
	queryParam := c.Request.URL.Query()
	hash_url := queryParam["hash_url"][0]

	var articleContentByHashUrl string
	articleContentByHashUrl = *db_helper.ScanArticleByHashUrl(e.db, hash_url)
	c.JSON(http.StatusOK, gin.H{
		"status":         http.StatusCreated,
		"articleContent": articleContentByHashUrl,
	})
}

func main() {
	//var db sql.DB
	var err error
	db, err := sql.Open("mysql", "tuanpmhd:anhtrang@tcp(127.0.0.1:3306)/nyTimes")
	errors.PanicError(err)
	env := &Env{db: db}

	router := gin.Default()

	article := router.Group("/v1/api/article")

	{
		article.GET("", env.getArticle)
		article.GET("/content", env.getArticleContent)
	}

	router.Run()
}
