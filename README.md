# Spring Cloud 应用中间件部署

这是一个使用 Docker Compose 部署 Spring Cloud 应用所需中间件（MySQL、Redis、Nacos、Seata、Sentinel 和 RabbitMQ）的项目。

## 目录结构

```
.
├── .env                  # 环境变量配置文件
├── docker-compose.yml    # Docker Compose 主配置文件
├── init/                 # 初始化脚本目录
│   ├── 01-create-users.sql  # MySQL用户初始化脚本
│   ├── 02-check-users.sql   # MySQL用户权限检查脚本
│   ├── 03-seata.sql         # Seata数据库初始化脚本
│   └── 04-nacos.sql         # Nacos数据库初始化脚本
├── config/               # 配置文件目录
│   ├── mysql.cnf         # MySQL 配置文件
│   └── redis.conf        # Redis 配置文件
├── seata/                # Seata配置目录
│   └── config/           # Seata配置文件目录
│       └── application.yml  # Seata主配置文件
├── nacos/                # Nacos配置目录
│   └── conf/             # Nacos配置文件目录
│       └── application.properties  # Nacos主配置文件
└── README.md             # 说明文档
```

## 配置说明

### 环境变量配置 (.env)

包含所有敏感信息和基本配置：

- `MYSQL_ROOT_PASSWORD`: MySQL root 用户密码
- `REDIS_PASSWORD`: Redis 密码

### MySQL 配置 (config/mysql.cnf)

主要配置项包括：
- 字符集设置 (utf8mb4)
- 连接数限制
- InnoDB 存储引擎优化
- 慢查询日志设置
- 网络设置（skip-name-resolve等）

### Redis 配置 (config/redis.conf)

主要配置项包括：
- 网络设置
- 密码认证
- 持久化设置 (AOF)
- 内存限制和淘汰策略

### Nacos 配置 (nacos/config/application.properties)

主要配置项包括：
- 数据库连接配置
- 网络配置
- 认证配置
- 其他高级配置

### Seata 配置 (seata/config/application.yml)

主要配置项包括：
- 注册中心配置（默认使用Nacos）
- 配置中心配置（默认使用Nacos）
- 存储模式配置（使用db模式）
- 数据库连接配置（默认使用MySQL）



## 使用方法

1. 根据需要修改 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中的密码和其他配置项
2. 可选：根据需要调整 以下配置文件：
   1. [config/mysql.cnf](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/config/mysql.cnf)
   2. [config/redis.conf](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/config/redis.conf)
   3. [nacos/config/application.properties](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/nacos/config/application.properties) 
   4. [seata/config/application.yml](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/seata/config/application.yml)
3. 在当前目录下执行以下命令启动所有服务：

```bash
docker-compose up -d
```

4. 检查服务状态：

```bash
docker-compose ps
```

5. 查看服务日志：

```bash
# 查看 MySQL 日志
docker-compose logs mysql

# 查看 Redis 日志
docker-compose logs redis

# 查看 Nacos 日志
docker-compose logs nacos

# 查看 Seata 日志
docker-compose logs seata

# 查看 Sentinel 日志
docker-compose logs sentinel

# 查看 RabbitMQ 日志
docker-compose logs rabbitmq
```

6. 停止服务：

```bash
docker-compose down
```

## 连接信息

服务启动后，可以使用以下信息连接：

### MySQL
- Host: localhost (本地) 或服务器IP地址 (远程)
- Port: 3306
- Root Password: 查看 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中的 `MYSQL_ROOT_PASSWORD`
- Database: 查看 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中的 `MYSQL_DATABASE`
- User: 查看 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中的 `MYSQL_USER`
- Password: 查看 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中的 `MYSQL_PASSWORD`

### Redis
- Host: localhost (本地) 或服务器IP地址 (远程)
- Port: 6379
- Password: 查看 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中的 `REDIS_PASSWORD`

### Nacos
- Host: localhost (本地) 或服务器IP地址 (远程)
- Port: 8848
- Console: http://localhost:8080/nacos
- Username: nacos
- Password: nacos

### Seata
- Host: localhost (本地) 或服务器IP地址 (远程)
- Port: 8091
- Console: http://localhost:8091
- Username: seata
- Password: seata

### Sentinel
- Host: localhost (本地) 或服务器IP地址 (远程)
- Port: 8858
- Console: http://localhost:8858
- Username: sentinel
- Password: sentinel



