from flask import Blueprint, request
from exception.custom_exceptions import ContentEmptyException, DBException, DataNotFoundException
from response import response_success
from db import user_dao
from flask_jwt_extended import create_access_token, jwt_required
from model import user

user_bp = Blueprint('user_app', __name__, url_prefix='/user')


@user_bp.route("/register", methods=['POST'])
def register():
    username = request.json.get('username', None)
    password = request.json.get('password', None)

    if username is None or password is None:
        raise ContentEmptyException()

    is_succ = user_dao.insert_user(username, password)
    if not is_succ:
        raise DBException()
    u = user.User(username, password, ['manager'])
    token = create_access_token(identity=u)
    return response_success("success", token)


@user_bp.route("/login", methods=['POST'])
def login():
    pass


@user_bp.route("/protected", methods=['GET'])
@jwt_required
def protected():
    return response_success('success', 'success')
