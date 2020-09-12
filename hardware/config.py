from yaml import load, FullLoader


class Config(object):
    SCHEDULER_API_ENABLED = True


def _load_config(path):
    config = load(open(path), Loader=FullLoader)
    return config


config_ = _load_config('./config.yml')
