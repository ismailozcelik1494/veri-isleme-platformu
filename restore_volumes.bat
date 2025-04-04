@echo off
echo Docker volume yedekleri geri yukleniyor...

REM Önce tüm servisleri durdur
docker-compose down

REM Ana volume'leri oluştur
docker volume create veri-isleme-platformu_postgres-db-volume
docker volume create veri-isleme-platformu_minio-data
docker volume create veri-isleme-platformu_pgadmin-data

REM PostgreSQL volume'ü geri yükle
docker run --rm -v veri-isleme-platformu_postgres-db-volume:/volume -v "%cd%\backups\docker_volumes_backup:/backup" alpine sh -c "cd /volume && tar xzf /backup/ismailozcelik-docker_postgres-db-volume.tar.gz --strip-components=1"
echo PostgreSQL volume geri yuklendi.

REM MinIO volume'ü geri yükle
docker run --rm -v veri-isleme-platformu_minio-data:/volume -v "%cd%\backups\docker_volumes_backup:/backup" alpine sh -c "cd /volume && tar xzf /backup/ismailozcelik-docker_minio-data.tar.gz --strip-components=1"
echo MinIO volume geri yuklendi.

REM Airflow volume'ü geri yükle (eğer varsa)
IF EXIST "%cd%\backups\docker_volumes_backup\ismailozcelik_airflow_data.tar.gz" (
    docker volume create veri-isleme-platformu_airflow-data
    docker run --rm -v veri-isleme-platformu_airflow-data:/volume -v "%cd%\backups\docker_volumes_backup:/backup" alpine sh -c "cd /volume && tar xzf /backup/ismailozcelik_airflow_data.tar.gz --strip-components=1"
    echo Airflow volume geri yuklendi.
)

echo Docker volume yedekleri geri yukleme islemi tamamlandi.
echo Docker Compose'u baslatabilirsiniz: docker-compose up -d