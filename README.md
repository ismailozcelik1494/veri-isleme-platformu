# 🚀 Veri İşleme ve Analiz Platformu

Bu proje, Docker konteynerlerinde çalışan Apache Airflow, Apache Spark, Redis, PostgreSQL ve MinIO servislerini entegre eden kapsamlı bir veri işleme altyapısı sunar. Senior Software Engineer pozisyonu için teknik mülakat gereksinimlerini karşılamak için oluşturulmuş olup, özellikle yaş ve kan grubu kriterleri üzerinden veri analizi yapan ve bu verileri otomatik olarak işleyen bir sistem sunmaktadır.

## 📋 Özellikler

- **Apache Airflow** ile iş akışı otomasyonu ve periyodik görev çalıştırma (her 10 dakikada bir)
- **Apache Spark** ile paralel ve dağıtık veri işleme
- **PostgreSQL** veritabanı entegrasyonu ve veri depolama
- **MinIO** nesne depolama servisi
- **Docker Compose** ile mikroservis mimarisi
- Otomatik veri işleme ve filtreleme (yaş, kan grubu)
- Veri doğrulama ve hata yönetimi
- **Flask** ile RESTful API implementasyonu
- Veritabanı performans optimizasyonu (indeksleme)
- PgAdmin ile veritabanı yönetimi

## 🔧 Sistem Gereksinimleri

- Docker ve Docker Compose
- Python 3.11+
- Java JDK (Spark için gerekli)
- En az 8GB RAM (tüm servislerin sağlıklı çalışması için)
- 15-20GB disk alanı

## 📁 Proje Yapısı

```
ISMAILOZCELIK-DOCKER/
├── _archive/                               # Arşivlenmiş eski dosyalar
|   |__ dependencies
│   |   ├── __pycache__/                   # Python için gerekli kütüphaneler
│   |   ├── abseil-cpp-master/             # Google'ın C++ utility kütüphanesi
│   |   └── re2-main/                      # Google'ın RE2 regex kütüphanesi
|   |── docker-compose/                    # Docker Compose yapılandırmaları
│   |   └── data/                          # Örnek veri dosyaları
│   |   |   ├── country_data.csv           # Ülke verileri
│   |   |   ├── create_table_query.sql     # Tablo oluşturma SQL sorguları
│   |   |   ├── db_index_query.sql         # Indexleme SQL sorguları
│   |   |   ├── person_data.csv            # Kişi verileri
│   |   |   └── ...
|   |   ├── docker-compose.yaml
|   |   ├── pg_hba.conf                    # PostgreSQL erişim yapılandırması
|   |   └── yeni-docker-compose.yaml
|   └── old-setups/
│       └── jdk-9.0.4_windows-x64_bin.exe 
│
├── airflow/                                # Airflow ile ilgili dosyalar (mevcut konumunda)
│
├── app/                                    # Ek Paketler ve Python kodları içerir.
│   ├── hadoop/                             # Hadoop için gerekli kütüphane dosyaları
│   ├── java/                               # Java için gerekli kütüphane dosyaları
│   └── python/                             # Python kodları
│       ├── airflow_create_user.py          # Airflow kullanıcı oluşturma
│       ├── data-bucket.py                  # .csv dosyalarını Minio'da aktarma için
│       ├── error_handling.py               # Hata yönetimi ve veri doğrulama
│       ├── fernet.py                       # Fernet anahtar yönetimi (güvenlik)
│       ├── istemci.py                      # Yardımcı betik
│       ├── my_airflow_dag.py               # Spark işini çalıştıran Airflow DAG
│       ├── rest_api.py                     # REST API modülü
│       ├── spark_job.py                    # Spark veri işleme betiği
│       ├── sunucu.py                       # Sunucu kontrolü sağlayan betik
│       └── test_app.py                     # Spark login işlemi sağlayan betik
│
├── backups/                                # Yedekleme
│   └── docker_volumes_backup/              # Docker yedeklemeleri
│
├── config/                                 # Yapılandırma dosyaları
│
├── dags/                                   # Airflow DAG'ları
│   ├── __pycache__/                        # Python önbellek dosyaları
│   |   ├── my_airflow_dag.cpython-312.pyc
│   └── my_airflow_dag.py                   # Spark işini çalıştıran Airflow DAG
|
├── logs/                        # Log dosyaları
│   ├── dag_id=spark_processing/ # Spark işleme görevleri ile ilgili loglar
│   ├── dag_processor_manager/   # DAG processor yöneticisi logları
│   └── scheduler/               # Scheduler logları
│
├── plugins/                      # Airflow eklentileri
|
├── .env                          # Çevre değişkenleri
│
├── docker-compose.yaml           # Ana docker-compose dosyası (birleştirilmiş)
│
├── dockerfile.dockerfile         # Özel Dockerfile
│
├── flask_app.py                  # Flask uygulamasını çalıştırmak için gerekli kodları içerir.
│
├── init-db.sql                   # PostgreSQL başlangıç script'i
│
├── pgadmin-servers.json          # PgAdmin yapılandırması
│
├── README.md                     # Dökümantasyon
│
├── setup.bat                     # Başlama Betiği(Windows için)
│
└── setup.sh                      # Başlama Betiği(Mac/Linux için)

```

