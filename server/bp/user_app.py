from flask import Blueprint, request
from exception.custom_exceptions import ContentEmptyException, DBException, DataNotFoundException, \
    PasswordErrorException, DataNotSatisfyException, UnAuthorizedException
from response import response_success
from db import user_dao
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_claims
from model import user
from flask_loguru import logger

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
    # TODO: 为了安全考虑的redis退出登录
    return response_success('success logout', None)


@user_bp.route("/protected", methods=['GET'])
@jwt_required
def protected():
    return response_success('success', 'success')
