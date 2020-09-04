from flask import Blueprint
from response import response_fail, ResponseCode
from werkzeug.exceptions import HTTPException

exception = Blueprint('exception', __name__)


@exception.app_errorhandler(ResponseCode.not_found)
def not_found_error(e):
    return response_fail(ResponseCode.not_found, '接口未找到', None)


@exception.app_errorhandler(ResponseCode.run_panic)
def not_found_error(e):
    return response_fail(ResponseCode.not_found, '接口出现错误 请联系管理员', None)


@exception.app_errorhandler(HTTPException)
def custom_error(e):
    return response_fail(e.code, e.description, None)
