package db_helper

import (
	"bytes"
	"database/sql"
	"encoding/json"
	_ "github.com/go-sql-driver/mysql"
	_"github.com/dghubble/sling"
	"io/ioutil"
	"net/http"
	"nyTimes/Server/errors"
	"nyTimes/Server/models"
	"time"
)

const (
	layoutISO = "2006-01-02"
)

type dateTime struct {
	articleID 	int
	date 		string
	year  		int
	month 		int
	day   		int
}

const baseURL = "http://52.163.230.167:5000"

var apiSummarize = "/v1/api/summarize"

//func GetAllTableName(db *sql.DB) (*[]string) {
//	tables := []string{}
//	var table string
//	res, _ := db.Query("SHOW TABLES")
//	for res.Next() {
//		res.Scan(&table)
//		splitted := camelcase.Split(table)
//		tables = append(tables, strings.Join(splitted, " "))
//	}
//	return &tables
//}

func ScanArticleContent(db *sql.DB, queryStatement string, topic string) (*sql.Rows) {
	article, err := db.Query(queryStatement, topic)
	errors.PanicError(err)
	return article
}

func ScanArticleTopic(db *sql.DB, queryStatement string) (*[]string) {
	topics := []string{}
	var topic string
	res, _ := db.Query(queryStatement)
	for res.Next() {
		res.Scan(&topic)
		topics = append(topics, topic)
	}
	return &topics
}

func ScanArticleDate(db *sql.DB) (*[]dateTime) {
	dateTimes := []dateTime{}
	var date string
	var articleID int

	res, _ := db.Query("SELECT id, date FROM articles")
	for res.Next() {
		res.Scan(&articleID, &date)

		t, _ := time.Parse(layoutISO, date)

		year := t.Year()
		month := int(t.Month())
		day := t.Day()

		dateTimes = append(dateTimes, dateTime{articleID, date, year, month, day})
	}
	return &dateTimes
}

func ScanArticleDateLatest(db *sql.DB, amountArticleLatest int) (*[]dateTime) {
	beginTime, _ := time.Parse(layoutISO, "2018-01-01")
	sortedDateTimes := *ScanArticleDate(db)

	for i := 0; i < len(sortedDateTimes); i++ {
		for j := i+1; j < len(sortedDateTimes)-1; j++  {
			time_i, _ := time.Parse(layoutISO, sortedDateTimes[i].date)
			time_j, _ := time.Parse(layoutISO, sortedDateTimes[j].date)

			diffTime_i := time_i.Sub(beginTime)
			diffTime_j := time_j.Sub(beginTime)

			if(diffTime_i < diffTime_j) {
				tempDateTime := sortedDateTimes[i]
				sortedDateTimes[i] = sortedDateTimes[j]
				sortedDateTimes[j] = tempDateTime
			}
		}
	}

	res := sortedDateTimes[:amountArticleLatest]
	return &res
}

func ScanArticleLatest(db *sql.DB, amountArticleLatest int) (*[]models.ArticleModel) {
	articleDateLatest := *ScanArticleDateLatest(db, amountArticleLatest)
	articleLatest := []models.ArticleModel{}

	var (
		date 			string
		topic 			string
		title			string
		introduction	string
		content			string
		url				string
		summarize		string
		hashUrl			string
	)

	queryStatement := "SELECT date, topic, title, introduction, content, url, HEX(hash_url) FROM articles WHERE id=?"
	for index, dateLatest  := range articleDateLatest {
		res, _ := db.Query(queryStatement, dateLatest.articleID)
		for res.Next() {
			_ = res.Scan(&date, &topic, &title, &introduction, &content, &url, &hashUrl)

			summarizeRequest, err := json.Marshal(map[string]string{
				"articleContent": content,
			})
			errors.PanicError(err)

			summarizeResponse, err := http.Post(baseURL+apiSummarize, "application/json", bytes.NewBuffer(summarizeRequest))
			errors.PanicError(err)

			defer summarizeResponse.Body.Close()

			summarizeBody, err := ioutil.ReadAll(summarizeResponse.Body)
			errors.PanicError(err)

			s := string(summarizeBody)
			summarize = s[1 : len(s)-1]

			articleLatest = append(articleLatest, models.ArticleModel{index, date, topic, title, introduction, content,summarize , url, hashUrl})

		}
	}
	return &articleLatest
}


func ScanArticleByHashUrl(db *sql.DB, hashUrl string) (*string) {
	queryStatement := "SELECT content FROM articles WHERE HEX(hash_url)=?"
	var articleContent string;
	res, _ := db.Query(queryStatement, hashUrl)
	for res.Next() {
		res.Scan(&articleContent)
	}

	return &articleContent
}
