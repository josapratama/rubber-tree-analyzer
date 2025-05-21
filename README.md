# PAplikasi Deteksi Penyakit Pohon Karet

## Deskripsi

Aplikasi ini adalah aplikasi komprehensif untuk membantu petani karet dalam mendeteksi, mendiagnosis, dan mengelola penyakit pada pohon karet. Dengan menggunakan teknologi machine learning, aplikasi ini dapat menganalisis gambar daun pohon karet untuk mengidentifikasi berbagai penyakit dan memberikan rekomendasi penanganan yang tepat.

## Fitur Utama

- Deteksi Penyakit : Analisis gambar daun pohon karet untuk mendeteksi penyakit
- Diagnosis Akurat : Identifikasi jenis penyakit, tingkat keparahan, dan penyebabnya
- Rekomendasi Penanganan : Saran pengobatan dan strategi pencegahan
- Pelacakan Perkembangan : Pantau kesehatan pohon karet dari waktu ke waktu
- Perpustakaan Penyakit : Informasi lengkap tentang berbagai penyakit pohon karet
- Antarmuka Ramah Pengguna : Desain intuitif dengan dukungan tema gelap/terang

## Struktur Proyek

Proyek ini terdiri dari dua komponen utama:

- Backend : API berbasis FastAPI dengan model machine learning untuk analisis gambar
- Frontend : Aplikasi mobile berbasis Flutter untuk interaksi pengguna

## Persyaratan Sistem

### Backend

- Python 3.9+
- PostgreSQL
- Dependensi Python (lihat backend/requirements.txt )

### Frontend

- Flutter SDK 3.0.0+
- Dart 2.17.0+
- Android 5.0+ (API level 21+) atau iOS 11.0+

## Instalasi dan Pengaturan

### Backend

1. Masuk ke direktori backend:

   bash

   Run

   Open Folder

   1

   cd backend

2. Instal dependensi:

   bash

   Run

   Open Folder

   1

   pip install -r requirements.txt

3. Latih model machine learning:

   bash

   Run

   Open Folder

   1

   python -m model.train_model

4. Isi database dengan data awal:

   bash

   Run

   Open Folder

   1

   python -c "from db.seed import

   run_all_seeds; run_all_seeds()"

5. Jalankan server:

   bash

   Run

   Open Folder

   1

   uvicorn main:app --reload

   --host 0.0.0.0 --port 8000

### Frontend

1. Masuk ke direktori frontend:

   bash

   Run

   Open Folder

   1

   cd frontend

2. Instal dependensi:

   bash

   Run

   Open Folder

   1

   flutter pub get

3. Jalankan aplikasi:

   bash

   Run

   Open Folder

   1

   flutter run

## Penggunaan

1. Pemindaian Gambar : Ambil foto daun pohon karet atau pilih dari galeri
2. Analisis : Aplikasi akan menganalisis gambar dan memberikan diagnosis
3. Hasil : Lihat hasil diagnosis, termasuk jenis penyakit dan rekomendasi penanganan
4. Simpan : Simpan hasil diagnosis untuk pelacakan perkembangan
5. Riwayat : Lihat riwayat diagnosis sebelumnya
6. Perpustakaan : Pelajari lebih lanjut tentang berbagai penyakit pohon karet

## Dokumentasi

Untuk informasi lebih lanjut, lihat dokumentasi lengkap:

- Dokumentasi Backend
- Dokumentasi Frontend

## Kontribusi

Kami menyambut kontribusi dari komunitas! Jika Anda ingin berkontribusi:

1. Fork repositori
2. Buat branch fitur ( git checkout -b feature/amazing-feature )
3. Commit perubahan ( git commit -m 'Menambahkan fitur luar biasa' )
4. Push ke branch ( git push origin feature/amazing-feature )
5. Buka Pull Request

## Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT .

## Kontak

Untuk pertanyaan atau dukungan, silakan hubungi:

- Email: email@example.com
- GitHub: github.com/username/pak-khana

## Ucapan Terima Kasih

Terima kasih kepada semua kontributor dan pendukung yang telah membantu dalam pengembangan aplikasi.
