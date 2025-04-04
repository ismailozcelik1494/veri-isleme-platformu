@echo off
echo Veri Platformu kurulumu basliyor...

:: Gerekli dizinleri olustur (yoksa)
if not exist dags mkdir dags
if not exist logs mkdir logs
if not exist plugins mkdir plugins
if not exist config mkdir config

:: .env dosyasini olustur (yoksa)
if not exist .env (
  echo AIRFLOW_UID=50000 > .env
  echo _AIRFLOW_WWW_USER_USERNAME=airflow >> .env
  echo _AIRFLOW_WWW_USER_PASSWORD=airflow >> .env
) else (
  echo .env dosyasi zaten mevcut.
)

:: Docker Compose ile platformu baslat
docker-compose down
docker-compose up -d

echo Kurulum tamamlandi!
echo Erisim bilgileri:
echo Airflow UI: http://localhost:8081 (kullanici/sifre: airflow/airflow)
echo Spark Master UI: http://localhost:8082
echo MinIO Console: http://localhost:9001 (kullanici/sifre: minioadmin/minioadmin)
echo PgAdmin: http://localhost:5050 (kullanici/sifre: admin@admin.com/admin)