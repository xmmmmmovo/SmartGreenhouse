from db import MysqlOp
from flask_loguru import logger
from model import user


def insert_user(username, password):
    mp = MysqlOp()
    mp.op_sql('INSERT INTO user (username, password) VALUES (%s, %s)', (username, user.hash_pwd(password)))
    return mp.op_sql('INSERT INTO user_roles (user_id, role_id) VALUES (%s, %s)', (mp.cur.lastrowid, 2))


def select_user_by_username(username):
    mp = MysqlOp()
    return mp.select_one('SELECT id, username, password FROM `user` WHERE username = %s', (username))


def select_roles_by_username(username):
    mp = MysqlOp()
    return mp.select_all('SELECT role')
