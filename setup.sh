#!/bin/bash

echo "Veri Platformu kurulumu başlatılıyor..."

# Gerekli dizinleri oluştur (eğer yoksa)
mkdir -p dags logs plugins config

# Dizin izinlerini ayarla
chmod -R 777 dags logs plugins config

# .env dosyasını oluştur (yoksa)
if [ ! -f .env ]; then
  echo "AIRFLOW_UID=$(id -u)" > .env
  echo "_AIRFLOW_WWW_USER_USERNAME=airflow" >> .env
  echo "_AIRFLOW_WWW_USER_PASSWORD=airflow" >> .env
else
  echo ".env dosyası zaten mevcut."
fi

# Docker Compose ile platformu başlat
docker-compose down  # Önce mevcut container'ları durdur
docker-compose up -d

echo "Kurulum tamamlandı!"
echo "Erişim bilgileri:"
echo "Airflow UI: http://localhost:8081 (kullanıcı/şifre: airflow/airflow)"
echo "Spark Master UI: http://localhost:8082"
echo "MinIO Console: http://localhost:9001 (kullanıcı/şifre: minioadmin/minioadmin)"
echo "PgAdmin: http://localhost:5050 (kullanıcı/şifre: admin@admin.com/admin)"