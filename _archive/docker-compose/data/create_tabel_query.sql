--Docker kurulum yapıldıktan sonra yapılanlar. CMD ile
docker --version
docker-compose --version
mkdir ismailozcelik-docker
mkdir airflow-docker
cd airflow-docker
code . -- -vs code açılır
--new terminal denilerek işlemlere başlanır.
--google da airflow docker compose dökümantasyon incelenir.

curl 'https://airflow.apache.org/docs/apache-airflow/2.10.5/docker-compose.yaml' -o 'docker-compose.yaml' --denilerek airflow docker uyumlu versiyonlarına ait postgre sql servis
-- redis kütüphanesi, airflow-webserver, airflow-scheduler, airflow-worker, airflow-triggerer, airflow-init, airflow-cli, flower servislerinin docker ile uyumlu çalışcak şekilde kurulması sağlandı.

-- ana dizine airflow lar ile ilgili bazı yedekleme dosyaslının oluşturulması sağlandı. Bunlar airflow klasörü altında oluşturulabilir. Ben ana dizinde oluşturmuşum.
mkdir dags
mkdir logs
mkdir plugins

-- doxker a airlow kurulumu ve servisin çalıştırılması
docker compose up airflow-init
docker compose up

--docker da çalışan container ları listeler
docker ps

--docker da ki containerları durudurur
docker-compose down

--docker da ki container ları çalıştırır.
docker-compose up -d

--spark-master container a ait logları listeler
docker logs spark-master

-- airflow web servisin çalıştırılması arayüz ekranı
http://localhost:8081/

user: airflow
password: airflow

--postgre servisi kurulur iken iletilen dataların işlenmesi ve verilerin tutulması "postgres" adında bir veritabanı oluşturulması sağlanmıştır.
- ./init-db.sql:/docker-entrypoint-initdb.d/init-db.sql
- ./pgadmin-servers.json:/pgadmin4/pgadmin-servers.json

dosyalarında
--ardından yeni-docker-compose.yaml dosyası oluşturuldu. Burada ise pgadmin, spark-master, spark-worker, minio servislerinin docker a entegrasyonu ve container larının oluşması için gerekli
-- .ymal dosyası oluşturuldu ve çalıştırıldı.

--kurulumlar bittikten sonra oluşan servislerin URL listesi:
--PG Admin Giriş: 
http://localhost:5050/browser/
--Airlow Giriş:
http://localhost:8081/
--Spark Uygulaması giriş:
http://localhost:8082/
--Minio Servsisi giriş:
http://localhost:9001/browser
--Flask Api Giriş:
http://127.0.0.1:5000/results/5

--http://localhost:5050/browser/ ile pg admine girdik.
-- Create-Server diyerek yeni bir server ekledik. Bilgiler: 
-- Name: localhost
-- Host name/address: postgres
-- Port: 5432
-- Maintenance database: postgres
-- Username: airflow
-- Password: airflow

-- denilerek server a erişim sağlanır. Burada postgres veritabanında Tables bölümünde aşağıda ki kodlar ile tablolarımızı oluşturuyoruz.

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

--tabloları oluşturduktan sonra postgre sql de import ediyoruz tablolarımızı. country de sorun olmamıştı. Fakat person_data tablosu için temp_person_data adında bir tablo oluşturarak
-- verileri buraya aktardık. Ardında bozuk verileri düzelttik. Ondan aşağıda ki kod ile gereksiz aktarılan veriler sildik.

delete from public."temp_person_data" where "first_name" = 'first_name'
delete from public."country_data" where "country" = 'country'

-- ardında aşağıda ki kod ile bozuk verileri düzelttik.
SELECT birthday 
FROM temp_person_data 
WHERE NOT (birthday ~ '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' 
           AND SUBSTRING(birthday, 4, 2)::integer BETWEEN 1 AND 12);

-- aşağıda ki kod ile de düzeltilmiş verileri person_data tablosunda aktardık.
INSERT INTO person_data (first_name, last_name, birthday, blood_type, country)
SELECT first_name, last_name, TO_DATE(birthday, 'DD-MM-YYYY'), blood_type, country
FROM temp_person_data;

--spark için hadoop servisi çalıştıracak şekilde "spark-3.5.5-bin-hadoop3.tgz" dosyasını spark kütüphanesinin olduğu web sitesinden indiriyoruz.
-- C diskinde "hadoop" adında bir klasör ve onun altında da "bin" klasörü oluşturuyoruz. "spark-3.5.5-bin-hadoop3.tgz" dosyasında çıkan dosyaları buraya atıyoruz.
-- Sonrasında ise Başlat menüsünde Ayarlar kısmına gidiyoruz. Buradan "Sistem" e giriyoruz. Arama çubuğuna "Ortam Değişkenleri" diyoruz. "Gelişmiş-Ortam Değişkenleri" ne giriyoruz.
-- Yeni diyerek Değişken adına "HADOOP_HOME", Değerine ise "C:\hadoop" yazıp kaydediyoruz.

C:/spark/sbin/start-history-server.sh --properties-file C:/spark/conf/spark-defaults.conf

--airflow.fg de aşağıda ki satır değişti.
sql_alchemy_conn = postgresql+psycopg2://postgres:admin@localhost:5432/airflow_db
fernet_key = qveHqmEAl3DiKzy4c_bk0wazAGh3_khQSTFGJHAI1RU=