## 🚀 Kurulum ve Çalıştırma

### 1. Ön Gereksinimler

Docker ve Docker Compose kurulumunuzu kontrol edin:
```bash
docker --version
docker-compose --version
```

### 2. Proje Dizini Oluşturma ve Dosyaları Hazırlama
```bash
mkdir ismailozcelik-docker
cd ismailozcelik-docker
```

### 3. Docker Compose ile Airflow Kurulumu

Airflow Docker Compose dosyasını indirin:
```bash
curl 'https://airflow.apache.org/docs/apache-airflow/2.10.5/docker-compose.yaml' -o 'docker-compose.yaml'
```

Gerekli dizinleri oluşturun:
```bash
mkdir dags logs plugins
```

### 4. Airflow Servislerini Başlatma

```bash
# Airflow'u başlatın
docker compose up airflow-init
docker compose up -d
```

### 5. Yeni Docker Compose Dosyası ile Ek Servisleri Başlatma

Yeni servisleri (PgAdmin, Spark Master, Spark Worker, MinIO) içeren yeni-docker-compose.yaml dosyasını çalıştırın:
```bash
docker-compose -f yeni-docker-compose.yaml up -d
```

### 6. Servislere Erişim Bilgileri

| Servis | URL | Kullanıcı | Şifre |
|--------|-----|-----------|-------|
| PgAdmin | http://localhost:5050/browser/ | airflow | airflow |
| Airflow | http://localhost:8081/ | airflow | airflow |
| MinIO | http://localhost:9001/browser | minioadmin | minioadmin |
| Spark UI | http://localhost:8082/ | - | - |
| Flask API | http://127.0.0.1:5000/results/[country_id] | - | - |

### 7. PostgreSQL Veritabanı Kurulumu

PgAdmin'e giriş yapın ve yeni bir server ekleyin:
- Name: localhost
- Host name/address: postgres
- Port: 5432
- Maintenance database: postgres
- Username: airflow
- Password: airflow

### 8. Veritabanı Tablolarını Oluşturma

PgAdmin'de aşağıdaki SQL sorgularını çalıştırın:

```sql
CREATE TABLE country_data (
    country VARCHAR(10) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE person_data (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birthday DATE,
    blood_type VARCHAR(10),
    country VARCHAR(10) REFERENCES country_data(country) ON DELETE SET NULL
);

CREATE TABLE temp_person_data (
    first_name VARCHAR(250),
    last_name VARCHAR(250),
    birthday TEXT,
    blood_type VARCHAR(100),
    country VARCHAR(250)
);
```

### 9. Veri Yükleme ve Temizleme

CSV verilerini PostgreSQL'e yükledikten sonra, gereksiz verileri temizleyin:
```sql
-- Başlık satırlarını sil
DELETE FROM public.temp_person_data WHERE first_name = 'first_name';
DELETE FROM public.country_data WHERE country = 'country';

-- Bozuk tarih formatlarını kontrol et
SELECT birthday 
FROM temp_person_data 
WHERE NOT (birthday ~ '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' 
           AND SUBSTRING(birthday, 4, 2)::integer BETWEEN 1 AND 12);

-- Düzeltilmiş verileri ana tabloya aktar
INSERT INTO person_data (first_name, last_name, birthday, blood_type, country)
SELECT first_name, last_name, TO_DATE(birthday, 'DD-MM-YYYY'), blood_type, country
FROM temp_person_data;
```

### 10. Spark Job'unu Konteynere Kopyalama ve Çalıştırma

```bash
# PostgreSQL JDBC sürücüsünü kopyalama
docker cp ./postgresql-42.7.5.jar ismailozcelik-docker-spark-master-1:/tmp/

# Spark işleme dosyasını kopyalama
docker cp ./spark_job.py ismailozcelik-docker-spark-master-1:/tmp/

# Spark job'unu çalıştırma
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://ismailozcelik-docker-spark-master-1:7077 --jars "/tmp/postgresql-42.7.5.jar" /tmp/spark_job.py
```

### 11. Airflow DAG Dosyasını Konteynere Kopyalama

```bash
docker cp ./my_airflow_dag.py ismailozcelik-docker-airflow-webserver-1:/opt/airflow/dags/
```

### 12. Hata Yönetimi Dosyasını Konteynere Kopyalama

```bash
docker cp ./error_handling.py ismailozcelik-docker-spark-master-1:/tmp/
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://ismailozcelik-docker-spark-master-1:7077 /tmp/error_handling.py
```

### 13. Veritabanı Optimizasyonu

PgAdmin'de aşağıdaki indeksleme sorgularını çalıştırın:
```sql
CREATE INDEX idx_birthday ON person_data(birthday);
CREATE INDEX idx_blood_type ON person_data(blood_type);
CREATE INDEX idx_country ON person_data(country);
```

### 14. Flask API'sini Başlatma

Gerekli Python kütüphanelerini kurun:
```bash
pip install flask
pip install psycopg2-binary
```

