from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_claims

from model.Pagination import Pagination
from response import response_success
import uuid
from db.hardware_dao import insert_hardware, get_id_by_uuid, update_threshold_by_uuid, get_hardware_pagination, \
    get_hardware_pagination_by_username, count_total, update_hardware_by_id, delete_hardware_by_id, \
    get_all_hardware_list, get_user_hardware_pagination, count_total_user_hardware, delete_user_hardware_by_user_id, \
    insert_user_hardware_data
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException, \
    UnAuthorizedException, DataNotSatisfyException, UserNotFoundException, CannotDeleteOnlineHardwareException
from utils.jwt_utils import permission_required
from datetime import datetime
from flask_loguru import logger
from base64 import b64decode
from mqtt import mqtt_client
from requests import get
from requests.auth import HTTPBasicAuth
from config import config

hardware_bp = Blueprint('hardware_app', __name__, url_prefix='/hardware')


@hardware_bp.route('/code', methods=['POST'])
def gen_code():
    auth = request.headers['auth']
    if auth is None:
        raise ContentEmptyException()

    now = datetime.now()
    spa = b64decode(auth).decode().split('/')

    if now.hour != int(spa[0]) or now.minute != int(spa[1]):
        raise UnAuthorizedException()

    id = uuid.uuid1().__str__()
    eff_row = insert_hardware(id)
    if eff_row != 1:
        raise DBException()
    return response_success('success', id)


@hardware_bp.route('/code/<string:uuid>', methods=['GET'])
def check_uuid(uuid: str):
    if uuid is None:
        raise ContentEmptyException()
    id = get_id_by_uuid(uuid)
    if id is None:
        raise DataNotFoundException()
    return response_success('success', id)


@hardware_bp.route('/get_hardware', methods=['GET'])
@jwt_required
def get_hardware_client_id():
    claims = get_jwt_claims()
    roles = claims.get('roles', None)
    username = claims.get('username', None)
    if claims is None or roles is None or username is None:
        raise UserNotFoundException()
    res = get(f"http://{config['mqtt']['broker_url']}:{config['mqtt']['http_api_port']}/api/v4/clients",
              auth=HTTPBasicAuth(config['mqtt']['basic_auth_username'], config['mqtt']['basic_auth_password']))
    if res.status_code != 200:
        raise DBException()

    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 99999))
    ordered = request.args.get('ordered', '+id')
    query = request.args.get('query', '')

    if 'admin' in roles:
        where_sql = ''
        args = []
        if query != '':
            where_sql += f'WHERE `{ordered[1:]}` LIKE %s'
            args.append(f'%{query}%')
        hardware_list = get_hardware_pagination(page, size, ordered, where_sql, *args)
        total = count_total(where_sql, *args)
    else:
        where_sql = ''
        args = []
        if query != '':
            where_sql += f'AND `{ordered[1:]}` LIKE %s'
            args.append(f'%{query}%')

        hardware_list = get_hardware_pagination_by_username(username, page, size, ordered, where_sql, *args)
        total = count_total(
            'WHERE uuid IN (SELECT hardware_uuid FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s))' + where_sql,
            username, *args)

    res_json_data = list(map(lambda res: res[:36], filter(lambda res: res.endswith('_sensor_client'),
                                                          map(lambda res: res['clientid'], res.json()['data']))))

    for i in range(len(hardware_list)):
        if hardware_list[i]['uuid'] in res_json_data:
            hardware_list[i]['up'] = True
        else:
            hardware_list[i]['up'] = False
        hardware_list[i]['temperature_limit'] = str(hardware_list[i]['temperature_limit'])
        hardware_list[i]['humidity_limit'] = str(hardware_list[i]['humidity_limit'])

    return response_success('success', Pagination(page, size, hardware_list, total['len']))


@hardware_bp.route('/hardware/<int:id>', methods=['PUT'])
@jwt_required
@permission_required(['admin'])
def update_hardware(id):
    name = request.json.get('name', None)
    up = request.json.get('up', None)
    uuid = request.json.get('uuid', None)
    humidity_limit = request.json.get('humidity_limit', None)
    temperature_limit = request.json.get('temperature_limit', None)

    if name is None or humidity_limit is None or up is None \
            or uuid is None or temperature_limit is None \
            or temperature_limit is None:
        raise ContentEmptyException()

    is_succ = update_hardware_by_id(id, name, humidity_limit, temperature_limit)
    if not is_succ:
        raise DBException()
    mqtt_client.publish('setup_threshold',
                        {'uuid': uuid, 'temperature_limit': temperature_limit, 'humidity_limit': humidity_limit})
    return response_success('success',
                            {'id': id, 'up': up, 'uuid': uuid, 'name': name, 'humidity_limit': str(humidity_limit),
                             'temperature_limit': str(temperature_limit)})


@hardware_bp.route('/hardware/<int:id>', methods=['DELETE'])
@jwt_required
@permission_required(['admin'])
def delete_hardware(id):
    up = request.args.get('up', None)
    if up is None or not up:
        raise CannotDeleteOnlineHardwareException()
    is_succ = delete_hardware_by_id(id)
    if not is_succ:
        raise DBException()
    return response_success('success', None)


@hardware_bp.route('/hardware/all', methods=['GET'])
@jwt_required
@permission_required(['admin'])
def update_user():
    return response_success('success', get_all_hardware_list())


@hardware_bp.route('/user_hardware/all', methods=['GET'])
@jwt_required
@permission_required(['admin'])
def get_user_hardware():
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 9999))
    user_id = request.args.get('userId', '')
    hardware_uuid = request.args.get('hardwareuuid', '')

    where_sql = ''
    args = []
    if user_id != '':
        where_sql += f'WHERE `user`.id = %s'
        args.append(user_id)
    if hardware_uuid != '':
        if len(where_sql) == 0:
            where_sql += f'WHERE hardware.uuid = %s'
        else:
            where_sql += ' AND hardware.uuid = %s'
        args.append(hardware_uuid)
    user_hardware_list = get_user_hardware_pagination(page, size, where_sql, *args)
    total = count_total_user_hardware(where_sql, *args)
    return response_success('success', Pagination(page, size, user_hardware_list, total['len']))


@hardware_bp.route('/user_hardware/<int:id>', methods=['DELETE'])
@jwt_required
@permission_required(['admin'])
def delete_user_hardware(id):
    is_succ = delete_user_hardware_by_user_id(id)
    if not is_succ:
        raise DBException()
    return response_success('success', None)


@hardware_bp.route('/user_hardware/add_user_hardware', methods=['POST'])
@jwt_required
@permission_required(['admin'])
def insert_user_hardware():
    id = request.json.get('id', None)
    uuidd = request.json.get('uuid', None)

    if id is None or uuidd is None:
        raise ContentEmptyException()

    is_succ = insert_user_hardware_data(id, uuidd)
    if not is_succ:
        raise DBException()
    return response_success('success', None)