### RabbitMQ
- Host: localhost (本地) 或服务器IP地址 (远程)
- AMQP Port: 5672
- Management Port: 15672
- Console: http://localhost:15672
- Username: admin
- Password: admin123

## 数据持久化

本配置使用 Docker Volume 实现数据持久化，即使容器被删除，数据也不会丢失：
- MySQL 数据存储在 `mysql_data` Volume 中
- MySQL 日志存储在 `mysql_logs` Volume 中
- Redis 数据存储在 `redis_data` Volume 中
- RabbitMQ 数据存储在 `rabbitmq_data` Volume 中

## 镜像拉取问题解决方案

如果遇到无法拉取 Docker 镜像的问题，请尝试以下解决方案：

### 1. 使用国内镜像加速器

在 `/etc/docker/daemon.json` 中添加以下内容：
```json
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
```

然后重启 Docker 服务：
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 2. 使用腾讯云镜像仓库

当前配置已使用腾讯云公共镜像仓库，如果仍有问题请尝试手动拉取：

```bash
docker pull ccr.ccs.tencentyun.com/public/mysql:8.4
docker pull ccr.ccs.tencentyun.com/public/redis:7.4

docker tag ccr.ccs.tencentyun.com/public/mysql:8.4 mysql:8.4
docker tag ccr.ccs.tencentyun.com/public/redis:7.4 redis:7.4
```

## 密码配置说明

### MySQL密码
MySQL密码通过环境变量方式传入容器，包括root密码、默认数据库和用户信息。

### Redis密码
Redis密码通过启动命令直接传入，使用`--requirepass`参数设置密码。

## 远程连接配置说明

### MySQL远程连接
为了允许从远程主机连接MySQL，我们采取了以下措施：
1. 设置 `bind-address=0.0.0.0` 允许监听所有网络接口
2. 使用 `--default-authentication-plugin=mysql_native_password` 确保兼容性
3. 通过初始化脚本创建可以从任意主机连接的用户 (`'root'@'%'` 和 `'${MYSQL_USER}'@'%'`)
4. 添加 `skip-name-resolve` 配置避免DNS解析问题

### Nacos配置
Nacos配置为监听8848端口，控制台访问地址为 http://localhost:8848/nacos，默认用户名和密码都是nacos。
Nacos使用MySQL作为后端存储，相关表结构已在初始化脚本中创建。

### Redis远程连接
Redis已经配置为监听所有网络接口，且可以通过密码认证连接。

### Seata配置
Seata配置为监听8091端口，控制台访问地址为 http://localhost:8091，默认用户名和密码都是seata。

### Sentinel配置
Sentinel配置为监听8858端口（容器内8858端口），控制台访问地址为 http://localhost:8858，默认用户名和密码都是sentinel。



### RabbitMQ配置
RabbitMQ配置为监听两个端口：
- 5672: AMQP协议端口，用于应用程序连接
- 15672: 管理界面端口，用于Web控制台访问
默认用户名和密码都是admin/admin123

## 常见问题及解决方案

### 1. MySQL连接报错 1045 - Access denied
这通常是因为用户权限问题。解决方案：
- 确保使用正确的用户名和密码
- 确认用户具有从你的IP地址连接的权限（'username'@'%'）
- 如果之前运行过容器，需要删除数据卷重新初始化
- 注意：SQL初始化脚本中不能使用环境变量语法，需要直接写入实际值

### 2. MySQL连接报错 2013 - Lost connection to server at 'handshake: reading initial communication packet'
这通常是由于网络配置问题引起的，解决方案：
- 在MySQL配置中添加 `skip-name-resolve` 避免DNS解析问题
- 增加连接超时设置
- 确保防火墙没有阻止3306端口

### 3. Redis连接问题
如果Redis连接出现问题：
- 检查是否正确设置了密码
- 确保防火墙没有阻止6379端口

## 重新部署步骤

如果你已经部署过服务并遇到连接问题，请按以下步骤操作：

1. 停止并删除现有容器和数据卷：
   ```bash
   docker-compose down -v
   ```

2. 重新启动服务：
   ```bash
   docker-compose up -d
   ```

3. 检查初始化脚本是否正确执行：
   ```bash
   docker-compose logs mysql
   ```

4. 等待MySQL完全启动后，再尝试远程连接

## 后续扩展

如需添加更多中间件，可以在 [docker-compose.yml](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/docker-compose.yml) 文件中添加相应的服务定义，并在 [.env](file:///c%3A/DevelopmentProjectFiles/PigxProject/middlewares/.env) 文件中添加相关配置。