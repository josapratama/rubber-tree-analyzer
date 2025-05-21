from sqlalchemy import Column, Integer, String, DateTime, Text, Boolean, Float, ForeignKey
from sqlalchemy.sql import func
from .database import Base

class Diagnosis(Base):
    __tablename__ = "diagnoses"

    id = Column(Integer, primary_key=True, index=True)
    filename = Column(String, index=True)
    nama_pohon = Column(String)
    status = Column(String)
    jenis_penyakit = Column(String, nullable=True)
    penyebab = Column(String, nullable=True)
    saran_pengobatan = Column(String)
    gejala_visual = Column(Text, nullable=True)
    tingkat_keparahan = Column(String, nullable=True)
    potensi_penyebaran = Column(String, nullable=True)
    strategi_pencegahan = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class History(Base):
    __tablename__ = "histories"

    id = Column(Integer, primary_key=True, index=True)
    diagnosis_id = Column(Integer, index=True)
    lokasi = Column(String, nullable=True)
    waktu = Column(DateTime(timezone=True), server_default=func.now())
    petugas = Column(String, nullable=True)
    catatan = Column(Text, nullable=True)
    tindakan_lanjutan = Column(Text, nullable=True)
    status_penanganan = Column(String, nullable=True)
    foto_url = Column(String, nullable=True)
    is_resolved = Column(Boolean, default=False)

class Disease(Base):
    __tablename__ = "diseases"
    
    id = Column(Integer, primary_key=True, index=True)
    nama = Column(String, index=True)
    deskripsi = Column(Text, nullable=True)
    penyebab = Column(String, nullable=True)
    gejala = Column(Text, nullable=True)
    pengobatan = Column(Text, nullable=True)
    pencegahan = Column(Text, nullable=True)
    tingkat_keparahan = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Tracking(Base):
    __tablename__ = "trackings"
    
    id = Column(Integer, primary_key=True, index=True)
    pohon_id = Column(Integer, index=True)
    tanggal = Column(DateTime(timezone=True), server_default=func.now())
    tingkat_kesehatan = Column(Float)
    catatan = Column(Text, nullable=True)
    foto_url = Column(String, nullable=True)
    petugas = Column(String, nullable=True)
    lokasi = Column(String, nullable=True)
    tindakan = Column(Text, nullable=True)
