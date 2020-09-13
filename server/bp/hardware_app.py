from flask import Blueprint, request
from flask_jwt_extended import jwt_required

from response import response_success
import uuid
from db.hardware_dao import insert_hardware, get_id_by_uuid
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException, UnAuthorizedException
from utils.jwt_utils import permission_required
from datetime import datetime
from flask_loguru import logger

hardware_bp = Blueprint('hardware_app', __name__, url_prefix='/hardware')


@hardware_bp.route('/code', methods=['POST'])
def gen_code():
    auth = request.headers['auth']
    if auth is None:
        raise ContentEmptyException()

    now = datetime.now()
    spa = auth.split('/')
    if now.hour != int(spa[0]) or now.minute != int(spa[1]):
        raise UnAuthorizedException()

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


@hardware_bp.route('/setup_threshold', methods=['POST'])
@jwt_required
@permission_required(['admin'])
def setup_threshold():
    username = request.json.get('username', None)
    password = request.json.get('password', None)
