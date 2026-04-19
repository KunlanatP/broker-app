package broker

import "gorm.io/gorm"

type Repository interface {
	Create(payload Broker) (Broker, error)
	FindAll(search string, brokerType string) ([]Broker, error)
	FindBySlug(slug string) (Broker, error)
	ExistsBySlug(slug string) (bool, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) Create(payload Broker) (Broker, error) {
	err := r.db.Create(&payload).Error
	return payload, err
}

func (r *repository) FindAll(search string, brokerType string) ([]Broker, error) {
	var brokers []Broker

	query := r.db.Model(&Broker{}).Order("id desc")

	if search != "" {
		query = query.Where("name ILIKE ?", "%"+search+"%")
	}

	if brokerType != "" {
		query = query.Where("broker_type = ?", brokerType)
	}

	err := query.Find(&brokers).Error
	return brokers, err
}

func (r *repository) FindBySlug(slug string) (Broker, error) {
	var broker Broker
	err := r.db.Where("slug = ?", slug).First(&broker).Error
	return broker, err
}

func (r *repository) ExistsBySlug(slug string) (bool, error) {
	var count int64
	err := r.db.Model(&Broker{}).Where("slug = ?", slug).Count(&count).Error
	return count > 0, err
}
