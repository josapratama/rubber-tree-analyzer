from fastapi import FastAPI, UploadFile, File, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from model.classify import analyze_image
from db import models, database, crud
import json
from typing import List
from pydantic import BaseModel

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
    image_label: str
    part: str
    masalah: str
    penyebab: str
    solusi: str
    kesimpulan: str

@app.post("/analyze/")
async def analyze(file: UploadFile = File(...), db: Session = Depends(get_db)):
    contents = await file.read()
    label, part = analyze_image(contents)

    with open("data/solutions.json", "r") as f:
        solutions = json.load(f)

    diagnosis = solutions.get(label, {
        "masalah": "Tidak diketahui",
        "penyebab": "-",
        "solusi": "-",
        "kesimpulan": "-"
    })

    record = {
        "image_label": label,
        "part": part,
        **diagnosis
    }

    saved = crud.create_diagnosis(db, record)
    return {"id": saved.id, "label": label, "part": part, **diagnosis}

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
