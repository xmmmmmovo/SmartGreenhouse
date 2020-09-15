from db import MysqlOp
from .user_dao import select_user_by_username
from flask_loguru import logger


def insert_hardware(uuid: str):
    logger.info('insert_hardware')
    return MysqlOp().op_sql('INSERT INTO hardware (uuid) VALUES (%s)', (uuid))


def get_id_by_uuid(uuid: str):
    logger.info('get_id_by_uuid')
    return MysqlOp().select_one('SELECT id FROM hardware WHERE uuid = %s', (uuid))


def insert_sensor_data(temperature: str, humidity: str, uuid: str, fire: bool, illumination: bool, solid: bool):
    logger.info('insert_sensor_data')
    return MysqlOp().op_sql(
        'INSERT INTO sensor_data (hardware_uuid, temperature, humidity, is_fire, is_dry, is_illum) VALUES (%s, %s, %s, %s, %s, %s)',
        (uuid, temperature, humidity, int(fire), int(solid), int(illumination)))


def insert_rfid_log(user_id, hardware_uuid):
    logger.info('insert_rfid_log')
    return MysqlOp().op_sql('INSERT INTO RFID_log (hardware_uuid, user_id) VALUES (%s, %s)', (hardware_uuid, user_id))


def update_threshold_by_uuid(uuid, temperature_limit, humidity_limit):
    logger.info('update_threshold_by_uuid')
    return MysqlOp().op_sql('UPDATE hardware SET temperature_limit = %s, humidity_limit = %s WHERE uuid = %s',
                            (temperature_limit, humidity_limit, uuid))


def get_hardware_pagination(page, size, ordered, where_sql, *args):
    logger.info('get_hardware_pagination')
    return MysqlOp().select_all(f"SELECT * FROM hardware {where_sql} ORDER BY {ordered} ASC LIMIT %s OFFSET %s",
                                (*args, size, (page - 1) * size))


def get_hardware_pagination_by_username(username, page, size, ordered, where_sql, *args):
    logger.info('get_hardware_pagination_by_username')
    return MysqlOp().select_all(
        f'SELECT * FROM hardware WHERE uuid IN '
        f'(SELECT hardware_uuid FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s)) {where_sql} '
        f'ORDER BY {ordered} ASC LIMIT %s OFFSET %s',
        (username, *args, size, (page - 1) * size))


def count_total(where_sql, *args):
    logger.info('count_total')
    return MysqlOp().select_one(f'SELECT COUNT(`id`) as len from hardware {where_sql}', (*args,))


def update_hardware_by_id(id, name, humidity_limit, temperature_limit):
    logger.info('update_hardware_by_id')
    return MysqlOp().op_sql(
        'UPDATE hardware SET `name` = %s, temperature_limit = %s, humidity_limit = %s WHERE id = %s',
        (name, temperature_limit, humidity_limit, id))


def delete_hardware_by_id(id):
    logger.info('delete_hardware_by_id')
    return MysqlOp().op_sql('DELETE FROM hardware WHERE id = %s', (id))


def get_all_hardware_list():
    return MysqlOp().select_all('SELECT uuid, `name` FROM hardware')


def get_user_hardware_pagination(page, size, where_sql, *args):
    return MysqlOp().select_all(
        f"SELECT `user`.id , hardware.`name`, hardware.uuid, `user`.username FROM user_hardware "
        f"LEFT JOIN `user` ON `user`.id = user_hardware.user_id "
        f"LEFT JOIN hardware ON hardware.uuid = user_hardware.hardware_uuid "
        f"{where_sql} LIMIT %s OFFSET %s",
        (*args, size, (page - 1) * size))


def count_total_user_hardware(where_sql, *args):
    logger.info('count_total_user_hardware')
    return MysqlOp().select_one(f'SELECT COUNT(`user_id`) as len from user_hardware '
                                f'LEFT JOIN `user` ON `user`.id = user_hardware.user_id '
                                f'LEFT JOIN hardware ON hardware.uuid = user_hardware.hardware_uuid '
                                f'{where_sql}', (*args,))


def delete_user_hardware_by_user_id(id):
    logger.info('delete_user_hardware_by_user_id')
    return MysqlOp().op_sql('DELETE FROM user_hardware WHERE user_id = %s', (id))


def insert_user_hardware_data(id, uuid):
    logger.info('insert_user_hardware')
    return MysqlOp().op_sql('INSERT INTO user_hardware (user_id, hardware_uuid) VALUES (%s, %s)', (id, uuid))
