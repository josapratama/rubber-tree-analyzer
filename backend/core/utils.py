import json
import os

def load_reference_data():
    """
    Memuat data referensi pohon karet dari file JSON.
    
    Returns:
        list: Data referensi pohon karet
    """
    try:
        with open("data/data_pohon_karet.json", "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading reference data: {e}")
        return []