from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db import crud, database
from schemas.diagnosis import DiagnosisResponse
from typing import List

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/diagnoses/", response_model=List[DiagnosisResponse])
def get_all_diagnoses(db: Session = Depends(get_db)):
    diagnoses = crud.get_diagnoses(db)
    return diagnoses

@router.get("/diagnoses/{diagnosis_id}", response_model=DiagnosisResponse)
def get_diagnosis(diagnosis_id: int, db: Session = Depends(get_db)):
    diagnosis = crud.get_diagnosis(db, diagnosis_id)
    if diagnosis is None:
        raise HTTPException(status_code=404, detail="Diagnosis tidak ditemukan")
    return diagnosis