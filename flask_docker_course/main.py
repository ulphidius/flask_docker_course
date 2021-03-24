from flask import Flask, jsonify, abort
from werkzeug.middleware.proxy_fix import ProxyFix
from .user import User
from os import getenv

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)

USERS = [User(1, 'sample_username1', 30), User(2, 'sample_username2', 31)]

@app.errorhandler(404)
def not_found(error):
    return jsonify(error=str(error)), 404

@app.route('/', methods=['GET'])
def root_path():
    return jsonify("Welcome in the root !")

@app.route('/user', methods=['GET'])
def get_user():
    return jsonify([user.as_dict() for user in USERS])

@app.route('/user/<int:user_id>', methods=['GET'])
def get_user_by_id(user_id):
    user_to_return = list(filter(lambda user: user._id == user_id, USERS))
    
    if not user_to_return:
        abort(404)
    
    return jsonify(user_to_return[0].as_dict())

def main():
    app.run(host=getenv('FLASK_IP'), port=getenv('FLASK_PORT'))
