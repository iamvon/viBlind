package db_helper

import (
	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	"nyTimes/Server/errors"
)

func InitGormDB(model interface{}) (*gorm.DB) {
	// Open DB connection
	var db *gorm.DB
	var err error
	db, err = gorm.Open("mysql", "root:anhtrang@/nyTimes")
	errors.PanicErrorDBConnection(err)
	db.AutoMigrate(&model)
	return db
}
