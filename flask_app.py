from flask import Flask, jsonify
import psycopg2

app = Flask(__name__)

@app.route('/results/<country>', methods=['GET'])
def get_results(country):
    conn = psycopg2.connect("dbname=postgres user=airflow password=airflow host=localhost port=5433 options='-c client_encoding=UTF8'")
    cur = conn.cursor()
    cur.execute("SELECT * FROM processed_results WHERE country = %s", (country,))
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)