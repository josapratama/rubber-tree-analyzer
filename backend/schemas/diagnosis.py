from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class DiagnosisBase(BaseModel):
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

class DiagnosisCreate(DiagnosisBase):
    pass

class DiagnosisResponse(DiagnosisBase):
    id: int
    created_at: datetime
    is_valid_image: bool = True
    pesan_error: Optional[str] = None

    class Config:
        orm_mode = True