from fastapi import FastAPI, UploadFile, File, Depends, HTTPException, Form, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from model.classify import analyze_image
from db import models, database, crud
import json
import os
from typing import List, Dict, Any, Optional
from pydantic import BaseModel
from datetime import datetime

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

class DiagnosisResponse(BaseModel):
    id: int
    filename: str
    nama_pohon: str
    status: str
    jenis_penyakit: Optional[str] = None
    penyebab: Optional[str] = None
    saran_pengobatan: str
    gejala_visual: Optional[str] = None
    tingkat_keparahan: Optional[str] = None
    potensi_penyebaran: Optional[str] = None
    strategi_pencegahan: Optional[str] = None
    created_at: datetime
    is_valid_image: bool = True
    pesan_error: Optional[str] = None

class HistoryResponse(BaseModel):
    id: int
    diagnosis_id: int
    lokasi: Optional[str] = None
    waktu: datetime
    petugas: Optional[str] = None
    catatan: Optional[str] = None
    tindakan_lanjutan: Optional[str] = None
    status_penanganan: Optional[str] = None
    foto_url: Optional[str] = None
    is_resolved: bool

class HistoryCreate(BaseModel):
    diagnosis_id: int
    lokasi: Optional[str] = None
    petugas: Optional[str] = None
    catatan: Optional[str] = None
    tindakan_lanjutan: Optional[str] = None
    status_penanganan: Optional[str] = None
    foto_url: Optional[str] = None
    is_resolved: bool = False

# Model untuk Disease
class DiseaseBase(BaseModel):
    nama: str
    deskripsi: Optional[str] = None
    penyebab: Optional[str] = None
    gejala: Optional[str] = None
    pengobatan: Optional[str] = None
    pencegahan: Optional[str] = None
    tingkat_keparahan: Optional[str] = None

class DiseaseCreate(DiseaseBase):
    pass

