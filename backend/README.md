cd backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000

pip install -r requirements.txt

python -m model.train_model
python -c "from db.seed import run_all_seeds; run_all_seeds()"
