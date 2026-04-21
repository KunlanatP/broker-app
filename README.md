# broker-app
Woxa : Test for Full-Stack Developer
ตัวอย่างการเรียกใช้งาน API

Create (POST)
http://localhost:8080/api/brokers/

curl --location 'http://localhost:8080/api/brokers/' \
--header 'Content-Type: application/json' \
--data '{
  "name": "Blackwood Capital Markets",
  "slug": "blackwood-capital-markets",
  "description": "The definitive platform for sovereign wealth management and high-velocity algorithmic execution.",
  "logo_url": "https://example.com/logo.png",
  "website": "https://blackwood-capital.com",
  "broker_type": "bond"
}'
List (GET)
http://localhost:8080/api/brokers/

curl --location 'http://localhost:8080/api/brokers/'
Search + Filter (GET)
http://localhost:8080/api/brokers/?search=Blackwood&type=bond

curl --location 'http://localhost:8080/api/brokers/?search=Blackwood&type=bond'
Detail (GET)
http://localhost:8080/api/brokers/blackwood-capital-markets

curl --location 'http://localhost:8080/api/brokers/blackwood-capital-markets'