class DiseaseResponse(DiseaseBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True

# Model untuk Tracking
class TrackingBase(BaseModel):
    pohon_id: int
    tingkat_kesehatan: float
    catatan: Optional[str] = None
    foto_url: Optional[str] = None
    petugas: Optional[str] = None
    lokasi: Optional[str] = None
    tindakan: Optional[str] = None

class TrackingCreate(TrackingBase):
    tanggal: Optional[datetime] = None

class TrackingResponse(TrackingBase):
    id: int
    tanggal: datetime

    class Config:
        orm_mode = True

# Load data referensi pohon karet
def load_reference_data():
    try:
        with open("data/data_pohon_karet.json", "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading reference data: {e}")
        return []

@app.post("/analyze/")
async def analyze(file: UploadFile = File(...), db: Session = Depends(get_db)):
    contents = await file.read()
    
    try:
        # Analisis gambar
        label, part = analyze_image(contents)
        
        # Validasi apakah gambar adalah bagian dari pohon karet
        valid_parts = ["daun", "batang", "akar", "dahan"]
        is_valid_image = any(valid_part in part.lower() for valid_part in valid_parts)
        
        # Jika bukan gambar pohon karet, kembalikan pesan error
        if not is_valid_image:
            error_response = {
                "filename": file.filename,
                "nama_pohon": "Tidak Terdeteksi",
                "status": "Tidak Valid",
                "saran_pengobatan": "Tidak ada",
                "is_valid_image": False,
                "pesan_error": "Gambar yang diunggah bukan bagian dari pohon karet. Silakan unggah gambar daun, batang, akar, atau dahan pohon karet."
            }
            
            # Simpan juga ke database untuk tracking
            saved = crud.create_diagnosis(db, {
                "filename": file.filename,
                "nama_pohon": "Tidak Terdeteksi",
                "status": "Tidak Valid",
                "saran_pengobatan": "Tidak ada",
                "gejala_visual": "Bukan gambar pohon karet"
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
            "pesan_error": None
        }
        
        return response
        
    except Exception as e:
        # Tangani error jika terjadi masalah saat analisis
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

@app.get("/diagnoses/", response_model=List[DiagnosisResponse])
def get_all_diagnoses(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    diagnoses = crud.get_diagnoses(db, skip=skip, limit=limit)
    return diagnoses

@app.get("/diagnoses/{diagnosis_id}", response_model=DiagnosisResponse)
def get_diagnosis_by_id(diagnosis_id: int, db: Session = Depends(get_db)):
    diagnosis = crud.get_diagnosis(db, diagnosis_id)
    if diagnosis is None:
        raise HTTPException(status_code=404, detail="Diagnosis tidak ditemukan")
    return diagnosis

@app.post("/histories/", response_model=HistoryResponse)
def create_history(history: HistoryCreate, db: Session = Depends(get_db)):
    # Periksa apakah diagnosis ada
    diagnosis = crud.get_diagnosis(db, history.diagnosis_id)
    if diagnosis is None:
        raise HTTPException(status_code=404, detail="Diagnosis tidak ditemukan")
    
    history_data = history.dict()
    return crud.create_history(db, history_data)

@app.get("/histories/", response_model=List[HistoryResponse])
def get_all_histories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    histories = crud.get_histories(db, skip=skip, limit=limit)
    return histories

@app.get("/histories/{history_id}", response_model=HistoryResponse)
def get_history_by_id(history_id: int, db: Session = Depends(get_db)):
    history = crud.get_history(db, history_id)
    if history is None:
        raise HTTPException(status_code=404, detail="Riwayat tidak ditemukan")
    return history

@app.get("/diagnoses/{diagnosis_id}/histories", response_model=List[HistoryResponse])
def get_histories_by_diagnosis(diagnosis_id: int, db: Session = Depends(get_db)):
    # Periksa apakah diagnosis ada
    diagnosis = crud.get_diagnosis(db, diagnosis_id)
    if diagnosis is None:
        raise HTTPException(status_code=404, detail="Diagnosis tidak ditemukan")
    
    histories = crud.get_histories_by_diagnosis(db, diagnosis_id)
    return histories

@app.get("/reference-data/")
def get_reference_data():
    return load_reference_data()

# Endpoint untuk Disease
@app.post("/diseases/", response_model=DiseaseResponse)
def create_disease(disease: DiseaseCreate, db: Session = Depends(get_db)):
    disease_data = disease.dict()
    return crud.create_disease(db, disease_data)

@app.get("/diseases/", response_model=List[DiseaseResponse])
def get_all_diseases(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    diseases = crud.get_diseases(db, skip=skip, limit=limit)
    return diseases

@app.get("/diseases/{disease_id}", response_model=DiseaseResponse)
def get_disease_by_id(disease_id: int, db: Session = Depends(get_db)):
    disease = crud.get_disease(db, disease_id)
    if disease is None:
        raise HTTPException(status_code=404, detail="Penyakit tidak ditemukan")
    return disease

@app.put("/diseases/{disease_id}", response_model=DiseaseResponse)
def update_disease(disease_id: int, disease: DiseaseCreate, db: Session = Depends(get_db)):
    disease_data = disease.dict()
    updated_disease = crud.update_disease(db, disease_id, disease_data)
    if updated_disease is None:
        raise HTTPException(status_code=404, detail="Penyakit tidak ditemukan")
    return updated_disease

@app.delete("/diseases/{disease_id}")
def delete_disease(disease_id: int, db: Session = Depends(get_db)):
    success = crud.delete_disease(db, disease_id)
    if not success:
        raise HTTPException(status_code=404, detail="Penyakit tidak ditemukan")
    return {"message": "Penyakit berhasil dihapus"}

# Endpoint untuk Tracking
@app.post("/trackings/", response_model=TrackingResponse)
def create_tracking(tracking: TrackingCreate, db: Session = Depends(get_db)):
    tracking_data = tracking.dict()
    if tracking_data.get("tanggal") is None:
        tracking_data["tanggal"] = datetime.now()
    return crud.create_tracking(db, tracking_data)

@app.get("/trackings/", response_model=List[TrackingResponse])
def get_all_trackings(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    trackings = crud.get_trackings(db, skip=skip, limit=limit)
    return trackings

@app.get("/trackings/{tracking_id}", response_model=TrackingResponse)
def get_tracking_by_id(tracking_id: int, db: Session = Depends(get_db)):
    tracking = crud.get_tracking(db, tracking_id)
    if tracking is None:
        raise HTTPException(status_code=404, detail="Tracking tidak ditemukan")
    return tracking

@app.get("/pohon/{pohon_id}/trackings", response_model=List[TrackingResponse])
def get_trackings_by_pohon(pohon_id: int, db: Session = Depends(get_db)):
    trackings = crud.get_trackings_by_pohon(db, pohon_id)
    return trackings

@app.put("/trackings/{tracking_id}", response_model=TrackingResponse)
def update_tracking(tracking_id: int, tracking: TrackingCreate, db: Session = Depends(get_db)):
    tracking_data = tracking.dict()
    updated_tracking = crud.update_tracking(db, tracking_id, tracking_data)
    if updated_tracking is None:
        raise HTTPException(status_code=404, detail="Tracking tidak ditemukan")
    return updated_tracking

@app.delete("/trackings/{tracking_id}")
def delete_tracking(tracking_id: int, db: Session = Depends(get_db)):
    success = crud.delete_tracking(db, tracking_id)
    if not success:
        raise HTTPException(status_code=404, detail="Tracking tidak ditemukan")
    return {"message": "Tracking berhasil dihapus"}
