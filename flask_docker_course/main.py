from flask import Flask, jsonify, abort
from werkzeug.middleware.proxy_fix import ProxyFix
from .user import User
from os import getenv
import psycopg2

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)

database_connection = psycopg2.connect("dbname={} user={} password={} host={}".format(
    getenv('DB_NAME'),
    getenv('DB_USER'),
    getenv('DB_PASSWORD'),
    getenv('DB_HOST')
))

cursor = database_connection.cursor()

USERS = [User(1, 'sample_username1', 30), User(2, 'sample_username2', 31)]

@app.errorhandler(404)
def not_found(error):
    return jsonify(error=str(error)), 404

@app.errorhandler(500)
def not_found(error):
    return jsonify(error=str(error)), 500

@app.route('/', methods=['GET'])
def root_path():
    return jsonify("Welcome in the root !")

@app.route('/user', methods=['GET'])
def get_user():
    try:
        cursor.execute('SELECT id, name, age FROM public.user')
        rows = cursor.fetchall()
        users = []
        for row in rows:
            users.append(User(row[0], row[1], row[2]))
        return jsonify([user.as_dict() for user in users])

    except Exception as error:
        abort(500)

@app.route('/user/<int:user_id>', methods=['GET'])
def get_user_by_id(user_id):
    try:
        cursor.execute('SELECT id, name, age FROM public.user WHERE id=(%s)', (user_id,))
        row = cursor.fetchone()
    except Exception as error:
        abort(500, error)
    
    if not row:
        abort(404)
        
    return jsonify(User(row[0], row[1], row[2]).as_dict())

def main():
    app.run(host=getenv('FLASK_IP'), port=getenv('FLASK_PORT'))
