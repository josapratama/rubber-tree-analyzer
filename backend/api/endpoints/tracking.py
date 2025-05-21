from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from db import crud, database
from schemas.tracking import TrackingResponse, TrackingCreate
from typing import List

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/tracking/", response_model=List[TrackingResponse])
def get_tracking(diagnosis_id: int = Query(None), db: Session = Depends(get_db)):
    if diagnosis_id:
        tracking = crud.get_tracking_by_diagnosis_id(db, diagnosis_id)
    else:
        tracking = crud.get_all_tracking(db)
    return tracking

@router.post("/tracking/", response_model=TrackingResponse)
def create_tracking(tracking: TrackingCreate, db: Session = Depends(get_db)):
    return crud.create_tracking(db, tracking.dict())

@router.put("/tracking/{tracking_id}", response_model=TrackingResponse)
def update_tracking(tracking_id: int, tracking: TrackingCreate, db: Session = Depends(get_db)):
    db_tracking = crud.get_tracking(db, tracking_id)
    if db_tracking is None:
        raise HTTPException(status_code=404, detail="Tracking tidak ditemukan")
    return crud.update_tracking(db, tracking_id, tracking.dict())