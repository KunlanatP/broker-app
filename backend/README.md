## Broker API (Go + Fiber + PostgreSQL)

โปรเจกต์นี้เป็น REST API สำหรับจัดการข้อมูล Broker ตามโจทย์ทดสอบ Full Stack Developer โดยรองรับการสร้างข้อมูล, ค้นหา/กรอง, และดึงข้อมูลรายตัวผ่าน `slug`

## Tech Stack
- **Go** (`fiber`, `gorm`)
- **PostgreSQL 16**
- **Goose migrations** (ไฟล์ `.sql` แบบ up/down)
- **Docker / docker compose**

## Database
ตาราง `brokers` มีฟิลด์หลักตามโจทย์
- `id`, `name`, `slug`, `description`, `logo_url`, `website`, `broker_type`

มีฟิลด์เสริมเพื่อรองรับ UI design หน้า detail ให้เหมือนตัวอย่างมากที่สุด
- `detail` (JSONB) ใช้เก็บข้อมูลพวก hero image, metrics, markets, contact ฯลฯ

## API
Base path: `/api`

- **POST** `/api/brokers`
  - body:
    - `name`, `slug`, `description`, `logo_url`, `website`, `broker_type`
    - `detail` (optional) ถ้าไม่ส่ง ระบบจะสร้างข้อมูลแบบสุ่มที่ดูสมจริงให้เอง
- **GET** `/api/brokers`
  - query:
    - `search` ค้นหาด้วยชื่อ (server-side)
    - `type` กรองตาม `broker_type`
- **GET** `/api/brokers/:slug`
  - ดึง broker รายตัวด้วย `slug`

## Run (แนะนำ)
ต้องมี Docker ติดตั้งก่อน

```bash
cd backend
cp .env.example .env
docker compose up --build
```

API จะอยู่ที่ `http://localhost:8080/api`

## Run แบบ manual
```bash
cd backend
cp .env.example .env
make up
make migrate-up
make run
```

## Migrations
ดูไฟล์ migration ได้ใน `migrations/`

คำสั่งที่ใช้บ่อย:
```bash
cd backend
make migrate-status
make migrate-up
make migrate-down
```

## Seed data
มี migration seed และ migration detail เพื่อให้มีข้อมูลตัวอย่างพร้อมใช้งานทันที

ถ้าต้องการ seed แบบ cmd (เฉพาะตอน DB ว่าง):
```bash
cd backend
go run ./cmd/seed
```

## Docker compose
ไฟล์ `docker-compose.yml` จะรัน 2 service:
- `postgres` (db)
- `backend` (api) โดย `entrypoint.sh` จะรัน migrations แล้วค่อย start api

## Tests
```bash
cd backend
go test ./...
```

ดูผลลัพธ์จาก exit code และ summary ต่อแพ็กเกจ