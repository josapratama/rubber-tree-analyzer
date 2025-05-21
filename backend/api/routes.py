from fastapi import APIRouter
from api.endpoints import analyze, diagnosis, disease, tracking

# Inisialisasi router
router = APIRouter()

# Tambahkan router dari endpoints
router.include_router(analyze.router, tags=["analyze"])
router.include_router(diagnosis.router, tags=["diagnosis"])
router.include_router(disease.router, tags=["disease"])
router.include_router(tracking.router, tags=["tracking"])