Flask uygulamasını çalıştırın:
```bash
python flask_app.py
```

## 📊 Veri İşleme Detayları

### Spark İşleme İş Akışı

1. **Veri Okuma**: PostgreSQL'den `person_data` ve `country_data` tablolarındaki veriler okunur.
2. **Filtreleme**: Veriler aşağıdaki kriterlere göre filtrelenir:
   - Yaşı 30'dan büyük olan kişiler
   - Kan grubu 'A+', 'A-', 'AB+' veya 'AB-' olan kişiler
3. **Gruplama ve Birleştirme**: Her ülke için bu kriterlere uyan kişilerin isimleri birleştirilir.
4. **Sonuç Yazma**: İşlenmiş veriler `processed_results` tablosuna kaydedilir.

### Airflow DAG Açıklaması

Airflow DAG'ı, Spark işini her 10 dakikada bir çalıştıracak şekilde yapılandırılmıştır. DAG yapılandırması şu şekildedir:

```python
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG('spark_processing', default_args=default_args, schedule_interval='*/10 * * * *')

spark_job = BashOperator(
    task_id='run_spark_job',
    bash_command='spark-submit --master spark://d11336fbe563:7077 --conf "spark.ui.showConsoleProgress=true" --jars /tmp/postgresql-42.7.5.jar /tmp/spark_job.py',
    dag=dag,
)
```

## 🛠️ Hata Yönetimi ve Veri Doğrulama

Hata yönetimi aşağıdaki durumları kontrol eder:

1. **Eksik Veri Kontrolü**: NULL değerleri tespit edilir
2. **Format Doğrulama**: Tarih formatı, yaş değerleri gibi alanların doğruluğu kontrol edilir
3. **Bozuk Veri Tespiti**: Yanlış formatlar filtrelenir (örn. geçersiz tarihler)
4. **Hata Loglaması**: Hatalar error_logs tablosuna kaydedilir

## 🌐 REST API Ayrıntıları

Flask API, processed_results tablosundaki verileri JSON formatında sunar:

**Endpoint**:
```
GET /results/<country_id>
http://127.0.0.1:5000/results/9
```

**Örnek Yanıt**:
```json
[
  [
    "10",
    "Birol, Nurgün, Ayliz"
  ]
]
```

## 🧪 Yerel Geliştirme Ortamı

### Hadoop ve Spark için Yerel Ortam Ayarları

1. Spark indirin (spark-3.5.5-bin-hadoop3.tgz)
2. Hadoop dizinlerini oluşturun:
```bash
mkdir C:\hadoop
mkdir C:\hadoop\bin
```

3. Ortam değişkenlerini ayarlayın:
```bash
# Windows Ortam Değişkenleri
HADOOP_HOME = C:\hadoop
PYSPARK_PYTHON = C:\Python311
SPARK_HOME = C:\spark
```

4. PATH değişkenine ekleyin:
```
C:\Program Files\Java\jdk-9.0.4\bin
C:\spark\bin
C:\Python311
C:\Python311\Scripts
```

5. Hadoop için dizin izinlerini ayarlayın:
```powershell
mkdir C:\spark-events -Force
icacls "C:\hadoop" /grant "Everyone:(OI)(CI)F" /T
icacls "C:\temp" /grant "Everyone:(OI)(CI)F" /T
icacls "C:\spark-events" /grant "Everyone:(OI)(CI)F" /T
```

## 🔍 Sorun Giderme

### Docker Konteynerlerini Listeleme
```bash
docker ps
```

### Docker Konteynerlerini Durdurma
```bash
docker-compose down
```

### Log Dosyalarını İnceleme
```bash
docker logs spark-master
```

### PostgreSQL Yapılandırmasını Değiştirme
```bash
docker cp postgres-container_analytcis:/var/lib/postgresql/data/pg_hba.conf ./pg_hba.conf
docker cp ./pg_hba.conf postgres-container_analytcis:/var/lib/postgresql/data/pg_hba.conf
```

### Kütüphane Versiyonlarını Kontrol Etme
```bash
pip show flask
pip show psycopg2
pip show psycopg2-binary
```

## 📝 Önemli Notlar

1. Docker servislerinin doğru çalıştığından emin olun
2. Airflow DAG'ının aktif olduğundan emin olun
3. PostgreSQL JDBC sürücüsünün (`postgresql-42.7.5.jar`) doğru yerde olduğunu kontrol edin
4. Veri aktarımından önce CSV dosyalarının formatını doğrulayın
5. API'yi test etmek için farklı country_id değerleri deneyin

---

## 📦 Referanslar ve Kaynaklar

- [Apache Airflow Dokümantasyonu](https://airflow.apache.org/docs/)
- [Apache Spark Dokümantasyonu](https://spark.apache.org/docs/latest/)
- [PostgreSQL Dokümantasyonu](https://www.postgresql.org/docs/)
- [MinIO Dokümantasyonu](https://min.io/docs/minio/container/index.html)
- [Flask Dokümantasyonu](https://flask.palletsprojects.com/)
- [Docker Dokümantasyonu](https://docs.docker.com/)