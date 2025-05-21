from sqlalchemy.orm import Session
from .database import SessionLocal
from .models import Disease
import json

def seed_diseases():
    db = SessionLocal()
    try:
        # Periksa apakah data sudah ada
        existing_count = db.query(Disease).count()
        if existing_count > 0:
            print(f"Database sudah berisi {existing_count} penyakit. Lewati seeding.")
            return
        
        # Data penyakit pohon karet
        diseases_data = [
            {
                "nama": "Jamur Akar Putih (JAP)",
                "deskripsi": "Penyakit jamur akar putih (JAP) atau white root disease adalah penyakit yang disebabkan oleh jamur Rigidoporus microporus yang menyerang bagian akar tanaman karet.",
                "penyebab": "Jamur Rigidoporus microporus",
                "gejala": "Daun menguning dan layu, pertumbuhan terhambat, akar diselimuti benang-benang jamur berwarna putih, tanaman mati mendadak.",
                "pengobatan": "Bongkar dan bakar tanaman yang terinfeksi parah, aplikasikan fungisida sistemik pada tanaman yang terinfeksi ringan, isolasi area yang terinfeksi dengan membuat parit.",
                "pencegahan": "Pemeriksaan akar secara rutin, sanitasi kebun, aplikasi fungisida preventif, penanaman klon tahan JAP.",
                "tingkat_keparahan": "Tinggi"
            },
            {
                "nama": "Penyakit Bidang Sadap Kering (KAS)",
                "deskripsi": "Penyakit bidang sadap kering adalah gangguan fisiologis pada tanaman karet yang menyebabkan aliran lateks terhenti pada bidang sadap.",
                "penyebab": "Stres fisiologis, intensitas penyadapan berlebihan, infeksi jamur Ceratocystis fimbriata",
                "gejala": "Bidang sadap mengering, tidak mengeluarkan lateks, kulit batang mengeras dan retak-retak, nekrosis pada jaringan kulit.",
                "pengobatan": "Istirahatkan tanaman dari penyadapan, aplikasi stimulan yang tepat, penggunaan fungisida jika disebabkan oleh jamur.",
                "pencegahan": "Penyadapan dengan teknik yang benar, pengaturan intensitas sadap, aplikasi stimulan sesuai anjuran.",
                "tingkat_keparahan": "Sedang"
            },
            {
                "nama": "Penyakit Gugur Daun Corynespora (PGDC)",
                "deskripsi": "Penyakit gugur daun yang disebabkan oleh jamur Corynespora cassiicola yang menyerang daun tanaman karet.",
                "penyebab": "Jamur Corynespora cassiicola",
                "gejala": "Bercak coklat pada daun dengan pola seperti tulang ikan, daun menguning dan gugur, serangan berulang menyebabkan tanaman gundul.",
                "pengobatan": "Aplikasi fungisida sistemik dan kontak, pemangkasan bagian tanaman yang terinfeksi.",
                "pencegahan": "Penanaman klon tahan PGDC, aplikasi fungisida preventif pada musim hujan, sanitasi kebun.",
                "tingkat_keparahan": "Tinggi"
            },
            {
                "nama": "Penyakit Kering Alur Sadap (KAS)",
                "deskripsi": "Gangguan fisiologis pada bidang sadap yang menyebabkan aliran lateks terhenti sebagian atau seluruhnya.",
                "penyebab": "Intensitas penyadapan berlebihan, teknik penyadapan yang salah, infeksi patogen.",
                "gejala": "Alur sadap mengering, produksi lateks menurun atau berhenti, kulit batang mengeras.",
                "pengobatan": "Istirahatkan tanaman dari penyadapan, aplikasi hormon stimulan yang tepat, perbaikan teknik penyadapan.",
                "pencegahan": "Penyadapan dengan teknik yang benar, pengaturan intensitas sadap, pemupukan yang seimbang.",
                "tingkat_keparahan": "Sedang"
            },
            {
                "nama": "Jamur Upas",
                "deskripsi": "Penyakit jamur upas disebabkan oleh Corticium salmonicolor yang menyerang batang dan cabang tanaman karet.",
                "penyebab": "Jamur Corticium salmonicolor",
                "gejala": "Lapisan jamur berwarna merah muda pada permukaan batang/cabang, kulit batang retak dan mengeluarkan getah, cabang mati.",
                "pengobatan": "Pengerokan jamur dan aplikasi fungisida, pemangkasan cabang yang terinfeksi parah.",
                "pencegahan": "Sanitasi kebun, pemangkasan cabang yang tidak produktif, aplikasi fungisida preventif pada musim hujan.",
                "tingkat_keparahan": "Sedang"
            },
            {
                "nama": "Penyakit Mouldy Rot",
                "deskripsi": "Penyakit yang menyerang bidang sadap tanaman karet yang disebabkan oleh jamur Ceratocystis fimbriata.",
                "penyebab": "Jamur Ceratocystis fimbriata",
                "gejala": "Bidang sadap membusuk dan berbau tidak sedap, terdapat lapisan jamur berwarna abu-abu, produksi lateks menurun.",
                "pengobatan": "Pengerokan bagian yang terinfeksi, aplikasi fungisida, istirahatkan tanaman dari penyadapan.",
                "pencegahan": "Sanitasi alat sadap, penyadapan pada kondisi kering, aplikasi fungisida preventif pada bidang sadap.",
                "tingkat_keparahan": "Sedang"
            },
            {
                "nama": "Penyakit Gugur Daun Colletotrichum",
                "deskripsi": "Penyakit gugur daun yang disebabkan oleh jamur Colletotrichum gloeosporioides yang menyerang daun muda tanaman karet.",
                "penyebab": "Jamur Colletotrichum gloeosporioides",
                "gejala": "Bercak hitam pada daun muda, daun menggulung dan gugur, serangan parah menyebabkan tanaman gundul.",
                "pengobatan": "Aplikasi fungisida sistemik, pemangkasan bagian tanaman yang terinfeksi.",
                "pencegahan": "Penanaman klon tahan penyakit, aplikasi fungisida preventif pada musim hujan, sanitasi kebun.",
                "tingkat_keparahan": "Tinggi"
            },
            {
                "nama": "Penyakit Akar Merah",
                "deskripsi": "Penyakit akar merah disebabkan oleh jamur Ganoderma philippii yang menyerang akar tanaman karet.",
                "penyebab": "Jamur Ganoderma philippii",
                "gejala": "Daun menguning dan layu, pertumbuhan terhambat, akar diselimuti benang-benang jamur berwarna merah, tanaman mati perlahan.",
                "pengobatan": "Bongkar dan bakar tanaman yang terinfeksi parah, aplikasikan fungisida sistemik pada tanaman yang terinfeksi ringan.",
                "pencegahan": "Pemeriksaan akar secara rutin, sanitasi kebun, aplikasi fungisida preventif, penanaman pada lahan yang bersih.",
                "tingkat_keparahan": "Tinggi"
            },
            {
                "nama": "Penyakit Kanker Batang",
                "deskripsi": "Penyakit yang menyebabkan kerusakan pada batang tanaman karet yang disebabkan oleh jamur Phytophthora palmivora.",
                "penyebab": "Jamur Phytophthora palmivora",
                "gejala": "Kulit batang membengkak dan retak, mengeluarkan getah berwarna coklat, bagian kayu di bawah kulit membusuk.",
                "pengobatan": "Pengerokan bagian yang terinfeksi, aplikasi fungisida, penutupan luka dengan penutup luka.",
                "pencegahan": "Sanitasi kebun, hindari pelukaan batang, aplikasi fungisida preventif pada musim hujan.",
                "tingkat_keparahan": "Sedang"
            },
            {
                "nama": "Penyakit Busuk Pangkal Batang",
                "deskripsi": "Penyakit yang menyerang pangkal batang tanaman karet yang disebabkan oleh jamur Botryodiplodia theobromae.",
                "penyebab": "Jamur Botryodiplodia theobromae",
                "gejala": "Pangkal batang membusuk dan mengeluarkan getah, kulit batang menghitam, tanaman layu dan mati.",
                "pengobatan": "Pengerokan bagian yang terinfeksi, aplikasi fungisida, penutupan luka dengan penutup luka.",
                "pencegahan": "Hindari pelukaan batang, sanitasi kebun, aplikasi fungisida preventif.",
                "tingkat_keparahan": "Tinggi"
            }
        ]
        
        # Tambahkan data ke database
        for disease_data in diseases_data:
            disease = Disease(**disease_data)
            db.add(disease)
        
        db.commit()
        print(f"Berhasil menambahkan {len(diseases_data)} penyakit ke database.")
    
    except Exception as e:
        db.rollback()
        print(f"Error saat seeding data penyakit: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_diseases()