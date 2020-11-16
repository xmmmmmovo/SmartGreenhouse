from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_claims

from db.rfid_dao import get_rfid_pagination, get_rfid_pagination_by_username
from db.sensor_dao import count_total, get_sensor_pagination_by_username, get_sensor_pagination, get_sensor_data_hourly
from model.pagination import Pagination
from response import response_success
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException, \
    UnAuthorizedException, DataNotSatisfyException, UserNotFoundException, CannotDeleteOnlineHardwareException
from flask_loguru import logger

sensor_bp = Blueprint('sensor_app', __name__, url_prefix='/sensor')


@sensor_bp.route('/get_data', methods=['GET'])
@jwt_required
def sensor_get_data():
    claims = get_jwt_claims()
    roles = claims.get('roles', None)
    username = claims.get('username', None)
    if claims is None or roles is None or username is None:
        raise UserNotFoundException()

    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 9999))
    ordered = request.args.get('ordered', '+id')
    query = request.args.get('query', '')
    date = request.args.getlist('date[]')

    if 'admin' in roles:
        where_sql = ''
        args = []
        if query != '':
            where_sql += f'WHERE `{ordered[1:]}` LIKE %s'
            args.append(f'%{query}%')

        if len(date) != 0:
            if len(where_sql) == 0:
                where_sql += 'WHERE '
            else:
                where_sql += ' AND '
            where_sql += 'record_time > %s AND record_time < %s'
            args.append(date[0])
            args.append(date[1])

        sensor_list = get_sensor_pagination(page, size, ordered, where_sql, *args)
        total = count_total(where_sql, *args)
    else:
        where_sql = ''
        args = []
        if query != '':
            where_sql += f'AND `{ordered[1:]}` LIKE %s'
            args.append(f'%{query}%')

        if len(date) != 0:
            where_sql += ' AND record_time > %s AND record_time < %s'
            args.append(date[0])
            args.append(date[1])
        sensor_list = get_sensor_pagination_by_username(username, page, size, ordered, where_sql, *args)
        total = count_total(
            'WHERE hardware_uuid IN (SELECT hardware_uuid FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s))' + where_sql,
            username, *args)

    return response_success('success', Pagination(page, size, sensor_list, total['len']))


@sensor_bp.route('/get_data_hour', methods=['GET'])
@jwt_required
def getDailySensorData():
    uuid = request.args.get('uuid', None)
    logger.info(uuid)
    if uuid is None:
        raise ContentEmptyException()

    return response_success('success', get_sensor_data_hourly(uuid))
