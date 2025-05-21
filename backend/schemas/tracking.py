from pydantic import BaseModel
from typing import Optional
from datetime import datetime

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

class HistoryBase(BaseModel):
    diagnosis_id: int
    lokasi: Optional[str] = None
    petugas: Optional[str] = None
    catatan: Optional[str] = None
    tindakan_lanjutan: Optional[str] = None
    status_penanganan: Optional[str] = None
    foto_url: Optional[str] = None
    is_resolved: bool = False

class HistoryCreate(HistoryBase):
    pass

class HistoryResponse(HistoryBase):
    id: int
    waktu: datetime
    is_resolved: bool

    class Config:
        orm_mode = True