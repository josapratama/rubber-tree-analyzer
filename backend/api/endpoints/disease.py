from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db import crud, database
from schemas.disease import DiseaseResponse, DiseaseCreate
from typing import List

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/diseases/", response_model=List[DiseaseResponse])
def get_all_diseases(db: Session = Depends(get_db)):
    diseases = crud.get_diseases(db)
    return diseases

@router.get("/diseases/{disease_id}", response_model=DiseaseResponse)
def get_disease(disease_id: int, db: Session = Depends(get_db)):
    disease = crud.get_disease(db, disease_id)
    if disease is None:
        raise HTTPException(status_code=404, detail="Penyakit tidak ditemukan")
    return disease

@router.post("/diseases/", response_model=DiseaseResponse)
def create_disease(disease: DiseaseCreate, db: Session = Depends(get_db)):
    return crud.create_disease(db, disease.dict())