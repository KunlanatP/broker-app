# broker-app

Woxa : Test for Full-Stack Developer

---

## 📌 API Usage

### ➕ Create Broker (POST)

```
http://localhost:8080/api/brokers/
```

```bash
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
```

---

### 📄 List Brokers (GET)

```
http://localhost:8080/api/brokers/
```

```bash
curl --location 'http://localhost:8080/api/brokers/'
```

---

### 🔍 Search + Filter (GET)

```
http://localhost:8080/api/brokers/?search=Blackwood&type=bond
```

```bash
curl --location 'http://localhost:8080/api/brokers/?search=Blackwood&type=bond'
```

---

### 🔎 Broker Detail (GET)

```
http://localhost:8080/api/brokers/blackwood-capital-markets
```

```bash
curl --location 'http://localhost:8080/api/brokers/blackwood-capital-markets'
```

---
