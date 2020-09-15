from flask import Blueprint, request

from db.user_dao import get_user_pagination, count_total, count_total_role
from exception.custom_exceptions import ContentEmptyException, DBException, DataNotFoundException, \
    PasswordErrorException, DataNotSatisfyException, UnAuthorizedException
from model.Pagination import Pagination
from response import response_success
from db import user_dao
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_claims
from model import user
from flask_loguru import logger

from utils.jwt_utils import permission_required

user_bp = Blueprint('user_app', __name__, url_prefix='/user')


@user_bp.route("/register", methods=['POST'])
def register():
    username = request.json.get('username', None)
    password = request.json.get('password', None)

    if len(password) < 6:
        raise DataNotSatisfyException()

    if username is None or password is None:
        raise ContentEmptyException()

    is_succ = user_dao.insert_user(username, password)
    if not is_succ:
        raise DBException()
    u = user.User(username, ['manager'])
    token = create_access_token(identity=u)
    return response_success("success", token)


@user_bp.route("/login", methods=['POST'])
def login():
    username = request.json.get('username', None)
    password = request.json.get('password', None)

    if len(password) < 6:
        raise DataNotSatisfyException()

    if username is None or password is None:
        raise ContentEmptyException()

    data = user_dao.select_user_by_username(username)
    if data is None:
        raise DataNotFoundException()

    if not user.check_pwd(password, data['password']):
        raise PasswordErrorException()

    roles = list(map(lambda x: x['name'], user_dao.select_roles_by_userid(data['id'])))

    token = create_access_token(identity=user.User(data['username'], roles))

    return response_success('success', {'token': token})


@user_bp.route("/info", methods=['POST'])
@jwt_required
def info():
    claims = get_jwt_claims()
    logger.info(claims)
    return response_success('success', claims)


@user_bp.route("/change-password", methods=['POST'])
@jwt_required
@permission_required(['admin'])
def change_password():
    claims = get_jwt_claims()

    real_name = claims['username']
    username = request.json.get('username', None)
    password = request.json.get('password', None)

    if real_name != username:
        raise UnAuthorizedException()

    if len(password) < 7:
        raise DataNotSatisfyException()

    if username is None or password is None:
        raise ContentEmptyException()

    is_succ = user_dao.update_password_by_username(username, password)
    if not is_succ:
        raise DBException()

    return response_success('success', None)


@user_bp.route("/logout", methods=['DELETE'])
@jwt_required
def logout():
    # TODO: 为了安全考虑的redis退出登录 但是为了api易于测试暂时不写
    return response_success('success logout', None)


@user_bp.route("/protected", methods=['GET'])
@jwt_required
def protected():
    return response_success('success', 'success')


@user_bp.route('/get_data', methods=['GET'])
@jwt_required
@permission_required(['admin'])
def sensor_get_data():
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 9999))
    query = request.args.get('query', '')

    where_sql = ''
    args = []
    if query != '':
        where_sql += f'WHERE `username` LIKE %s'
        args.append(f'%{query}%')

    user_list = get_user_pagination(page, size, where_sql, *args)
    total = count_total(where_sql, *args)
    return response_success('success', Pagination(page, size, user_list, total['len']))


@user_bp.route('/add_role', methods=['POST'])
@jwt_required
@permission_required(['admin'])
def add_role():
    name = request.json.get('name', None)
    if name is None:
        raise ContentEmptyException()
    is_succ = user_dao.add_role(name)
    if not is_succ:
        raise DBException()
    return response_success('success', None)


@user_bp.route('/roles', methods=['GET'])
@jwt_required
@permission_required(['admin'])
def get_roles_list():
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 9999))
    query = request.args.get('query', '')

    where_sql = ''
    args = []
    if query != '':
        where_sql += f'WHERE `username` LIKE %s'
        args.append(f'%{query}%')

    role_list = get_user_pagination(page, size, where_sql, *args)
    total = count_total_role(where_sql, *args)
    return response_success('success', Pagination(page, size, role_list, total['len']))


@user_bp.route('/user/<int:id>', methods=['DELETE'])
@jwt_required
@permission_required(['admin'])
def delete_user(id):
    is_succ = user_dao.delete_user_by_id(id)
    if not is_succ:
        raise DBException()
    return response_success('success', None)


@user_bp.route('/user/<int:id>', methods=['PUT'])
@jwt_required
@permission_required(['admin'])
def update_user(id):
    username = request.json.get('username', None)
    name = request.json.get('name', None)
    if username is None or name is None:
        raise ContentEmptyException()

    rid = user_dao.select_role_id_by_userid(name)['id']
    is_succ1 = user_dao.update_by_rid(rid, id)
    is_succ2 = user_dao.update_user_by_id(username, id)

    if not is_succ1 or not is_succ2:
        raise DBException()

    return response_success('success', {'id': id, 'username': username, 'name': name})
