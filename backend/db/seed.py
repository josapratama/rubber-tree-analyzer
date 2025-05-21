from .seed_diseases import seed_diseases
from .seed_tracking import seed_tracking

def run_all_seeds():
    print("Mulai seeding database...")
    seed_diseases()
    seed_tracking()
    # Tambahkan fungsi seed lainnya di sini jika diperlukan
    print("Seeding database selesai!")

if __name__ == "__main__":
    run_all_seeds()