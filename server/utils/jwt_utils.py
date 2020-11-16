from datetime import timedelta
from typing import List

from flask_jwt_extended import JWTManager, verify_jwt_in_request, get_jwt_claims
from functools import wraps
from exception.custom_exceptions import UnAuthorizedException, UserNotFoundException, InsufficientPermissions
from model.user import User
from response import response_fail_exception
from cache import get_value, set_value

jwt_manager = JWTManager()

JWT_ACCESS_TOKEN_EXPIRES = timedelta(days=30)


@jwt_manager.user_claims_loader
def add_claims_to_access_token(user: User):
    return {'roles': user.roles, 'username': user.username}


@jwt_manager.user_identity_loader
def user_identity_loader(user: User):
    return user.username


@jwt_manager.user_loader_error_loader
def custom_user_loader_error(identity):
    return response_fail_exception(UserNotFoundException())


@jwt_manager.unauthorized_loader
def custom_unauthorized_loader(e):
    return response_fail_exception(UnAuthorizedException())


@jwt_manager.token_in_blacklist_loader
def check_if_token_is_revoked(decrypted_token):
    jti = decrypted_token['jti']
    entry = get_value(jti)
    if entry is None:
        return True
    return entry == 'true'


def permission_required(permission: List[str]):
    def _permission_required(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            verify_jwt_in_request()
            claims = get_jwt_claims()
            if list(set(claims['roles']) & set(permission)):
                return func(*args, **kwargs)
            else:
                return response_fail_exception(InsufficientPermissions())

        return wrapper

    return _permission_required
