from db import MysqlOp
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
    return MysqlOp().op_sql('INSERT INTO RFID_log (hardware_uuid,, user_id) VALUES (%s, %s)', (hardware_uuid, user_id))


def update_threshold_by_uuid(uuid, temperature_limit, humidity_limit):
    logger.info('update_threshold_by_uuid')
    return MysqlOp().op_sql('UPDATE hardware SET temperature_limit = %s, humidity_limit = %s WHERE uuid = %s',
                            (temperature_limit, humidity_limit, uuid))
