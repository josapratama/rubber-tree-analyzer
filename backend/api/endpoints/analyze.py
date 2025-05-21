from fastapi import APIRouter, UploadFile, File, Depends, HTTPException
from sqlalchemy.orm import Session
from db import crud, database
from model.classify import analyze_image
from core.utils import load_reference_data
from datetime import datetime
from typing import Dict, Any
import logging

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Konfigurasi logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/analyze/")
async def analyze(file: UploadFile = File(...), db: Session = Depends(get_db)):
    contents = await file.read()
    
    try:
        # Log informasi file
        logger.info(f"Analyzing file: {file.filename}, size: {len(contents)} bytes")
        
        # Analisis gambar
        label, confidence, part = analyze_image(contents)
        
        # Log hasil analisis
        logger.info(f"Analysis result: label={label}, confidence={confidence}, part={part}")
        
        # Tambahkan threshold kepercayaan untuk validasi
        confidence_threshold = 0.7
        
        # Jika kepercayaan rendah, kemungkinan bukan gambar pohon karet
        if confidence < confidence_threshold:
            error_response = {
                "filename": file.filename,
                "nama_pohon": "Tidak Terdeteksi",
                "status": "Tidak Valid",
                "saran_pengobatan": "Tidak ada",
                "is_valid_image": False,
                "pesan_error": "Gambar yang diunggah bukan bagian dari pohon karet atau kualitas gambar kurang baik. Silakan unggah gambar daun pohon karet dengan kualitas yang lebih baik."
            }
            
            # Simpan juga ke database untuk tracking
            saved = crud.create_diagnosis(db, {
                "filename": file.filename,
                "nama_pohon": "Tidak Terdeteksi",
                "status": "Tidak Valid",
                "saran_pengobatan": "Tidak ada",
                "gejala_visual": "Bukan gambar daun pohon karet atau kualitas gambar kurang baik"
            })
            
            error_response["id"] = saved.id
            error_response["created_at"] = saved.created_at
            
            return error_response
        
        # Validasi apakah gambar adalah bagian dari pohon karet
        valid_parts = ["daun"]  # Untuk saat ini hanya fokus pada daun
        is_valid_image = any(valid_part in part.lower() for valid_part in valid_parts)
        
        # Jika bukan gambar pohon karet, kembalikan pesan error
        if not is_valid_image:
            error_response = {
                "filename": file.filename,
                "nama_pohon": "Tidak Terdeteksi",
                "status": "Tidak Valid",
                "saran_pengobatan": "Tidak ada",
                "is_valid_image": False,
                "pesan_error": "Gambar yang diunggah bukan daun pohon karet. Saat ini sistem hanya dapat menganalisis daun pohon karet."
            }
            
            # Simpan juga ke database untuk tracking
            saved = crud.create_diagnosis(db, {
                "filename": file.filename,
                "nama_pohon": "Tidak Terdeteksi",
                "status": "Tidak Valid",
                "saran_pengobatan": "Tidak ada",
                "gejala_visual": "Bukan gambar daun pohon karet"
            })
            
            error_response["id"] = saved.id
            error_response["created_at"] = saved.created_at
            
            return error_response
        
        # Dapatkan data referensi
        reference_data = load_reference_data()
        diagnosis_data = None
        
        # Cari informasi dari data referensi berdasarkan bagian tanaman dan kondisi
        for item in reference_data:
            if part.lower() in item.get("filename", "").lower():
                diagnosis_data = item
                break
        
        # Jika tidak ditemukan, gunakan data default
        if not diagnosis_data:
            # Tentukan status kesehatan berdasarkan label
            status = "Sehat" if "sehat" in label.lower() else "Tidak Sehat"
            
            # Tentukan penjelasan berdasarkan status dan bagian
            penjelasan = ""
            saran = ""
            
            if status == "Sehat":
                penjelasan = f"{part} pohon karet dalam kondisi sehat. Tidak terdeteksi adanya penyakit atau kerusakan."
                saran = "Lanjutkan perawatan rutin dan pemantauan berkala."
            else:
                penjelasan = f"{part} pohon karet menunjukkan tanda-tanda tidak sehat. Kemungkinan terinfeksi penyakit atau kekurangan nutrisi."
                saran = "Konsultasikan dengan ahli pertanian atau gunakan fungisida yang sesuai. Periksa juga kondisi tanah dan nutrisi."
            
            diagnosis_data = {
                "filename": f"{part}_{datetime.now().strftime('%Y%m%d%H%M%S')}.jpg",
                "nama_pohon": "Hevea brasiliensis",
                "status": status,
                "jenis_penyakit": None if status == "Sehat" else "Tidak Teridentifikasi",
                "penyebab": None if status == "Sehat" else "Perlu analisis lebih lanjut",
                "saran_pengobatan": saran,
                "gejala_visual": penjelasan,
                "tingkat_keparahan": None if status == "Sehat" else "Sedang",
                "potensi_penyebaran": None if status == "Sehat" else "Perlu pemantauan",
                "strategi_pencegahan": "Pemantauan rutin dan perawatan yang baik"
            }
        
        # Simpan diagnosis ke database
        saved = crud.create_diagnosis(db, diagnosis_data)
        
        response = {
            "id": saved.id,
            "filename": saved.filename,
            "nama_pohon": saved.nama_pohon,
            "status": saved.status,
            "jenis_penyakit": saved.jenis_penyakit,
            "penyebab": saved.penyebab,
            "saran_pengobatan": saved.saran_pengobatan,
            "gejala_visual": saved.gejala_visual,
            "tingkat_keparahan": saved.tingkat_keparahan,
            "potensi_penyebaran": saved.potensi_penyebaran,
            "strategi_pencegahan": saved.strategi_pencegahan,
            "created_at": saved.created_at,
            "is_valid_image": True,
            "pesan_error": None,
            "confidence": float(confidence)  # Tambahkan nilai confidence ke respons
        }
        
        return response
        
    except Exception as e:
        # Tangani error jika terjadi masalah saat analisis
        logger.error(f"Error analyzing image: {str(e)}")
        error_data = {
            "filename": file.filename,
            "nama_pohon": "Error",
            "status": "Error",
            "saran_pengobatan": "Coba lagi",
            "gejala_visual": f"Error: {str(e)}"
        }
        
        saved = crud.create_diagnosis(db, error_data)
        
        return {
            "id": saved.id,
            "filename": saved.filename,
            "nama_pohon": saved.nama_pohon,
            "status": saved.status,
            "saran_pengobatan": saved.saran_pengobatan,
            "gejala_visual": saved.gejala_visual,
            "created_at": saved.created_at,
            "is_valid_image": False,
            "pesan_error": f"Terjadi kesalahan saat menganalisis gambar: {str(e)}"
        }