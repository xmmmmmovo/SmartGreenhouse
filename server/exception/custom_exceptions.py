from werkzeug.exceptions import HTTPException
from response.response_code import ResponseCode


class ContentEmptyException(HTTPException):
    code = ResponseCode.params_error
    description = "字段不能为空!"


class DataNotFoundException(HTTPException):
    code = ResponseCode.data_not_found
    description = "未找到需要的数据!"


class DBException(HTTPException):
    code = ResponseCode.db_error
    description = "数据库操作失败!"
