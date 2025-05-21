import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.models import Model
import os
import matplotlib.pyplot as plt
import numpy as np

# Direktori untuk data pelatihan
# Struktur direktori:
# data/
#   train/
#     daun/
#       image1.jpg
#       image2.jpg
#       ...
#   validation/
#     daun/
#       ...

# Konfigurasi
BATCH_SIZE = 16  # Mengurangi batch size karena data lebih sedikit
IMG_SIZE = (224, 224)
EPOCHS = 10  # Mengurangi jumlah epoch untuk uji coba awal
TRAIN_DIR = "data/train"
VAL_DIR = "data/valid"

# Cek apakah direktori data ada
if not os.path.exists(TRAIN_DIR) or not os.path.exists(VAL_DIR):
    print("Direktori data tidak ditemukan. Buat struktur direktori berikut:")
    print("data/train/daun/")
    print("data/valid/daun/")
    print("Dan tambahkan gambar ke setiap folder kategori")
    exit(1)

# Data augmentation untuk training
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    brightness_range=[0.8, 1.2],
    fill_mode='nearest',
    validation_split=0.2  # Tambahkan validation split jika data validasi kurang
)

# Hanya rescaling untuk validation
val_datagen = ImageDataGenerator(rescale=1./255)

# Load data - hanya menggunakan folder daun
train_generator = train_datagen.flow_from_directory(
    TRAIN_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary',  # Ubah ke binary untuk klasifikasi biner
    classes=['daun'],  # Hanya gunakan folder daun
    shuffle=True
)

validation_generator = val_datagen.flow_from_directory(
    VAL_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary',  # Ubah ke binary untuk klasifikasi biner
    classes=['daun']  # Hanya gunakan folder daun
)

# Buat model dengan MobileNetV2 sebagai base model
base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))

# Freeze base model
for layer in base_model.layers:
    layer.trainable = False

# Tambahkan layer klasifikasi
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(64, activation='relu')(x)  # Kurangi jumlah neuron
x = tf.keras.layers.Dropout(0.5)(x)  # Tambahkan dropout untuk mengurangi overfitting
predictions = Dense(1, activation='sigmoid')(x)  # 1 output untuk klasifikasi biner

# Model final
model = Model(inputs=base_model.input, outputs=predictions)

# Compile model
model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
    loss='binary_crossentropy',  # Ubah ke binary crossentropy
    metrics=['accuracy']
)

# Callback untuk early stopping
early_stopping = tf.keras.callbacks.EarlyStopping(
    monitor='val_loss',
    patience=3,  # Kurangi patience untuk uji coba awal
    restore_best_weights=True
)

# Train model
history = model.fit(
    train_generator,
    steps_per_epoch=max(1, train_generator.samples // BATCH_SIZE),
    epochs=EPOCHS,
    validation_data=validation_generator,
    validation_steps=max(1, validation_generator.samples // BATCH_SIZE),
    callbacks=[early_stopping]
)

# Simpan model
model_save_path = os.path.join(os.path.dirname(__file__), "model.h5")
model.save(model_save_path)
print(f"Model berhasil disimpan sebagai '{model_save_path}'")

# Evaluasi model
val_loss, val_acc = model.evaluate(validation_generator)
print(f"Validation accuracy: {val_acc:.4f}")
print(f"Validation loss: {val_loss:.4f}")

# Plot hasil training
plt.figure(figsize=(12, 4))
plt.subplot(1, 2, 1)
plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.title('Model Accuracy')
plt.ylabel('Accuracy')
plt.xlabel('Epoch')
plt.legend(['Train', 'Validation'], loc='upper left')

plt.subplot(1, 2, 2)
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('Model Loss')
plt.ylabel('Loss')
plt.xlabel('Epoch')
plt.legend(['Train', 'Validation'], loc='upper left')

plt.savefig(os.path.join(os.path.dirname(__file__), 'training_history.png'))
plt.close()

# Tampilkan beberapa prediksi pada data validasi
plt.figure(figsize=(10, 10))
for images, labels in validation_generator:
    predictions = model.predict(images)
    
    for i in range(min(9, len(images))):
        plt.subplot(3, 3, i+1)
        plt.imshow(images[i])
        predicted = "Sehat" if predictions[i] < 0.5 else "Tidak Sehat"
        true_label = "Sehat" if labels[i] < 0.5 else "Tidak Sehat"
        color = 'green' if predicted == true_label else 'red'
        title = f"True: {true_label}\nPred: {predicted}"
        plt.title(title, color=color)
        plt.axis('off')
    
    plt.savefig(os.path.join(os.path.dirname(__file__), 'validation_predictions.png'))
    break  # Hanya tampilkan batch pertama