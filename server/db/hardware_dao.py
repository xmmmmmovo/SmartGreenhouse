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
