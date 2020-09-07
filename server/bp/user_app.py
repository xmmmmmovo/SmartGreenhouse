from flask import Blueprint, request

from exception.custom_exceptions import ContentEmptyException, DBException, DataNotFoundException
from exception.judge_utils import request_judge

from response import response_success

user_bp = Blueprint('user_app', __name__)


@user_bp.route("/<int:id>", methods=["GET"])
def get_info_by_id(id: int):
    if id == 0:
        raise DataNotFoundException()
    return response_success("success", id)


@user_bp.route('', methods=["POST"])
def post_user():
    if request_judge(request, 'email', 'name'):
        raise ContentEmptyException()