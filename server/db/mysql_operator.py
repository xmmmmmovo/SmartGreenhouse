import pymysql
import os
from logging import getLogger

logger = getLogger(__name__)


class MysqlOp:
    conn = None
    cur = None

    def __init__(self, host='119.3.166.63', port=3306, user='root',
                 password='123456', db='test', charset='utf8'):
        try:
            self.conn = pymysql.connect(
                host=host, port=port, user=user,
                password=password, db=db, charset=charset)
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
