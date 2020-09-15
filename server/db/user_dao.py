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


def get_all_users():
    return MysqlOp().select_all('SELECT `id`, username from `user`')


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


def delete_user_by_id(id):
    return MysqlOp().op_sql('DELETE FROM user WHERE id = %s', (id))


def select_role_id_by_userid(name):
    mp = MysqlOp()
    return mp.select_one('SELECT role.id as id FROM role WHERE `name` = %s',
                         (name,))


def update_by_rid(rid, id):
    return MysqlOp().op_sql('UPDATE user_roles SET role_id = %s WHERE user_id = %s', (rid, id))


def update_user_by_id(username, id):
    return MysqlOp().op_sql('UPDATE `user` SET username = %s WHERE id = %s', (username, id))


def count_total_role(where_sql, *args):
    return MysqlOp().select_one(f'SELECT COUNT(`id`) as len from role {where_sql}', (*args,))


def add_role(name):
    return MysqlOp().op_sql('INSERT INTO role (`name`) VALUES (%s)', (name))


def get_role_pagination(page, size, where_sql, *args):
    return MysqlOp().select_all(f'SELECT * FROM role {where_sql} LIMIT %s OFFSET %s',
                                (*args, size, (page - 1) * size))


def get_all_role():
    return MysqlOp().select_all(f'SELECT `name` FROM role')


def delete_role_by_id(id):
    return MysqlOp().op_sql('DELETE FROM role WHERE id = %s', (id))


def update_role_by_id(id, name):
    return MysqlOp().op_sql('UPDATE role SET name = %s WHERE id = %s', (name, id))
