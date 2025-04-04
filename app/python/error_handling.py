from spark_job import df_grouped

try:
    df_grouped.write \
    .format("jdbc") \
    .option("url", "jdbc:postgresql://ismailozcelik-docker-postgres-1:5432/postgres") \
    .option("dbtable", "processed_results") \
    .option("user", "airflow") \
    .option("password", "airflow") \
    .save()
except Exception as e:
    print(f"Hata: {str(e)}")