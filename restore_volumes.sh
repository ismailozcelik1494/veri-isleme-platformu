#!/bin/bash

echo "Docker volume yedekleri geri yükleniyor..."

# Önce tüm servisleri durdur
docker-compose down

# Ana volume'leri oluştur
docker volume create veri-isleme-platformu_postgres-db-volume
docker volume create veri-isleme-platformu_minio-data
docker volume create veri-isleme-platformu_pgadmin-data

# PostgreSQL volume'ü geri yükle
docker run --rm -v veri-isleme-platformu_postgres-db-volume:/volume -v "$(pwd)/backups/docker_volumes_backup:/backup" alpine sh -c "cd /volume && tar xzf /backup/ismailozcelik-docker_postgres-db-volume.tar.gz --strip-components=1"
echo "PostgreSQL volume geri yüklendi."

# MinIO volume'ü geri yükle
docker run --rm -v veri-isleme-platformu_minio-data:/volume -v "$(pwd)/backups/docker_volumes_backup:/backup" alpine sh -c "cd /volume && tar xzf /backup/ismailozcelik-docker_minio-data.tar.gz --strip-components=1"
echo "MinIO volume geri yüklendi."

# Airflow volume'ü geri yükle (eğer varsa)
if [ -f "$(pwd)/backups/docker_volumes_backup/ismailozcelik_airflow_data.tar.gz" ]; then
    docker volume create veri-isleme-platformu_airflow-data
    docker run --rm -v veri-isleme-platformu_airflow-data:/volume -v "$(pwd)/backups/docker_volumes_backup:/backup" alpine sh -c "cd /volume && tar xzf /backup/ismailozcelik_airflow_data.tar.gz --strip-components=1"
    echo "Airflow volume geri yüklendi."
fi

echo "Docker volume yedekleri geri yükleme işlemi tamamlandı."
echo "Docker Compose'u başlatabilirsiniz: docker-compose up -d"