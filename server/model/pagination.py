from dataclasses import dataclass
from typing import List
from utils.pwd_utils import bcrypt


@dataclass
class Pagination:
    page: int
    size: int
    list: List[any]
    total: int
