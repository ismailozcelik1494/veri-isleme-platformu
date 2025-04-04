import os
import sys
import socket
from pyspark.sql import SparkSession
from datetime import datetime
from pyspark.sql.functions import year, col, concat_ws, collect_list
from pyspark import SparkContext

# 1. Önceki SparkContext'i temizle
if 'spark' in locals() and SparkContext._active_spark_context:
    SparkContext._active_spark_context.stop()

if 'socket' in sys.modules:
    del sys.modules['socket']

sys.stdout.reconfigure(encoding='utf-8')

# 2. Python yolunu ve Spark ayarlarını zorla belirt
os.environ['PYSPARK_PYTHON'] = r'C:\Python311\python.exe'  # Python 3.11 yolu
os.environ['PYSPARK_DRIVER_PYTHON'] = r'C:\Python311\python.exe'

# 3. SparkSession oluşturma
spark = SparkSession.builder \
    .appName("PostgresIntegration") \
    .master("spark://ismailozcelik-docker-spark-master-1:7077") \
    .config("spark.jars", "/opt/tmp/postgresql-42.7.5.jar") \
    .getOrCreate()

#Spark master adresiecho %SPARK_HOME%
# .master("spark://172.21.0.2:7077") \

# 2. PostgreSQL bağlantı parametrelerini ayarlıyoruz.
jdbc_url = "jdbc:postgresql://ismailozcelik-docker-postgres-1:5432/postgres"
properties = {
    "user": "airflow",
    "password": "airflow",
    "driver": "org.postgresql.Driver"
}

try:
    # Basit bir sorgu ile bağlantıyı test et
    # try:
    #      df = spark.read.jdbc(url=jdbc_url, table="person_data", properties=properties)
    #      df.show(5)  # İlk 5 satırı göster
    #      print("Bağlantı başarılı! 🚀")
    # except Exception as e:
    #      print("Bağlantı hatası:", e)
  
    # 5. Veri okuma
    df = spark.read.jdbc(url=jdbc_url, table="person_data", properties=properties)
    df.show(5)
    
    # 6. Veri işleme
    current_year = datetime.now().year
    df_person = df.withColumn("age", current_year - year(col("birthday")))
    df_filtered = df_person.filter((col("age") > 30) & 
                                 (col("blood_type").isin("A+", "A-", "AB+", "AB-")))
    
    # 7. Sonuçları kaydetme
    df_filtered.write \
        .format("jdbc") \
        .option("url", jdbc_url) \
        .option("dbtable", "processed_results") \
        .option("user", "airflow") \
        .option("password", "airflow") \
        .mode("overwrite") \
        .save()
        
    print("Veriler başarıyla kaydedildi! 🚀")
    
except Exception as e:
    print("Hata oluştu:", e)
finally:
    spark.stop()