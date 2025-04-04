from os import name
from flask import Flask, jsonify # type: ignore
import psycopg2 # type: ignore

app = Flask(name)

@app.route('/results/<country>', methods=['GET'])
def get_results(country):
    conn = psycopg2.connect("dbname=postgres user=postgres password=admin host=localhost")
    cur = conn.cursor()
    cur.execute("SELECT * FROM processed_results WHERE country = %s", (country,))
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

if name == 'main':
    app.run(debug=True)