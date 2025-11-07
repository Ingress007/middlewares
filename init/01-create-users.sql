-- 创建允许从任何主机连接的root用户
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'root123456';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- 设置root@localhost用户也使用新密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123456';
GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

-- 刷新权限
FLUSH PRIVILEGES;