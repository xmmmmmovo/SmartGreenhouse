from dataclasses import dataclass
from typing import List
from utils.pwd_utils import bcrypt


@dataclass
class User:
    username: str
    roles: List[str]


def hash_pwd(password):
    return bcrypt.generate_password_hash(password)


def check_pwd(password, hashed_password):
    return bcrypt.check_password_hash(hashed_password, password)
