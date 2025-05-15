from sqlalchemy.orm import Session
from . import models

def create_diagnosis(db: Session, diagnosis_data: dict):
    db_diagnosis = models.Diagnosis(
        image_label=diagnosis_data["image_label"],
        part=diagnosis_data["part"],
        masalah=diagnosis_data["masalah"],
        penyebab=diagnosis_data["penyebab"],
        solusi=diagnosis_data["solusi"],
        kesimpulan=diagnosis_data["kesimpulan"]
    )
    db.add(db_diagnosis)
    db.commit()
    db.refresh(db_diagnosis)
    return db_diagnosis

def get_diagnoses(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Diagnosis).offset(skip).limit(limit).all()

def get_diagnosis(db: Session, diagnosis_id: int):
    return db.query(models.Diagnosis).filter(models.Diagnosis.id == diagnosis_id).first()
