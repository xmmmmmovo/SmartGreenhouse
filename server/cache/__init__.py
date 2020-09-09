from flask_redis import FlaskRedis
from flask_loguru import logger
from json import loads, dumps

redis = FlaskRedis()


def redis_cache(key, timeout):
    def __redis_cache(func):
        def warpper(*args, **kw):
            # 判断缓存是否存在
            logger.info('check key: %s' % key)
            cache_msg = redis.get(key)
            if cache_msg is None:
                # 若不存在则执行获取数据的方法
                # 注意返回数据的类型(字符串，数字，字典，列表均可)
                cache_msg = func(*args, **kw)
                redis.set(key, dumps(cache_msg), ex=timeout)
            else:
                cache_msg = loads(cache_msg)
            return cache_msg

        return warpper

    return __redis_cache
