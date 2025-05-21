# Dokumentasi Frontend

## Deskripsi

Frontend adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu petani karet dalam mendeteksi dan mengelola penyakit pada pohon karet. Aplikasi ini menggunakan teknologi machine learning untuk menganalisis gambar daun pohon karet dan memberikan diagnosis serta rekomendasi penanganan.

## Fitur Utama

- Pemindaian Gambar : Unggah atau ambil foto daun pohon karet untuk dianalisis
- Diagnosis Penyakit : Identifikasi penyakit dan kondisi kesehatan pohon karet
- Riwayat Diagnosis : Simpan dan lihat riwayat diagnosis sebelumnya
- Perpustakaan Penyakit : Informasi lengkap tentang berbagai penyakit pohon karet
- Pelacakan Perkembangan : Pantau perkembangan kesehatan pohon karet dari waktu ke waktu
- Mode Tema Gelap/Terang : Antarmuka yang dapat disesuaikan dengan preferensi pengguna

## Persyaratan Sistem

- Flutter SDK 3.0.0 atau lebih tinggi
- Dart 2.17.0 atau lebih tinggi
- Android 5.0+ (API level 21+) atau iOS 11.0+
- Kamera dan akses penyimpanan

## Instalasi

### Persiapan Lingkungan Pengembangan

1. Instal Flutter SDK:

   - Kunjungi flutter.dev dan ikuti petunjuk instalasi untuk sistem operasi Anda

2. Verifikasi instalasi:

   bash

   Run

   Open Folder

   1

   flutter doctor

3. Kloning repositori:

   bash

   Run

   Open Folder

   1

   2

   git clone https://github.com/

   username/pak-khana.git

   cd pak-khana/frontend

4. Instal dependensi:

   bash

   Run

   Open Folder

   1

   flutter pub get

## Menjalankan Aplikasi

### Mode Debug

bash

Run

Open Folder

1

flutter run

### Build APK untuk Android

bash

Run

Open Folder

1

flutter build apk --release

File APK akan tersedia di build/app/outputs/flutter-apk/app-release.apk

### Build IPA untuk iOS

bash

Run

Open Folder

1

flutter build ios --release

Buka Xcode untuk menyelesaikan proses build dan distribusi.

## Struktur Proyek

plaintext

```tree
frontend/
├── android/                # Konfigurasi spesifik Android
├── ios/                    # Konfigurasi spesifik iOS
├── lib/                    # Kode sumber utama
│   ├── config/             # Konfigurasi aplikasi
│   │   ├── api_config.dart # Konfigurasi API
│   │   └── theme.dart      # Konfigurasi tema
│   ├── models/             # Model data
│   │   ├── diagnosis.dart  # Model diagnosis
│   │   ├── disease_library.dart # Model perpustakaan penyakit
│   │   └── tracking.dart   # Model pelacakan
│   ├── screens/            # Layar aplikasi
│   │   ├── home_screen.dart # Layar utama
│   │   ├── scan_screen.dart # Layar pemindaian
│   │   ├── history_screen.dart # Layar riwayat
│   │   └── library_screen.dart # Layar perpustakaan
│   ├── services/           # Layanan aplikasi
│   │   └── api_service.dart # Layanan API
│   ├── utils/              # Utilitas
│   │   ├── date_formatter.dart # Pemformat tanggal
│   │   └── image_utils.dart # Utilitas gambar
│   ├── widgets/            # Widget yang dapat digunakan kembali
│   │   ├── scan/           # Widget untuk pemindaian
│   │   ├── history/        # Widget untuk riwayat
│   │   └── library/        # Widget untuk perpustakaan
│   └── main.dart           # Titik masuk aplikasi
├── assets/                 # Aset aplikasi
│   ├── images/             # Gambar
│   └── fonts/              # Font
├── test/                   # Pengujian
└── pubspec.yaml            # Dependensi dan konfigurasi Flutter
```

## Fitur Utama dan Penggunaannya

### 1. Pemindaian Gambar

Pengguna dapat mengunggah gambar daun pohon karet melalui kamera atau galeri. Aplikasi akan menganalisis gambar dan memberikan diagnosis.

dart

Open Folder

1

2

3

4

5

6

7

8

9

// Contoh penggunaan kamera

void \_pickImage ( ImageSource

source ) async {

final picker = ImagePicker ( ) ;

final pickedFile = await picker.

pickImage ( source : source ) ;

if ( pickedFile != null ) {

// Proses gambar

}

}

### 2. Diagnosis Penyakit

Setelah gambar diunggah, aplikasi akan mengirimkan gambar ke backend untuk dianalisis. Hasil diagnosis akan ditampilkan kepada pengguna.

dart

Open Folder

1

2

3

4

5

6

// Contoh penggunaan API untuk

analisis gambar

Future < Diagnosis > analyzeImage

( File imageFile ) async {

// Kirim gambar ke backend

// Terima hasil diagnosis

return diagnosis;

}

### 3. Riwayat Diagnosis

Pengguna dapat melihat riwayat diagnosis sebelumnya dan melacak perkembangan kesehatan pohon karet dari waktu ke waktu.

### 4. Perpustakaan Penyakit

Aplikasi menyediakan informasi lengkap tentang berbagai penyakit pohon karet, termasuk gejala, penyebab, dan rekomendasi penanganan.

## Komunikasi dengan Backend

Aplikasi berkomunikasi dengan backend melalui API RESTful. Endpoint utama:

- POST /analyze/ : Mengirim gambar untuk dianalisis
- GET /diagnoses/ : Mendapatkan riwayat diagnosis
- GET /diseases/ : Mendapatkan informasi penyakit
- GET /tracking/ : Mendapatkan data pelacakan

## Pengembangan

### Menambahkan Layar Baru

1. Buat file baru di direktori lib/screens/
2. Tambahkan rute di lib/main.dart

### Menambahkan Model Baru

1. Buat file model baru di direktori lib/models/
2. Implementasikan metode fromJson dan toJson

### Menambahkan Layanan API Baru

1. Tambahkan endpoint baru di lib/config/api_config.dart
2. Implementasikan metode baru di lib/services/api_service.dart

## Troubleshooting

### Masalah Koneksi API

Pastikan backend berjalan dan URL API dikonfigurasi dengan benar di lib/config/api_config.dart .

### Masalah Kamera

Pastikan izin kamera dan penyimpanan telah dikonfigurasi dengan benar di android/app/src/main/AndroidManifest.xml dan ios/Runner/Info.plist .

## Kontribusi

1. Fork repositori
2. Buat branch fitur ( git checkout -b feature/amazing-feature )
3. Commit perubahan ( git commit -m 'Add some amazing feature' )
4. Push ke branch ( git push origin feature/amazing-feature )
5. Buka Pull Request

## Lisensi

[Sesuaikan dengan lisensi proyek]
