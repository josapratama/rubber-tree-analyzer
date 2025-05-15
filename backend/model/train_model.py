import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.models import Model
import os

# Direktori untuk data pelatihan
# Struktur direktori:
# data/
#   train/
#     hijau/
#       image1.jpg
#       image2.jpg
#       ...
#     kuning/
#       image1.jpg
#       ...
#     biru/
#       ...
#     tidak_jelas/
#       ...
#   validation/
#     hijau/
#       ...
#     kuning/
#       ...
#     biru/
#       ...
#     tidak_jelas/
#       ...

# Konfigurasi
BATCH_SIZE = 32
IMG_SIZE = (224, 224)
EPOCHS = 10
TRAIN_DIR = "data/train"
VAL_DIR = "data/validation"

# Cek apakah direktori data ada
if not os.path.exists(TRAIN_DIR) or not os.path.exists(VAL_DIR):
    print("Direktori data tidak ditemukan. Buat struktur direktori berikut:")
    print("data/train/[hijau,kuning,biru,tidak_jelas]")
    print("data/validation/[hijau,kuning,biru,tidak_jelas]")
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
    fill_mode='nearest'
)

# Hanya rescaling untuk validation
val_datagen = ImageDataGenerator(rescale=1./255)

# Load data
train_generator = train_datagen.flow_from_directory(
    TRAIN_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

validation_generator = val_datagen.flow_from_directory(
    VAL_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

# Buat model dengan MobileNetV2 sebagai base model
base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))

# Freeze base model
for layer in base_model.layers:
    layer.trainable = False

# Tambahkan layer klasifikasi
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(128, activation='relu')(x)
predictions = Dense(4, activation='softmax')(x)  # 4 kelas: hijau, kuning, biru, tidak_jelas

# Model final
model = Model(inputs=base_model.input, outputs=predictions)

# Compile model
model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

# Train model
history = model.fit(
    train_generator,
    steps_per_epoch=train_generator.samples // BATCH_SIZE,
    epochs=EPOCHS,
    validation_data=validation_generator,
    validation_steps=validation_generator.samples // BATCH_SIZE
)

# Simpan model
model.save('model.h5')
print("Model berhasil disimpan sebagai 'model.h5'")

# Evaluasi model
val_loss, val_acc = model.evaluate(validation_generator)
print(f"Validation accuracy: {val_acc:.4f}")
print(f"Validation loss: {val_loss:.4f}")