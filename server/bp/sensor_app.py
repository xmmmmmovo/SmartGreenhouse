from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_claims

from model.Pagination import Pagination
from response import response_success
import uuid
from exception.custom_exceptions import DBException, ContentEmptyException, DataNotFoundException, \
    UnAuthorizedException, DataNotSatisfyException, UserNotFoundException, CannotDeleteOnlineHardwareException
from utils.jwt_utils import permission_required
from datetime import datetime
from flask_loguru import logger
from config import config

sensor_bp = Blueprint('sensor_app', __name__, url_prefix='/sensor')

