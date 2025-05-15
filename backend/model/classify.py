import cv2
import numpy as np
from io import BytesIO
from PIL import Image
import os
import tensorflow as tf

# Path ke model yang sudah dilatih (akan dibuat nanti)
MODEL_PATH = os.path.join(os.path.dirname(__file__), "model.h5")

# Cek apakah model sudah ada, jika belum gunakan metode sederhana
if os.path.exists(MODEL_PATH):
    model = tf.keras.models.load_model(MODEL_PATH)
    class_names = ["hijau", "kuning", "biru", "tidak_jelas"]
    
    def analyze_image(image_bytes: bytes) -> tuple:
        # Buka gambar dan konversi ke format yang sesuai
        image = Image.open(BytesIO(image_bytes)).convert("RGB")
        img = np.array(image)
        img = cv2.resize(img, (224, 224))
        img = img / 255.0  # Normalisasi
        
        # Prediksi menggunakan model
        img_array = np.expand_dims(img, axis=0)
        predictions = model.predict(img_array)
        predicted_class = np.argmax(predictions[0])
        label = class_names[predicted_class]
        
        # Tentukan bagian pohon berdasarkan label
        if label == "hijau":
            part = "daun"
        elif label == "kuning":
            part = "batang"
        elif label == "biru":
            part = "akar"
        else:
            part = "tidak_dikenal"
            
        return label, part
else:
    # Metode sederhana jika model belum ada
    def analyze_image(image_bytes: bytes) -> tuple:
        image = Image.open(BytesIO(image_bytes)).convert("RGB")
        img = np.array(image)
        img = cv2.resize(img, (100, 100))

        avg_color = np.mean(img, axis=(0, 1))
        r, g, b = avg_color

        if g > r and g > b:
            return "hijau", "daun"
        elif r > 200 and g > 200:
            return "kuning", "batang"
        elif b > 180:
            return "biru", "akar"
        else:
            return "tidak_jelas", "tidak_dikenal"
