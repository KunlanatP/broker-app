package main

import (
	"encoding/json"
	"log"

	"com.kunlanat.github/broker-api/internal/config"
	"com.kunlanat.github/broker-api/internal/database"
	"com.kunlanat.github/broker-api/internal/domain/broker"
)

func main() {
	env := config.LoadEnv()
	db := database.NewPostgres(env)

	var count int64
	db.Model(&broker.Broker{}).Count(&count)

	if count > 0 {
		log.Println("seed skipped: data already exists")
		return
	}

	data := []broker.Broker{
		{
			Name:        "Summit Analytics",
			Slug:        "summit-analytics",
			Description: "Data-driven commodities brokerage.",
			LogoURL:     "https://example.com/summit.png",
			Website:     "https://summit.com",
			BrokerType:  "bond",
		},
	}

	for _, item := range data {
		d, err := json.Marshal(broker.NewSeededDetail(item.Name, item.Slug, item.Website, item.BrokerType))
		if err != nil {
			log.Fatal(err)
		}
		item.Detail = d
		db.Create(&item)
	}

	log.Println("seed completed")
}
