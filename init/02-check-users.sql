-- 检查用户权限设置
SELECT user, host FROM mysql.user WHERE user='root';

-- 检查数据库权限
SELECT user, host, db FROM mysql.db WHERE user='nacos';