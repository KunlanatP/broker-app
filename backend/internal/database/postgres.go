package database

import (
	"log"

	"com.kunlanat.github/broker-api/internal/config"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func NewPostgres(env config.Env) *gorm.DB {
	db, err := gorm.Open(postgres.Open(env.DatabaseDSN()), &gorm.Config{})
	if err != nil {
		log.Fatal("failed to connect database: ", err)
	}

	return db
}
