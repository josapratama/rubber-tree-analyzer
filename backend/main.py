from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from db import models, database
from api.routes import router

# Inisialisasi database
models.Base.metadata.create_all(bind=database.engine)

# Inisialisasi aplikasi
app = FastAPI()

# Konfigurasi CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Tambahkan router API
app.include_router(router)

# Jika dijalankan langsung
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
