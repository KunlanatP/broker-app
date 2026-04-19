package broker

import "time"

type Broker struct {
	ID          uint64    `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(255);not null"`
	Slug        string    `json:"slug" gorm:"type:varchar(255);uniqueIndex;not null"`
	Description string    `json:"description" gorm:"type:text;not null"`
	LogoURL     string    `json:"logo_url" gorm:"type:text;not null"`
	Website     string    `json:"website" gorm:"type:text;not null"`
	BrokerType  string    `json:"broker_type" gorm:"type:varchar(20);not null"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

func (Broker) TableName() string {
	return "brokers"
}
