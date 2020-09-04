from typing import Any
from flask import jsonify

from dataclasses import dataclass
from response.response_code import ResponseCode


@dataclass
class Response:
    code: int
    msg: str
    data: Any


def response_success(msg: str, data: Any) -> str:
    return jsonify(Response(
        code=ResponseCode.success,
        msg=msg,
        data=data
    ))


def response_fail(code: int, msg: str, data: Any) -> str:
    return jsonify(Response(
        code=code,
        msg=str(msg),
        data=data
    ))
