package broker

import "testing"

func TestRepositoryFindAllSearchAndType(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)

	insertBrokers(
		t,
		db,
		Broker{Name: "Blackwood Capital Markets", Slug: "blackwood", Description: "d", LogoURL: "https://e.com/a.png", Website: "https://a.com", BrokerType: "stock"},
		Broker{Name: "BlockStream Prime", Slug: "blockstream", Description: "d", LogoURL: "https://e.com/b.png", Website: "https://b.com", BrokerType: "crypto"},
		Broker{Name: "Meridian Bonds", Slug: "meridian", Description: "d", LogoURL: "https://e.com/c.png", Website: "https://c.com", BrokerType: "bond"},
	)

	res, err := repo.FindAll("", "bond")
	if err != nil {
		t.Fatalf("find: %v", err)
	}
	if len(res) != 1 || res[0].Slug != "meridian" {
		t.Fatalf("unexpected result")
	}

	res, err = repo.FindAll("", "crypto")
	if err != nil {
		t.Fatalf("find: %v", err)
	}
	if len(res) != 1 || res[0].Slug != "blockstream" {
		t.Fatalf("unexpected result")
	}

	res, err = repo.FindAll("", "stock")
	if err != nil {
		t.Fatalf("find: %v", err)
	}
	if len(res) != 1 || res[0].Slug != "blackwood" {
		t.Fatalf("unexpected result")
	}
}

