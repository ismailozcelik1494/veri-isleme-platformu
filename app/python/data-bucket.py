from pyspark.sql import SparkSession
from datetime import datetime
import time

# MinIO bağlantı bilgileri
# MINIO_HOST = "ismailozcelik-docker-minio-1"  # veya IP adresi kullanın
MINIO_HOST = "172.18.0.5"  # MinIO konteynerinin IP adresi
MINIO_PORT = "9000"  # API port
MINIO_ACCESS_KEY = "minioadmin"
MINIO_SECRET_KEY = "minioadmin"

# Detaylı loglama
print(f"MinIO Host: {MINIO_HOST}")
print(f"MinIO Port: {MINIO_PORT}")
print(f"MinIO Endpoint: http://{MINIO_HOST}:{MINIO_PORT}")

# Spark oturumu oluştur ve MinIO bağlantı bilgilerini ayarla
spark = SparkSession.builder \
    .appName("DataProcessing") \
    .config("spark.hadoop.fs.s3a.endpoint", f"http://{MINIO_HOST}:{MINIO_PORT}") \
    .config("spark.hadoop.fs.s3a.access.key", MINIO_ACCESS_KEY) \
    .config("spark.hadoop.fs.s3a.secret.key", MINIO_SECRET_KEY) \
    .config("spark.hadoop.fs.s3a.path.style.access", "true") \
    .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false") \
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
    .config("spark.hadoop.fs.s3a.connection.establish.timeout", "5000") \
    .config("spark.hadoop.fs.s3a.connection.timeout", "10000") \
    .config("spark.hadoop.fs.s3a.attempts.maximum", "20") \
    .config("spark.hadoop.fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider") \
    .getOrCreate()

try:
    print("Spark oturumu başarıyla oluşturuldu.")
    
    # MinIO bağlantısını kontrol et
    print("MinIO bağlantısı test ediliyor...")
    
    # Bucket listesini al - SQL sorgusu yerine doğrudan S3A API kullanma
    print("Buckets:")
    # Listele dosya yolu
    bucket_path = "s3a://data-bucket"
    
    # 5. Veri okuma MinIO'dan CSV dosyalarını oku
    print("CSV dosyasını okumaya çalışıyor...")
    
    try:
        # İlk olarak bucket'ın var olup olmadığını kontrol etmek için
        # basit bir işlem deneyin
        test_df = spark.read.format("csv").load(f"{bucket_path}/test.csv", header=True, inferSchema=True)
        test_df.count()
        print("Bucket erişimi başarılı!")
    except Exception as e:
        print(f"Bucket erişim hatası: {str(e)}")
        print("Bucket'ı oluşturmayı deneyin veya erişim izinlerini kontrol edin.")
    
    try:
        df_person = spark.read.format("csv") \
            .option("header", "true") \
            .option("inferSchema", "true") \
            .load(f"{bucket_path}/person_data.csv")
        
        df_country = spark.read.format("csv") \
            .option("header", "true") \
            .option("inferSchema", "true") \
            .load(f"{bucket_path}/country_data.csv")
            
        print("Veri başarıyla okundu!")
        df_person.printSchema()
        df_person.show(5)
        
        # 6. Veri işleme
        current_year = datetime.now().year
        df_filtered = df_person.filter(
            (df_person.age > 30) & 
            (df_person.blood_type.isin(['A+', 'A-', 'AB+', 'AB-']))
        )
        
        # Ülke verisiyle birleştirme (join)
        df_result = df_filtered.join(
            df_country,
            df_filtered.country_id == df_country.id,
            "inner"
        )
        
        # Sonuçları MinIO'ya yaz
        df_result.write \
            .format("parquet") \
            .mode("overwrite") \
            .save(f"{bucket_path}/processed_results/")
            
        print("Veriler başarıyla kaydedildi! 🚀")
    
    except Exception as e:
        print(f"Veri işleme hatası: {str(e)}")
        
except Exception as e:
    print(f"Hata oluştu: {str(e)}")
    import traceback
    traceback.print_exc()
finally:
    print("İşlem tamamlandı.")
    spark.stop()