from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_claims

from db.sensor_dao import count_total, get_sensor_pagination_by_username, get_sensor_pagination
from model.Pagination import Pagination
from response import response_success
import uuid
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException, \
    UnAuthorizedException, DataNotSatisfyException, UserNotFoundException, CannotDeleteOnlineHardwareException
from utils.jwt_utils import permission_required
from datetime import datetime
from flask_loguru import logger
from config import config

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
        total = count_total('')
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
            'WHERE hardware_uuid IN (SELECT hardware_uuid FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s))',
            username)

    for i in range(len(sensor_list)):
        sensor_list[i]['temperature'] = str(sensor_list[i]['temperature'])
        sensor_list[i]['humidity'] = str(sensor_list[i]['humidity'])
        sensor_list[i]['record_time'] = sensor_list[i]['record_time'].strftime("%m/%d/%Y, %H:%M:%S")

    return response_success('success', Pagination(page, size, sensor_list, total['len']))
