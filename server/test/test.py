from db import MysqlOp

a = MysqlOp().select_one("SELECT id, username FROM `user` WHERE username = 'a' AND id IN (SELECT user_roles.user_id FROM user_roles WHERE user_roles.role_id IN (SELECT role.id FROM role WHERE role.`name` = 'admin'))")
print(a)