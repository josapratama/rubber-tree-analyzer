from sqlalchemy.orm import Session
from . import models
from typing import Dict, Optional

def create_diagnosis(db: Session, diagnosis_data: dict):
    db_diagnosis = models.Diagnosis(
        filename=diagnosis_data.get("filename", "unknown.jpg"),
        nama_pohon=diagnosis_data.get("nama_pohon", "Hevea brasiliensis"),
        status=diagnosis_data.get("status", "Tidak diketahui"),
        jenis_penyakit=diagnosis_data.get("jenis_penyakit"),
        penyebab=diagnosis_data.get("penyebab"),
        saran_pengobatan=diagnosis_data.get("saran_pengobatan", "-"),
        gejala_visual=diagnosis_data.get("gejala_visual"),
        tingkat_keparahan=diagnosis_data.get("tingkat_keparahan"),
        potensi_penyebaran=diagnosis_data.get("potensi_penyebaran"),
        strategi_pencegahan=diagnosis_data.get("strategi_pencegahan")
    )
    db.add(db_diagnosis)
    db.commit()
    db.refresh(db_diagnosis)
    return db_diagnosis

def get_diagnoses(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Diagnosis).offset(skip).limit(limit).all()

def get_diagnosis(db: Session, diagnosis_id: int):
    return db.query(models.Diagnosis).filter(models.Diagnosis.id == diagnosis_id).first()

def create_history(db: Session, history_data: dict):
    db_history = models.History(
        diagnosis_id=history_data.get("diagnosis_id"),
        lokasi=history_data.get("lokasi"),
        petugas=history_data.get("petugas"),
        catatan=history_data.get("catatan"),
        tindakan_lanjutan=history_data.get("tindakan_lanjutan"),
        status_penanganan=history_data.get("status_penanganan"),
        foto_url=history_data.get("foto_url"),
        is_resolved=history_data.get("is_resolved", False)
    )
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

def get_histories(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.History).offset(skip).limit(limit).all()

def get_history(db: Session, history_id: int):
    return db.query(models.History).filter(models.History.id == history_id).first()

def get_histories_by_diagnosis(db: Session, diagnosis_id: int):
    return db.query(models.History).filter(models.History.diagnosis_id == diagnosis_id).all()

# Fungsi CRUD untuk Disease
def create_disease(db: Session, disease_data: dict):
    db_disease = models.Disease(
        nama=disease_data.get("nama"),
        deskripsi=disease_data.get("deskripsi"),
        penyebab=disease_data.get("penyebab"),
        gejala=disease_data.get("gejala"),
        pengobatan=disease_data.get("pengobatan"),
        pencegahan=disease_data.get("pencegahan"),
        tingkat_keparahan=disease_data.get("tingkat_keparahan")
    )
    db.add(db_disease)
    db.commit()
    db.refresh(db_disease)
    return db_disease

def get_diseases(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Disease).offset(skip).limit(limit).all()

def get_disease(db: Session, disease_id: int):
    return db.query(models.Disease).filter(models.Disease.id == disease_id).first()

def update_disease(db: Session, disease_id: int, disease_data: dict):
    db_disease = get_disease(db, disease_id)
    if db_disease:
        for key, value in disease_data.items():
            setattr(db_disease, key, value)
        db.commit()
        db.refresh(db_disease)
    return db_disease

def delete_disease(db: Session, disease_id: int):
    db_disease = get_disease(db, disease_id)
    if db_disease:
        db.delete(db_disease)
        db.commit()
        return True
    return False

# Fungsi CRUD untuk Tracking
def create_tracking(db: Session, tracking_data: dict):
    db_tracking = models.Tracking(
        pohon_id=tracking_data.get("pohon_id"),
        tanggal=tracking_data.get("tanggal"),
        tingkat_kesehatan=tracking_data.get("tingkat_kesehatan"),
        catatan=tracking_data.get("catatan"),
        foto_url=tracking_data.get("foto_url"),
        petugas=tracking_data.get("petugas"),
        lokasi=tracking_data.get("lokasi"),
        tindakan=tracking_data.get("tindakan")
    )
    db.add(db_tracking)
    db.commit()
    db.refresh(db_tracking)
    return db_tracking

def get_trackings(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Tracking).offset(skip).limit(limit).all()

def get_tracking(db: Session, tracking_id: int):
    return db.query(models.Tracking).filter(models.Tracking.id == tracking_id).first()

def get_trackings_by_pohon(db: Session, pohon_id: int):
    return db.query(models.Tracking).filter(models.Tracking.pohon_id == pohon_id).all()

def update_tracking(db: Session, tracking_id: int, tracking_data: dict):
    db_tracking = get_tracking(db, tracking_id)
    if db_tracking:
        for key, value in tracking_data.items():
            setattr(db_tracking, key, value)
        db.commit()
        db.refresh(db_tracking)
    return db_tracking

def delete_tracking(db: Session, tracking_id: int):
    db_tracking = get_tracking(db, tracking_id)
    if db_tracking:
        db.delete(db_tracking)
        db.commit()
        return True
    return False
