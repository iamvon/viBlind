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

func InsertAmericasTable(db *sql.DB, date string, topic string, title string, introduction string, content strings.Builder, url string, hash_url string) (error) {
	stmtInsert, err := db.Prepare("INSERT INTO Americas VALUES (?, ?, ?, ?, ?, ?, ?, UNHEX(?))")
	defer stmtInsert.Close()
	panicError(err)
	_, err = stmtInsert.Exec("0", date, topic, title, introduction, content.String(), url, hash_url)
	return err
}

func ArticleExist(db *sql.DB, uniqueKey string) (bool) {
	var id int
	rows, err := db.Query("SELECT id FROM Americas WHERE HEX(hash_url)=?", uniqueKey)
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