# Dormitory Management System

ระบบจัดการหอพักด้วย `Flutter + GetX + http + json-server`

## Features

- Dashboard สรุปภาพรวม
- จัดการห้องพัก
- จัดการผู้เช่า
- มิเตอร์น้ำและไฟ
- ระบบบิลค่าเช่า
- ระบบแจ้งซ่อม
- ตั้งค่าระบบ

## Tech Stack

- Flutter
- GetX
- http
- json-server
- Material 3

## Run Project

```bash
flutter pub get
json-server --watch db.json --port 3000
flutter run
```

## json-server

ติดตั้งครั้งแรก:

```bash
npm install -g json-server
```

รัน mock backend:

```bash
json-server --watch db.json --port 3000
```

## Base URL

แก้ไขที่ `lib/app/config/api_config.dart`

ตัวอย่าง:

- Android Emulator: `http://10.0.2.2:3000`
- iOS Simulator / macOS: `http://127.0.0.1:3000`
- Flutter Web: `http://localhost:3000`
- มือถือจริง: `http://<your-local-ip>:3000`

## Folder Structure

```text
lib/
└── app/
    ├── bindings/
    ├── config/
    ├── controllers/
    ├── models/
    ├── routes/
    ├── services/
    ├── utils/
    ├── views/
    └── widgets/
```

## Notes

- โปรเจกต์นี้ใช้ `json-server` เป็น mock backend
- หากแก้ `db.json` ด้วยมือ ควรปิด `json-server` ก่อน แล้วเปิดใหม่หลังแก้เสร็จ
