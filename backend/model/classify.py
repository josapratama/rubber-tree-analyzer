import cv2
import numpy as np
from io import BytesIO
from PIL import Image
import os
import tensorflow as tf
import logging

# Path ke model yang sudah dilatih
MODEL_PATH = os.path.join(os.path.dirname(__file__), "model.h5")

# Cek apakah model sudah ada, jika belum gunakan metode sederhana
if os.path.exists(MODEL_PATH):
    model = tf.keras.models.load_model(MODEL_PATH)
    
    # Konfigurasi logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    def analyze_image(image_bytes: bytes) -> tuple:
        try:
            # Buka gambar dan konversi ke format yang sesuai
            image = Image.open(BytesIO(image_bytes)).convert("RGB")
            img = np.array(image)
            img = cv2.resize(img, (224, 224))
            img = img / 255.0  # Normalisasi
            
            # Log ukuran dan statistik gambar
            logger.info(f"Image shape: {img.shape}, mean: {np.mean(img):.4f}, std: {np.std(img):.4f}")
            
            # Prediksi menggunakan model
            img_array = np.expand_dims(img, axis=0)
            prediction = model.predict(img_array)[0][0]
            
            logger.info(f"Raw prediction: {prediction:.6f}")
            
            # Hitung confidence score (0-1)
            confidence = prediction if prediction >= 0.5 else 1 - prediction
            
            # Klasifikasi berdasarkan threshold
            if prediction < 0.5:
                status = "Sehat"
            else:
                status = "Tidak Sehat"
            
            # Untuk saat ini, kita hanya memiliki kategori daun
            part = "daun"
            
            logger.info(f"Final classification: {status}, confidence: {confidence:.4f}")
                
            return status, confidence, part
        except Exception as e:
            logger.error(f"Error in analyze_image: {str(e)}")
            raise
else:
    # Metode sederhana jika model belum ada
    def analyze_image(image_bytes: bytes) -> tuple:
        image = Image.open(BytesIO(image_bytes)).convert("RGB")
        img = np.array(image)
        img = cv2.resize(img, (100, 100))

        # Analisis warna dominan
        avg_color = np.mean(img, axis=(0, 1))
        r, g, b = avg_color

        # Klasifikasi sederhana berdasarkan warna dominan
        if g > r and g > b:
            confidence = min(1.0, g / (r + b + 1) * 0.8)  # Hitung confidence berdasarkan dominasi warna hijau
            return "Sehat", confidence, "daun"
        else:
            confidence = min(1.0, (r + b) / (g + 1) * 0.7)  # Hitung confidence untuk daun tidak sehat
            return "Tidak Sehat", confidence, "daun"
