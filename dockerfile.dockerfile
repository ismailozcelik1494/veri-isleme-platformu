FROM apache/airflow:2.10.5

USER root

# Temel sistemin güncellenmesi
RUN apt-get update && apt-get upgrade -y

# Python ve diğer temel bağımlılıklar 
RUN apt-get install -y --no-install-recommends \
    python3-pip \
    python3-dev \
    build-essential \
    default-jdk \
    ssh \
    rsync \
    wget \
    netcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Hadoop kurulumu
ENV HADOOP_VERSION=3.3.4
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin

RUN mkdir -p ${HADOOP_HOME} \
    && wget -q https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C ${HADOOP_HOME} --strip-components=1 \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && mkdir -p ${HADOOP_HOME}/logs

# Spark için özel Python paketleri
RUN pip install --no-cache-dir \
    pandas \
    numpy \
    scikit-learn \
    matplotlib \
    seaborn \
    pyspark \
    pyarrow \
    s3fs \
    apache-airflow-providers-apache-spark \
    apache-airflow-providers-apache-hadoop \
    apache-airflow-providers-amazon \
    psycopg2-binary

# Ortam değişkenleri
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV PYTHONPATH=${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip:${PYTHONPATH}

USER airflow