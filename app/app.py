# from ddtrace import patch_all
from flask import Flask, request, jsonify
from database import init_db, close_db, add_user, get_user

# Initialize Flask
app = Flask(__name__)

# Initialize database
with app.app_context():
    init_db()

# Register database connection close handler
app.teardown_appcontext(close_db)

@app.route('/error')
def error():
    result = 1 / 0
    return 'Hello, World!' + str(result)


@app.route('/')
def hello():
    return 'Hello, World!'


@app.route("/api/users/<username>", methods=['GET', 'POST', 'PUT'])
def users(username):
    if request.method == 'POST':
        data = request.get_json()
        email = data.get('email', '')
        try:
            user_id = add_user(username, email)
            return jsonify({'id': user_id, 'username': username, 'email': email}), 201
        except Exception as e:
            return jsonify({'error': str(e)}), 400
    
    elif request.method == 'GET':
        user = get_user(username)
        if user:
            return jsonify(dict(user))

    return jsonify({'error': 'User not found'}), 404