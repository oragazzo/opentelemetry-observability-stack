import sqlite3
from flask import g

import requests

DATABASE = 'users.db'

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        db.row_factory = sqlite3.Row
    return db

def init_db():
    with get_db() as db:
        db.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                email TEXT
            )
        ''')
        db.commit()

def close_db(e=None):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

def add_user(username, email):
    with get_db() as db:
        cursor = db.cursor()
        cursor.execute(
            'INSERT INTO users (username, email) VALUES (?, ?)',
            (username, email)
        )
        db.commit()
        return cursor.lastrowid

def get_user(username):

    requests.get(f'https://httpbin.org/get?user={username}')

    with get_db() as db:
        cursor = db.cursor()
        cursor.execute(
            'SELECT * FROM users WHERE username = ?',
            (username,)
        )
        return cursor.fetchone() 