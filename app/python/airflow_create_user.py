pip install apache-airflow


# Airflow Veritabanı Başlatma
airflow db init


# Airflow Kullanıcı Hesabı Oluşturma
airflow users create --username admin --firstname ismail --lastname ozcelik --email admin@example.com --role Admin --password admin



# Airflow Web Arayüzünü Başlatma
airflow webserver --port 8080


# Airflow Scheduler'ı Başlatma
airflow scheduler



# İlk DAG'inizi Oluşturma