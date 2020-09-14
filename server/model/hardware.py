from dataclasses import dataclass


@dataclass
class Hardware:
    id: int
    uuid: str
    up: bool
    temperature_limit: str
    humidity_limit: str
    name: str
