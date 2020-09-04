FROM python:3.7

COPY . /code
WORKDIR /code

RUN  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && pip install -r /code/requirements.txt
# 如果太慢了再加上这句 不然镜像站有可能同步不全导致包安装失败
# -i https://pypi.tuna.tsinghua.edu.cn/

CMD gunicorn app:app -c gunicorn.conf.py --error-logfile /log/gunicorn.log
