from sqlalchemy.orm import Session
from .database import SessionLocal
from .models import Tracking
from datetime import datetime, timedelta
import random

def seed_tracking():
    db = SessionLocal()
    try:
        # Periksa apakah data sudah ada
        existing_count = db.query(Tracking).count()
        if existing_count > 0:
            print(f"Database sudah berisi {existing_count} data tracking. Lewati seeding.")
            return
        
        # Buat data tracking dummy untuk beberapa pohon
        pohon_ids = [1, 2, 3]  # Anggap ini ID pohon yang sudah ada
        petugas_list = ["Ahmad", "Budi", "Cindy", "Dodi"]
        lokasi_list = ["Blok A", "Blok B", "Blok C", "Blok D"]
        tindakan_list = [
            "Pemupukan NPK",
            "Penyemprotan fungisida",
            "Pembersihan gulma",
            "Pemangkasan cabang",
            "Aplikasi hormon",
            "Pengendalian hama"
        ]
        
        tracking_data = []
        
        # Buat data untuk 3 bulan terakhir
        now = datetime.now()
        for pohon_id in pohon_ids:
            # Kondisi awal kesehatan
            health = random.randint(60, 90)
            
            # Buat data setiap 10 hari selama 3 bulan
            for i in range(9):  # 9 entri per pohon (90 hari / 10)
                date = now - timedelta(days=90-i*10)
                
                # Variasi kesehatan
                health_change = random.randint(-15, 15)
                health = max(10, min(100, health + health_change))  # Batasi antara 10-100
                
                tracking = {
                    "pohon_id": pohon_id,
                    "tanggal": date,
                    "tingkat_kesehatan": health,
                    "petugas": random.choice(petugas_list),
                    "lokasi": random.choice(lokasi_list),
                    "tindakan": random.choice(tindakan_list),
                    "catatan": f"Pemeriksaan rutin pohon ID {pohon_id}. Kondisi {['buruk', 'cukup', 'baik'][min(2, health//40)]}."
                }
                tracking_data.append(tracking)
        
        # Tambahkan data ke database
        for data in tracking_data:
            tracking = Tracking(**data)
            db.add(tracking)
        
        db.commit()
        print(f"Berhasil menambahkan {len(tracking_data)} data tracking ke database.")
    
    except Exception as e:
        db.rollback()
        print(f"Error saat seeding data tracking: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_tracking()