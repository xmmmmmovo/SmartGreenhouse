from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_claims

from db.rfid_dao import get_rfid_pagination, get_rfid_pagination_by_username, count_total
from model.pagination import Pagination
from response import response_success
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException, \
    UnAuthorizedException, DataNotSatisfyException, UserNotFoundException, CannotDeleteOnlineHardwareException
from flask_loguru import logger

rfid_bp = Blueprint('rfid_app', __name__, url_prefix='/rfid')


@rfid_bp.route('/get_data', methods=['GET'])
@jwt_required
def rfid_get_data():
    claims = get_jwt_claims()
    roles = claims.get('roles', None)
    username = claims.get('username', None)
    if claims is None or roles is None or username is None:
        raise UserNotFoundException()

    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 9999))
    ordered = request.args.get('ordered', '+RFID_log.id')
    query = request.args.get('query', '')
    date = request.args.getlist('date[]')

    if ordered[1:] == 'id':
        ordered = f'{ordered[0]}RFID_log.{ordered[1:]}'

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
            where_sql += 'log_time > %s AND log_time < %s'
            args.append(date[0])
            args.append(date[1])
        rfid_list = get_rfid_pagination(page, size, ordered, where_sql, *args)
        total = count_total(where_sql, *args)
    else:
        where_sql = ''
        args = []
        if query != '':
            where_sql += f'AND `{ordered[1:]}` LIKE %s'
            args.append(f'%{query}%')

        if len(date) != 0:
            where_sql += ' AND log_time > %s AND log_time < %s'
            args.append(date[0])
            args.append(date[1])
        rfid_list = get_rfid_pagination_by_username(username, page, size, ordered, where_sql, *args)
        total = count_total(
            'WHERE hardware_uuid IN (SELECT hardware_uuid FROM user_hardware WHERE user_id = (SELECT id FROM `user` WHERE username = %s))' + where_sql,
            username, *args)

    for i in range(len(rfid_list)):
        rfid_list[i]['log_time'] = rfid_list[i]['log_time'].strftime("%m/%d/%Y, %H:%M:%S")

    return response_success('success', Pagination(page, size, rfid_list, total['len']))
