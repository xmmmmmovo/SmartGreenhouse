from yaml import load, FullLoader


def _load_config(path):
    config = load(open(path), Loader=FullLoader)
    return config


config = _load_config('./config.yml')
