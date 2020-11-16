from flask_redis import FlaskRedis
from flask_loguru import logger
from json import loads, dumps

from cache.encoder import ComplexEncoder

redis = FlaskRedis()


def get_value(key):
    return redis.get(key)


def set_value(key, value, timeout):
    return redis.set(key, value, ex=timeout)


def redis_cache(key, timeout):
    def __redis_cache(func):
        def warpper(*args, **kw):
            rel_key = key + str(args) + str(kw)
            # 判断缓存是否存在
            logger.info('check key: %s' % rel_key)
            cache_msg = redis.get(rel_key)
            if cache_msg is None:
                # 若不存在则执行获取数据的方法
                # 注意返回数据的类型(字符串，数字，字典，列表均可)
                cache_msg = dumps(func(*args, **kw), cls=ComplexEncoder)
                redis.set(rel_key, cache_msg, ex=timeout)
            return loads(cache_msg)

        return warpper

    return __redis_cache
