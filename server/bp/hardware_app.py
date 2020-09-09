from flask import Blueprint
from response import response_success
import uuid
from db.hardware_dao import insert_hardware, get_id_by_uuid
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException

hardware_bp = Blueprint('hardware_app', __name__, url_prefix='/hardware')


@hardware_bp.route('/code', methods=['POST'])
def gen_code():
    id = uuid.uuid1().__str__()
    eff_row = insert_hardware(id)
    if eff_row != 1:
        raise DBException()
    return response_success('success', id)


@hardware_bp.route('/code/<string:uuid>', methods=['GET'])
def get_id_by_uuid_route(uuid: str):
    if uuid is None:
        raise ContentEmptyException()
    id = get_id_by_uuid(uuid)
    if id is None:
        raise DataNotFoundException()
    return response_success('success', id)
