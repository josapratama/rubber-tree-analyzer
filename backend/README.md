# Dokumentasi Backend

## Deskripsi

Backend adalah sistem berbasis FastAPI yang dirancang untuk menganalisis kesehatan pohon karet menggunakan teknologi machine learning. Sistem ini memungkinkan pengguna untuk mengunggah gambar daun pohon karet, menganalisisnya untuk mendeteksi penyakit, dan menyimpan hasil diagnosis untuk pelacakan dan pemantauan.

## Persyaratan Sistem

- Python 3.9 atau lebih tinggi
- PostgreSQL
- Dependensi Python (lihat requirements.txt )

## Instalasi

### Menggunakan Python Lokal

1. Kloning repositori ini
2. Masuk ke direktori backend:
   bash

Run

Open Folder

1

cd backend

3. Instal dependensi:
   bash

Run

Open Folder

1

pip install -r requirements.txt

4. Siapkan database PostgreSQL (pastikan PostgreSQL sudah berjalan)
5. Latih model machine learning:
   bash

Run

Open Folder

1

python -m model.train_model

6. Isi database dengan data awal:
   bash

Run

Open Folder

1

python -c "from db.seed import

run_all_seeds; run_all_seeds()"

### Menggunakan Docker

1. Pastikan Docker dan Docker Compose sudah terinstal
2. Jalankan database PostgreSQL:
   bash

Run

Open Folder

1

docker-compose up -d postgres

3. Build dan jalankan backend:
   bash

Run

Open Folder

1

2

docker build -t pak-khana-backend .

docker run -p 8000:8000

--network=pak-khana_default

pak-khana-backend

Atau, Anda dapat mengaktifkan layanan backend di docker-compose.yml dengan menghapus komentar pada bagian backend dan menjalankan:

bash

Run

Open Folder

1

docker-compose up -d

## Menjalankan Aplikasi

### Mode Pengembangan

bash

Run

Open Folder

1

uvicorn main:app --reload --host 0.

0.0.0 --port 8000

Parameter --reload akan memuat ulang server secara otomatis saat ada perubahan kode.

### Mode Produksi

bash

Run

Open Folder

1

uvicorn main:app --host 0.0.0.0

--port 8000

## Struktur Proyek

```tree
backend/
├── api/                    # Definisi API dan endpoint
│   ├── endpoints/          # Endpoint API spesifik
│   │   └── analyze.py      # Endpoint untuk analisis gambar
│   └── routes.py           # Konfigurasi router
├── core/                   # Fungsi inti dan utilitas
│   └── utils.py            # Fungsi utilitas
├── data/                   # Data referensi dan dataset
│   └── data_pohon_karet.json  # Data referensi pohon karet
├── db/                     # Konfigurasi dan model database
│   ├── crud.py             # Operasi CRUD database
│   ├── database.py         # Konfigurasi koneksi database
│   ├── models.py           # Model SQLAlchemy
│   ├── seed.py             # Script untuk mengisi data awal
│   ├── seed_diseases.py    # Data awal penyakit
│   └── seed_tracking.py    # Data awal pelacakan
├── model/                  # Model machine learning
│   ├── classify.py         # Fungsi klasifikasi gambar
│   └── train_model.py      # Script pelatihan model
├── schemas/                # Skema Pydantic untuk validasi data
├── Dockerfile              # Konfigurasi Docker
├── docker-compose.yml      # Konfigurasi Docker Compose
├── main.py                 # Titik masuk aplikasi
└── requirements.txt        # Dependensi Python
```

## API Endpoints

### Analisis Gambar

plaintext

Open Folder

1

POST /analyze/

Endpoint ini menerima unggahan gambar daun pohon karet dan mengembalikan hasil analisis kesehatan.

Parameter:

- file : File gambar (multipart/form-data)
  Respons:

json

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

10

11

12

13

14

15

16

17

{

"id" : 1 ,

"filename" : "daun_20230501120000.

jpg" ,

"nama_pohon" : "Hevea

brasiliensis" ,

"status" : "Tidak Sehat" ,

"jenis_penyakit" : "Penyakit

Gugur Daun Corynespora" ,

"penyebab" : "Jamur Corynespora

cassiicola" ,

"saran_pengobatan" : "Aplikasi

fungisida sistemik dan kontak,

pemangkasan bagian tanaman yang

terinfeksi." ,

"gejala_visual" : "Bercak coklat

pada daun dengan pola seperti

tulang ikan" ,

"tingkat_keparahan" : "Tinggi" ,

"potensi_penyebaran" : "Cepat

pada musim hujan" ,

"strategi_pencegahan" :

"Penanaman klon tahan PGDC,

aplikasi fungisida preventif

pada musim hujan" ,

"created_at" :

"2023-05-01T12:00:00" ,

"is_valid_image" : true ,

"pesan_error" : null ,

"confidence" : 0.95

}

Fold

## Model Machine Learning

Sistem menggunakan model MobileNetV2 yang telah dilatih ulang untuk mengklasifikasikan kesehatan daun pohon karet. Model ini dapat mendeteksi berbagai penyakit umum pada pohon karet.

### Melatih Model

bash

Run

Open Folder

1

python -m model.train_model

Script ini akan melatih model menggunakan data yang tersedia di direktori data/train dan data/valid .

## Database

Sistem menggunakan PostgreSQL sebagai database. Berikut adalah model utama:

1. Diagnosis - Menyimpan hasil diagnosis dari analisis gambar
2. Disease - Katalog penyakit pohon karet dan informasinya
3. Tracking - Pelacakan kesehatan pohon karet dari waktu ke waktu

### Mengisi Data Awal

bash

Run

Open Folder

1

python -c "from db.seed import

run_all_seeds; run_all_seeds()"

Script ini akan mengisi database dengan data penyakit dan data pelacakan awal.

## Pengembangan

### Menambahkan Endpoint Baru

1. Buat file baru di api/endpoints/
2. Definisikan router dan endpoint
3. Impor dan daftarkan router di api/routes.py

### Menambahkan Model Database Baru

1. Definisikan model di db/models.py
2. Buat fungsi CRUD di db/crud.py
3. Buat skema Pydantic di schemas/

## Troubleshooting

### Masalah Koneksi Database

Pastikan PostgreSQL berjalan dan kredensial yang digunakan benar. Periksa konfigurasi di db/database.py .

### Masalah Model Machine Learning

Jika model tidak dapat dimuat atau memberikan prediksi yang tidak akurat:

1. Pastikan model telah dilatih dengan benar
2. Periksa struktur direktori data pelatihan
3. Coba latih ulang model dengan data yang lebih banyak

## Lisensi

[Sesuaikan dengan lisensi proyek]
