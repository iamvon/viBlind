package db_helper

import (
	"database/sql"
	_"fmt"
	_ "github.com/go-sql-driver/mysql"
	"strings"
)

func panicError(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func InsertAmericasTable(db *sql.DB, date string, topic string, title string, introduction string, content strings.Builder, url string, hash_url string) (error) {
	stmtIns, err := db.Prepare("INSERT INTO Americas VALUES (?, ?, ?, ?, ?, ?, ?, UNHEX(?))")
	defer stmtIns.Close()
	panicError(err)
	_, err = stmtIns.Exec("0", date, topic, title, introduction, content.String(), url, hash_url)
	return err
}