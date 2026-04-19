package broker

import (
	"fmt"
	"hash/fnv"
	"math/rand"
	"net/url"
	"strings"
)

type BrokerMarket struct {
	Label string `json:"label"`
	Value string `json:"value"`
}

type BrokerDetail struct {
	Tagline          string         `json:"tagline"`
	HeroImageURL     string         `json:"hero_image_url"`
	Address          string         `json:"address"`
	ContactEmail     string         `json:"contact_email"`
	DisplayDomain    string         `json:"display_domain"`
	RegulationTitle  string         `json:"regulation_title"`
	RegulationBody   string         `json:"regulation_body"`
	ExecutionTitle   string         `json:"execution_title"`
	ExecutionBody    string         `json:"execution_body"`
	MetricAum        string         `json:"metric_aum"`
	MetricLiquidity  string         `json:"metric_liquidity"`
	MetricRetention  string         `json:"metric_retention"`
	ProspectusURL    string         `json:"prospectus_url"`
	Markets          []BrokerMarket `json:"markets"`
}

var heroBackdrops = []string{
	"https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1920&q=80",
	"https://images.unsplash.com/photo-1511818966892-d7d671c56e68?auto=format&fit=crop&w=1920&q=80",
	"https://images.unsplash.com/photo-1448630360428-65456885c650?auto=format&fit=crop&w=1920&q=80",
	"https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1920&q=80",
	"https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&w=1920&q=80",
}

var londonAddresses = []string{
	"One Canary Wharf, London, E14 5AB",
	"30 St Mary Axe, London, EC3A 8BF",
	"175 Bishopsgate, London, EC2M 3AE",
	"25 Bank Street, London, E14 5JP",
}

func NewSeededDetail(name, slug, website, brokerType string) BrokerDetail {
	h := fnv.New32a()
	h.Write([]byte(slug))
	r := rand.New(rand.NewSource(int64(h.Sum32())))

	taglines := []string{
		fmt.Sprintf("%s delivers institutional execution with disclosed liquidity and independent oversight.", name),
		"Low-latency routing, segregated custody, and continuous surveillance across global venues.",
		"A unified prime experience for sovereign desks, asset managers, and systematic funds.",
		"Cross-asset connectivity with deterministic latency profiles and real-time risk telemetry.",
	}
	regTitles := []string{
		"FCA & SEC Aligned",
		"Multi-jurisdiction licensing",
		"MiFID II Best Execution",
		"EMIR & Dodd-Frank reporting",
	}
	regBodies := []string{
		"Policies mapped to leading regulatory frameworks with independent audit and client asset segregation.",
		"Compliance coverage across primary listing venues with annual best execution disclosures.",
		"Segregated accounts at tier-one custodians with daily reconciliation and exception monitoring.",
	}
	exTitles := []string{
		"12ms Execution",
		"Sub-20ms Execution",
		"9ms Median Latency",
		"Co-located gateways",
	}
	exBodies := []string{
		"Sterling-class matching with smart order routing and failover between primary venues.",
		"Deterministic capacity with disclosed maker incentives and surveillance tooling.",
		"Hybrid voice and electronic workflows with streaming axes into disclosed inventory.",
	}

	pct := func(base float64) string {
		v := base + r.Float64()*8 - 4
		if v < 0 {
			v = -v
		}
		return fmt.Sprintf("%+.1f%%", v)
	}
	bil := func() string {
		v := 3.0 + r.Float64()*18
		return fmt.Sprintf("$%.1fB", v)
	}
	ret := func() string {
		v := 93.0 + r.Float64()*5.5
		return fmt.Sprintf("%.1f%%", v)
	}

	markets := defaultMarketsForType(brokerType, r)

	domain := displayDomainFromWebsite(website)
	emailLocal := []string{"institutional", "desk", "prime", "coverage"}
	email := fmt.Sprintf("%s@%s", emailLocal[r.Intn(len(emailLocal))], domain)

	return BrokerDetail{
		Tagline:          taglines[r.Intn(len(taglines))],
		HeroImageURL:     heroBackdrops[r.Intn(len(heroBackdrops))],
		Address:          londonAddresses[r.Intn(len(londonAddresses))],
		ContactEmail:     email,
		DisplayDomain:    domain,
		RegulationTitle:  regTitles[r.Intn(len(regTitles))],
		RegulationBody:   regBodies[r.Intn(len(regBodies))],
		ExecutionTitle:   exTitles[r.Intn(len(exTitles))],
		ExecutionBody:    exBodies[r.Intn(len(exBodies))],
		MetricAum:        pct(22),
		MetricLiquidity:  bil(),
		MetricRetention:  ret(),
		ProspectusURL:    website,
		Markets:          markets,
	}
}

func defaultMarketsForType(brokerType string, r *rand.Rand) []BrokerMarket {
	base := []BrokerMarket{
		{Label: "FOREX PAIRS", Value: fmt.Sprintf("%d+", 55+r.Intn(35))},
		{Label: "INDICES", Value: fmt.Sprintf("%d", 18+r.Intn(25))},
		{Label: "COMMODITIES", Value: fmt.Sprintf("%d", 8+r.Intn(18))},
		{Label: "EQUITIES", Value: formatEquities(r)},
		{Label: "SOVEREIGN BONDS", Value: fmt.Sprintf("%d", 6+r.Intn(340))},
		{Label: "CRYPTO ETPS", Value: fmt.Sprintf("%d", 3+r.Intn(25))},
	}
	if brokerType == "crypto" {
		base[5].Value = fmt.Sprintf("%d+", 80+r.Intn(80))
	}
	if brokerType == "bond" {
		base[4].Value = fmt.Sprintf("%d+", 200+r.Intn(200))
	}
	return base
}

func formatEquities(r *rand.Rand) string {
	n := 2000 + r.Intn(9000)
	s := fmt.Sprintf("%d", n)
	if len(s) > 3 {
		s = s[:len(s)-3] + "," + s[len(s)-3:]
	}
	return s + "+"
}

func displayDomainFromWebsite(website string) string {
	u, err := url.Parse(website)
	if err != nil || u.Host == "" {
		return "example.com"
	}
	host := u.Hostname()
	if strings.HasPrefix(host, "www.") {
		host = host[4:]
	}
	return host
}
