import multiprocessing

worker = multiprocessing.cpu_count() * 2 + 1
worker_class = "gevent"
bind = "0.0.0.0:9000"