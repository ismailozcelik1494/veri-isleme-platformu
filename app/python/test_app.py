# test_app.py
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("TestApp") \
    .getOrCreate()

# Basit bir işlem
df = spark.createDataFrame([(1,), (2,), (3,)], ["number"])
print(df.count())

# Uygulamanın UI'de görünmesi için biraz bekleyin
import time
time.sleep(30)

spark.stop()