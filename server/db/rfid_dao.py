from cache import redis_cache
from db import MysqlOp
from flask_loguru import logger

@redis_cache("get_rfid_pagination", 25)
def get_rfid_pagination(page, size, ordered, where_sql, *args):
    logger.info('get_sensor_pagination')
    return MysqlOp().select_all(f"SELECT username, log_time, hardware_uuid, `name` FROM RFID_log "
                                f"LEFT JOIN `user` ON RFID_log.user_id = `user`.id "
                                f"LEFT JOIN hardware ON RFID_log.hardware_uuid = hardware.uuid "
                                f"{where_sql} ORDER BY {ordered} ASC LIMIT %s OFFSET %s",
                                (*args, size, (page - 1) * size))

@redis_cache("get_rfid_pagination_by_username", 25)
def get_rfid_pagination_by_username(username, page, size, ordered, where_sql, *args):
    logger.info('get_hardware_pagination_by_username')
    return MysqlOp().select_all(
        f'SELECT username, log_time, hardware_uuid, `name` FROM RFID_log '
        f'LEFT JOIN `user` ON RFID_log.user_id = `user`.id '
        f'LEFT JOIN hardware ON RFID_log.hardware_uuid = hardware.uuid '
        f'WHERE hardware_uuid IN (SELECT hardware_uuid '
        f'FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s)) {where_sql} '
        f'ORDER BY {ordered} ASC LIMIT %s OFFSET %s',
        (username, *args, size, (page - 1) * size))


def count_total(where_sql, *args):
    return MysqlOp().select_one(f'SELECT COUNT(`id`) as len from RFID_log {where_sql}', (*args,))
