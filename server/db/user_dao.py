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


def select_roles_by_userid(user_id):
    mp = MysqlOp()
    return mp.select_all('SELECT role.`name` FROM role WHERE id IN (SELECT role_id FROM user_roles WHERE user_id = %s)',
                         (user_id,))


def update_password_by_username(username: str, password: str):
    mp = MysqlOp()
    return mp.op_sql('UPDATE user SET password = %s WHERE username = %s', (user.hash_pwd(password), username))


def get_user_pagination(page, size, where_sql, *args):
    logger.info('get_sensor_pagination')
    return MysqlOp().select_all(
        f"SELECT `user`.id, username, role.`name` FROM `user` "
        f"LEFT JOIN user_roles ON `user`.id = user_roles.user_id "
        f"LEFT JOIN role ON user_roles.role_id = role.id"
        f"{where_sql} LIMIT %s OFFSET %s",
        (*args, size, (page - 1) * size))


def count_total(where_sql, *args):
    return MysqlOp().select_one(f'SELECT COUNT(`id`) as len from `user` {where_sql}', (*args,))
