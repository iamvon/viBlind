package main

import (
	"crypto/sha1"
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gocolly/colly"
	"github.com/mmcdole/gofeed"
	_ "io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
	"sync"
	"encoding/hex"
	"nyTimes/db_helper"
	"nyTimes/Rss"
	//"sync"
	"time"
)

func writeToFile(fileName string, content string) {
	file, err := os.OpenFile(fileName, os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Println(err)
	}

	file.WriteString(content)
}

func crawlByDOM(date string, topic string, title string, introduction string, content strings.Builder, collector *colly.Collector, item *gofeed.Item, wg sync.WaitGroup) (string, string, string, string, strings.Builder) {
	date, topic, title, introduction = "", "", "", ""
	content.Reset()

	wg.Add(1)
	func() {
		defer wg.Done()
		collector.OnHTML("header > div > div > ul > li > time", func(e *colly.HTMLElement) {
			date = e.Attr("datetime")
			//fmt.Println("date:", index)
		})
	}()

	wg.Add(1)
	func() {
		defer wg.Done()
		collector.OnHTML("main:first-of-type > div:first-of-type > div:first-of-type > div:first-of-type > div:first-of-type > span:first-of-type > a:first-of-type", func(e *colly.HTMLElement) {
			topic = e.Text
			//fmt.Println("topic:", index)
		})
	}()

	wg.Add(1)
	func() {
		defer wg.Done()
		collector.OnHTML("header > div > h1 > span", func(e *colly.HTMLElement) {
			title = e.Text
			//fmt.Println("title:", index)
		})
	}()

	wg.Add(1)
	func() {
		defer wg.Done()
		collector.OnHTML("header > p:last-of-type", func(e *colly.HTMLElement) {
			introduction = e.Text
			//fmt.Println("introduction:", index)
		})
	}()

	wg.Add(1)
	func() {
		defer wg.Done()
		collector.OnHTML("div.StoryBodyCompanionColumn > div > p", func(e *colly.HTMLElement) {
			content.WriteString(e.Text)
			//fmt.Println("content:", index)
		})
	}()

	collector.Visit(item.Link)
	return date, topic, title, introduction, content
}

func updateDatabase(db *sql.DB, fp *gofeed.Parser, url_rss []string, url string, start time.Time, collector *colly.Collector, wg sync.WaitGroup) {
	var crawlTimes int = 0
	var date, topic, title, introduction string
	content := strings.Builder{}
	feed, _ := fp.ParseURL(url)

	for _, article := range feed.Items {
		fmt.Println(article.Link)
		date, topic, title, introduction = "", "", "", ""
		content.Reset()

		date, topic, title, introduction, content = crawlByDOM(date, topic, title, introduction, content, collector, article, wg)

		wg.Wait()

		hash_url := hashSha1(article.Link)

		queryStatement := "SELECT id FROM articles WHERE HEX(hash_url)=?"

		if (len(content.String()) != 0 && !db_helper.ArticleExist(db, queryStatement, hash_url)) {
			queryStatement := "INSERT INTO articles VALUES (?, ?, ?, ?, ?, ?, ?, UNHEX(?), ?, ?)"
			err := db_helper.InsertDataToTable(db, queryStatement, date, topic, title, introduction, content, article.Link, hash_url, url, Rss.RssToCategory[url])
			if err != nil {
				fmt.Println("INSERT articles DATABASE: ERROR")
				fmt.Println(err.Error())
				//panic(err.Error())
			} else {
				fmt.Println("INSERT articles DATABASE: OK")
			}
		} else if (db_helper.ArticleExist(db, queryStatement, hash_url)) {
			fmt.Println("INSERT articles DATABASE: FAIL, Article Existed!")
		}
	}

	crawlTimes++
	fmt.Println("==============================================================")
	fmt.Println("articles Crawl Times: ", crawlTimes)
	end := time.Since(start)
	log.Printf("articles Time: %s", end)
	fmt.Println("==============================================================")
}


func hashSha1(text string) (string) {
	hashing := sha1.New()
	hashing.Write([]byte(text))
	text_bytes := hashing.Sum(nil)
	hash_text := hex.EncodeToString(text_bytes)
	return hash_text
}

func byteToInt(byteNumber []byte) (int) {
	intNumber, _ := strconv.Atoi(string(byteNumber))
	return intNumber
}

func intToString(intNumber int) (string) {
	stringNumber := strconv.Itoa(intNumber)
	return stringNumber
}

func panicError(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func main() {
	url_rss := Rss.RssURL

	Time := os.Args[1]
	updateTime, _ := strconv.Atoi(Time)

	var wg sync.WaitGroup

	fp := gofeed.NewParser()

	start := time.Now()

	db, err := sql.Open("mysql", "root:anhtrang@tcp(127.0.0.1:3306)/nyTimes")
	panicError(err)
	defer db.Close()

	c := colly.NewCollector()

	func() {
		for t := time.Tick(time.Duration(updateTime) * time.Minute); ; <-t {
			for _, url := range url_rss {
					updateDatabase(db, fp, url_rss, url, start, c, wg)
			}
		}
	}()


}
