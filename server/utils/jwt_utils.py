from typing import List
from flask_jwt_extended import JWTManager, verify_jwt_in_request, get_jwt_claims
from functools import wraps
from exception.custom_exceptions import UnAuthorizedException, UserNotFoundException, InsufficientPermissions
from model.user import User
from response import response_fail_exception

jwt_manager = JWTManager()


@jwt_manager.user_claims_loader
def add_claims_to_access_token(user: User):
    return {'roles': user.roles}


@jwt_manager.user_identity_loader
def user_identity_loader(user: User):
    return user.username


@jwt_manager.user_loader_error_loader
def custom_user_loader_error(identity):
    return response_fail_exception(UserNotFoundException())


@jwt_manager.unauthorized_loader
def custom_unauthorized_loader(e):
    return response_fail_exception(UnAuthorizedException())


def permission_required(permission: List[str]):
    def _permission_required(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            verify_jwt_in_request()
            claims = get_jwt_claims()
            if list(set(claims['roles'] & set(permission))):
                return func(*args, **kwargs)
            else:
                return response_fail_exception(InsufficientPermissions())

        return wrapper

    return _permission_required
