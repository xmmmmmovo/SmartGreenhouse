from flask import Blueprint, request

from exception.custom_exceptions import ContentEmptyException, DBException, DataNotFoundException

from response import response_success

user_bp = Blueprint('user_app', __name__, url_prefix='/user')


@user_bp.route("/<int:id>", methods=["GET"])
def get_info_by_id(id: int):
    if id == 0:
        raise DataNotFoundException()
    return response_success("success", id)

