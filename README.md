# 🤝 Ulurkan Tangan UAS
*Aplikasi Mobile Crowdfunding Donasi*

---

## 📱 Deskripsi
**Ulurkan Tangan UAS** adalah aplikasi mobile berbasis **Flutter** yang digunakan untuk melihat campaign donasi dan melakukan donasi secara online.  
Aplikasi ini dibuat sebagai **tugas UAS**, dengan backend menggunakan **Laravel** dan database **MySQL**.  
Struktur project dipisahkan antara tampilan, logika bisnis, dan data agar kode lebih rapi dan mudah dikembangkan.

---

## ✨ Fitur Utama
- Login dan registrasi pengguna  
- Melihat daftar campaign donasi  
- Melihat detail campaign  
- Melakukan donasi  
- Melihat riwayat donasi  
- Manajemen profil pengguna  
- Logout dan session management  

---

## 🏗️ Arsitektur Aplikasi
Aplikasi ini menggunakan **Clean Architecture (layered)** dengan pembagian sebagai berikut:

- **Presentation Layer**: tampilan dan interaksi pengguna  
- **Domain Layer**: logika bisnis serta request dan response  
- **Data Layer**: pengambilan data dari API  
- **Backend**: REST API Laravel dan database MySQL  

Pemisahan ini bertujuan agar aplikasi lebih terstruktur dan mudah dipelihara.

---

## 🔄 Alur Aplikasi
1. User membuka aplikasi  
2. Login atau registrasi  
3. Masuk ke halaman utama  
4. Melihat daftar campaign  
5. Memilih campaign dan melakukan donasi  
6. Riwayat donasi dapat dilihat kembali
    
---

## 🛠️ Teknologi yang Digunakan

**Frontend**
- Flutter  
- Dart  

**Backend**
- Laravel  
- MySQL  

**Tools**
- Git & GitHub  
- VS Code  
- Postman  

---

## 📁 Struktur Folder (Ringkas)
```text
lib/
├── presentation/
│   └── pages/        # Halaman UI (login, home, donasi, dll)
├── domain/
│   └── usecase/
│       ├── request/  # Request ke API
│       └── response/ # Response dari API
├── data/
│   └── server/
│       ├── service/  # API service & session
│       └── model/    # Model data
└── main.dart

