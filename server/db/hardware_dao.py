from db.mysql_operator import MysqlOp


def insert_hardware(uuid: str):
    return MysqlOp().op_sql('INSERT INTO hardware (uuid) VALUES (%s)', (uuid))


def get_id_by_uuid(uuid: str):
    return MysqlOp().select_one('SELECT id FROM hardware WHERE uuid = %s', (uuid))
