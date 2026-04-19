## Broker Frontend (Flutter Web)

โปรเจกต์นี้เป็นเว็บแอปสำหรับจัดการข้อมูล Broker ตามโจทย์ทดสอบ Full Stack Developer มี 3 หน้า และเชื่อมต่อกับ API ของฝั่ง backend แบบ end-to-end

## Tech Stack
- **Flutter (Web)** + Material 3
- **flutter_bloc** (state management)
- **go_router** (routing)
- **dio** (เรียก API)
- **cached_network_image** (แสดงรูป)

## Routes
- `/` Broker List
- `/create` Create Broker
- `/broker/:slug` Broker Detail

## Features ที่ทำ
- Search โดยส่ง `?search=` ไปฝั่ง server
- Filter โดยส่ง `?type=` ไปฝั่ง server
- Debounce ตอนพิมพ์ค้นหา
- Detail page เปลี่ยน `<title>` และ meta description ตามข้อมูลที่โหลด (Flutter Web)

## Setup
ติดตั้ง Flutter SDK และรัน backend ไว้ก่อน

ตั้งค่า base url ได้ที่:
- `lib/core/constants/app_constants.dart` (`apiBaseUrl`)

## Run
```bash
cd frontend
flutter pub get
flutter run -d chrome
```

ถ้าจะ build:
```bash
cd frontend
flutter build web
```

## Tests
```bash
cd frontend
flutter test
```

ผลลัพธ์จะสรุปจำนวนเคสที่ผ่าน/ไม่ผ่านใน console และใช้ exit code เพื่อบอกสถานะ
