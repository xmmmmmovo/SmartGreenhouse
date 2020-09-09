from DBUtils.PooledDB import PooledDB
import pymysql
import os
from flask_loguru import logger
from config import config

mysql_config = config['mysql']

pool = PooledDB(
    creator=pymysql,  # 使用链接数据库的模块
    maxconnections=10,  # 连接池允许的最大连接数，0和None表示不限制连接数
    mincached=5,  # 初始化时，链接池中至少创建的空闲的链接，0表示不创建
    maxcached=5,  # 链接池中最多闲置的链接，0和None不限制
    maxshared=3,
    # 链接池中最多共享的链接数量，0和None表示全部共享。PS: 无用，因为pymysql和MySQLdb等模块的 threadsafety都为1，所有值无论设置为多少，_maxcached永远为0，所以永远是所有链接都共享。
    blocking=True,  # 连接池中如果没有可用连接后，是否阻塞等待。True，等待；False，不等待然后报错
    maxusage=None,  # 一个链接最多被重复使用的次数，None表示无限制
    setsession=[],  # 开始会话前执行的命令列表。如：["set datestyle to ...", "set time zone ..."]
    ping=0,
    # ping MySQL服务端，检查是否服务可用。# 如：0 = None = never, 1 = default = whenever it is requested, 2 = when a cursor is
    # created, 4 = when a query is executed, 7 = always
    host=mysql_config['host'],
    port=mysql_config['port'],
    user=mysql_config['user'],
    password=mysql_config['password'],
    database=mysql_config['db'],
    charset=mysql_config['charset']
)


class MysqlOp:
    conn = None
    cur = None

    def __init__(self):
        try:
            self.pool = pool
            self.conn = pool.connection()
            self.cur = self.conn.cursor(pymysql.cursors.DictCursor)
        except pymysql.Error as e:
            logger.error("服务器连接失败！")
            logger.exception(e)

    def op_sql(self, query, params=None):
        '''
        单条数据的操作，insert，update，delete
        :param query:包含%s的sql字符串，当params=None的时候，不包含%s
        :param params:一个元祖，默认为None
        :return:如果执行过程没有crash，返回True，反之返回False
        '''
        try:
            self.cur.execute(query, params)
            self.conn.commit()
            return True
        except BaseException as e:
            self.conn.rollback()  # 如果这里是执行的执行存储过程的sql命令，那么可能会存在rollback的情况，所以这里应该考虑到
            logger.info("[sql_query] - %s" % query)
            logger.info("[sql_params] - %s" % (params,))
            logger.exception(e)
            return False

    def select_one(self, query, params=None):
        '''
        查询数据表的单条数据
        :param query: 包含%s的sql字符串，当params=None的时候，不包含%s
        :param params: 一个元祖，默认为None
        :return: 如果执行未crash，并以包含dict的列表的方式返回select的结果，否则返回错误代码001
        '''
        try:
            self.cur.execute(query, params)
            # self.cur.scroll(0, "absolute")  # 光标回到初始位置，感觉自己的这句有点多余
            return self.cur.fetchone()
        except BaseException as e:
            logger.info("[sql_query] - %s" % query)
            logger.info("[sql_params] - %s" % params)
            logger.exception(e)
            return None  # 错误代码001

    def select_all(self, query, params=None):
        '''
        查询数据表的单条数据
        :param query:包含%s的sql字符串，当params=None的时候，不包含%s
        :param params:一个元祖，默认为None
        :return:如果执行未crash，并以包含dict的列表的方式返回select的结果，否则返回错误代码001
        '''
        try:
            self.cur.execute(query, params)
            # self.cur.scroll(0, "absolute")  # 光标回到初始位置，感觉这里得这句有点多余
            return self.cur.fetchall()
        except BaseException as e:
            logger.info("[sql_query] - %s" % query)
            logger.info("[sql_params] - %s" % params)
            logger.exception(e)
            return None  # 错误代码001

    def insert_many(self, query, params):
        '''
        向数据表中插入多条数据
        :param query:包含%s的sql字符串，当params=None的时候，不包含%s
        :param params:一个内容为元祖的列表
        :return:如果执行过程没有crash，返回True，反之返回False
        '''
        try:
            self.cur.executemany(query, params)
            self.conn.commit()
            return True
        except BaseException as e:
            self.conn.rollback()
            logger.info("[sql_query] - %s" % query)
            logger.info("[sql_params] - %s" % params)
            logger.exception(e)
            return False

    def __del__(self):
        '''
        当该对象的引用计数为0的时候，python解释器会自动执行__dell__方法，自动释放游标和链接
        '''
        self.cur.close()
        self.conn.close()
