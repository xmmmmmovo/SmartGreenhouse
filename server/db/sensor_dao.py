from db import MysqlOp
from flask_loguru import logger


def get_sensor_pagination(page, size, ordered, where_sql, *args):
    logger.info('get_sensor_pagination')
    return MysqlOp().select_all(f"SELECT * FROM sensor_data {where_sql} ORDER BY {ordered} ASC LIMIT %s OFFSET %s",
                                (*args, size, (page - 1) * size))


def get_sensor_pagination_by_username(username, page, size, ordered, where_sql, *args):
    logger.info('get_hardware_pagination_by_username')
    return MysqlOp().select_all(
        f'SELECT * FROM sensor_data WHERE hardware_uuid IN '
        f'(SELECT hardware_uuid FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s)) {where_sql} '
        f'ORDER BY {ordered} ASC LIMIT %s OFFSET %s',
        (username, *args, size, (page - 1) * size))


def count_total(where_sql, *args):
    return MysqlOp().select_one(f'SELECT COUNT(`id`) as len from sensor_data {where_sql}', (*args,))
