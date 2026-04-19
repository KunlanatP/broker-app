## Copy .env
```
cp .env.example .env
```


# วิธีรันแบบ Manual Run
## เปิด PostgreSQL
```
docker compose up -d
```

## เช็ค container
```
docker ps
```

## migrate table
```
make migrate-up
```

## run api
```
make run
```

# วิธีรันแบบ Docker Fully Auto
```
docker compose up --build
```