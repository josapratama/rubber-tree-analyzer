from pydantic import BaseModel
from typing import Optional
from datetime import datetime

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