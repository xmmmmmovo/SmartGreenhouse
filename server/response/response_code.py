from enum import IntEnum, unique


@unique
class ResponseCode(IntEnum):
    success = 200,
    not_found = 404,
    run_panic = 500,
    params_error = 10005
    data_not_found = 10006
    db_error = 10007
    unauthorized = 403
    data_error = 10008