--hadoop için yetkiizinleri
mkdir C:\spark-events -Force
[System.Environment]::SetEnvironmentVariable("HADOOP_HOME", "C:\hadoop", "Machine")
$env:Path += ";C:\hadoop\bin"
icacls "C:\hadoop" /grant "Everyone:(OI)(CI)F" /T
icacls "C:\temp" /grant "Everyone:(OI)(CI)F" /T
icacls "C:\spark-events" /grant "Everyone:(OI)(CI)F" /T

--open jdk java yüklenmeli
docker cp postgres-container_analytcis:/var/lib/postgresql/data/pg_hba.conf ./pg_hba.conf
docker cp ./pg_hba.conf postgres-container_analytcis:/var/lib/postgresql/data/pg_hba.conf

--Python web sitesine giderek Pyhton-3.11 versiyonu indirip Path izinini ve users kullanıcılar için verilen izinleri işaretleyerek python kurulumunu tamamlıyoruz.
-- Ardından Path ayarları yapıyoruz. 
-- Yeni diyerek Değişken adına "PYSPARK_PYTHON", Değerine ise "C:\Python311" yazıp kaydediyoruz.
-- Yeni diyerek Değişken adına "SPARK_HOME", Değerine ise "C:\spark" yazıp kaydediyoruz. Ardından Path kısmını "Düzenle" deidiğimizde Yeni bir düzenleme ekranı açılıyor. Burada ise
-- C:\Program Files\Java\jdk-9.0.4\bin
-- C:\spark\bin
-- C:\Python311
-- C:\Python311\Scripts kısımlarını da ekliyoruz. var ise eklmenize gerek yoktur.

--Pyspark kurlumu için
PS D:\Profiles\ismailozcelik\Desktop\ismailozcelik-docker> pip install pyspark

--Jar dosyasını docker ortamına taşır.
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://ismailozcelik-docker-spark-master-1:7077 --jars "/opt/postgresql-42.7.5.jar" /tmp/spark_job.py

--Pyspark dosyasını docker ortamına taşır.
docker cp D:\Profiles\ismailozcelik\Desktop\ismailozcelik-docker\spark_job.py ismailozcelik-docker-spark-master-1:/tmp/

--tmp klsörünün altına taşınan spark_job.py kodumuzu aşağıda ki kod ile çalıştırıyoruz.
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://ismailozcelik-docker-spark-master-1:7077 /tmp/spark_job.py

--Airflow dosyasını docker ortamına taşır.
docker cp D:\Profiles\ismailozcelik\Desktop\ismailozcelik-docker\my_airflow_dag.py ismailozcelik-docker-airflow-webserver-1:/opt/airflow/dags/

-- Ardından ile çalıştırılır airflow. Bu sayede DAG kısmında jobun çalışması sağlanır.
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://d11336fbe563:7077 --conf "spark.ui.showConsoleProgress=true" --jars /tmp/postgresql-42.7.5.jar /tmp/spark_job.py

--ErrorHandling.py Hata Yönetimini dosyasını docker ortamına taşır.
docker cp D:\Profiles\ismailozcelik\Desktop\ismailozcelik-docker\error_handling.py ismailozcelik-docker-spark-master-1:/tmp/

--ErrorHandling.py Hata Yönetimini çalıştır.
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://ismailozcelik-docker-spark-master-1:7077 /tmp/error_handling.py

-- veritabanı optimizasyonu için db_index_query.sql dosyasında ki kodlar çalıştılarak İndexleme yapılıyor.

CREATE INDEX idx_birthday ON person_data(birthday);
CREATE INDEX idx_blood_type ON person_data(blood_type);
CREATE INDEX idx_country ON person_data(country);

--MinIO servisi için
-- data-bucket.py dosyasını docker ortamına taşır.
docker cp D:\Profiles\ismailozcelik\Desktop\ismailozcelik-docker\data-bucket.py ismailozcelik-docker-spark-master-1:/tmp/

-- data-bucket.py dosyasını çalıştırır.
docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master spark://ismailozcelik-docker-spark-master-1:7077 /tmp/data-bucket.py

-- Ardndan veriler API ile dışarıya aktarılması için aşağıda ki işlemler yapılıyor.
--flask_app.py dosyası için kütüphane indirme
pip install flask
pip install psycopg2-binary
pip install psycopg2

--kütüphaneleri görme
pip show flask
pip show psycopg2
pip show psycopg2-binary
python -m pip install psycopg2-binary

--python da flask_app.py çalıştırıyoruz. Aşağıda ki URL girdiğimizde tarayıca da ilgili ülkeye ait olan verileri bize listelemiş olacak.
http://127.0.0.1:5000/results/5

--manuel spark-master ekleme
docker run -d --name spark-worker-1 --network ismailozcelik-docker_default -e SPARK_MODE=worker -e SPARK_MASTER_URL=spark://ismailozcelik-docker-spark-master-1:7077 -e SPARK_WORKER_MEMORY=1G -e SPARK_WORKER_CORES=1  bitnami/spark:latest

docker network ls

docker exec -it ismailozcelik-docker-spark-master-1 spark-submit --master local[*] /tmp/data-bucket.py