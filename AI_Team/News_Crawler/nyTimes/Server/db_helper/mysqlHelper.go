package db_helper

import (
	"database/sql"
	"github.com/fatih/camelcase"
	_ "github.com/go-sql-driver/mysql"
	"nyTimes/Server/errors"
	"strings"
)

func GetAllTableName(db *sql.DB) (*[]string) {
	tables := []string{}
	var table string
	res, _ := db.Query("SHOW TABLES")
	for res.Next() {
		res.Scan(&table)
		splitted := camelcase.Split(table)
		tables = append(tables, strings.Join(splitted, " "))
	}
	return &tables
}

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




//var (
//	id        		uint
//	date 			string
//	topic 			string
//	title			string
//	introduction	string
//	content			string
//	url				string
//)