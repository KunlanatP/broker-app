package broker

type CreateBrokerRequest struct {
	Name        string `json:"name" validate:"required,max=255"`
	Slug        string `json:"slug" validate:"required,max=255"`
	Description string `json:"description" validate:"required"`
	LogoURL     string `json:"logo_url" validate:"required,url"`
	Website     string `json:"website" validate:"required,url"`
	BrokerType  string `json:"broker_type" validate:"required,oneof=cfd bond stock crypto"`
}

type BrokerListQuery struct {
	Search string
	Type   string
}