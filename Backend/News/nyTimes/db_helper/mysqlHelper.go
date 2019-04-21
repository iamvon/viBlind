package db_helper

import (
	"database/sql"
	_ "fmt"
	_ "github.com/go-sql-driver/mysql"
	//"log"
	"strings"
)

func panicError(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func InsertDataToTable(db *sql.DB, queryStatement string, date string, topic string, title string, introduction string, content strings.Builder, url string, hash_url string, rss string, category string) (error) {
	stmtInsert, err := db.Prepare(queryStatement)
	defer stmtInsert.Close()
	panicError(err)
	_, err = stmtInsert.Exec("0", date, topic, title, introduction, content.String(), url, hash_url, rss, category)
	return err
}

func ArticleExist(db *sql.DB, queryStatement string, uniqueKey string) (bool) {
	var id int
	rows, err := db.Query(queryStatement, uniqueKey)
	defer rows.Close()
	panicError(err)
	for rows.Next() {
		err := rows.Scan(&id)
		panicError(err)
	}
	//fmt.Println(id)
	if id != 0 {
		return true
	}
	return false
}