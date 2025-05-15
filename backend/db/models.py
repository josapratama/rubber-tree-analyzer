from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from .database import Base

class Diagnosis(Base):
    __tablename__ = "diagnoses"

    id = Column(Integer, primary_key=True, index=True)
    image_label = Column(String, index=True)
    part = Column(String)
    masalah = Column(String)
    penyebab = Column(String)
    solusi = Column(String)
    kesimpulan = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
