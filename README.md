# Keycloak Server

Keycloak 身份认证和授权服务器部署方案。

## 项目结构

```
keycloak-server/
├─ docker-compose.yml          # 开发环境配置
├─ docker-compose.prod.yml     # 生产环境配置
├─ .env.example                # 环境变量示例
├─ nginx.conf                  # Nginx 反向代理配置
├─ start.sh / start.bat        # 开发环境启动脚本
├─ start-prod.sh / start-prod.bat  # 生产环境启动脚本
└─ ssl/                        # SSL 证书目录（需自行创建）
```

## 开发环境部署

### 快速启动

Windows:
```bash
start.bat
```

Linux/Mac:
```bash
chmod +x start.sh
./start.sh
```

### 访问信息

- 管理控制台: http://localhost:8080/admin
- 默认用户名: admin
- 默认密码: admin

### 停止服务

```bash
docker compose down
```

## 生产环境部署

### 前置要求

1. 准备域名并配置 DNS 解析到服务器
2. 获取 SSL 证书（推荐使用 Let's Encrypt）

### 配置步骤

1. 复制环境变量文件：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，修改以下配置：
```env
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=your_secure_password_here

KEYCLOAK_HOSTNAME=your-domain.com
KEYCLOAK_HOSTNAME_STRICT=true
KEYCLOAK_HOSTNAME_STRICT_HTTPS=true
KC_HTTP_ENABLED=false
KC_PROXY=edge

POSTGRES_DB=keycloak
POSTGRES_USER=keycloak
POSTGRES_PASSWORD=your_db_password_here
```

3. 编辑 `nginx.conf`，修改域名：
```nginx
server_name your-domain.com;
```

4. 获取 SSL 证书：

使用 Let's Encrypt certbot：
```bash
certbot certonly --standalone -d your-domain.com
```

证书文件位置：
- `/etc/letsencrypt/live/your-domain.com/fullchain.pem`
- `/etc/letsencrypt/live/your-domain.com/privkey.pem`

复制证书到项目目录：
```bash
mkdir ssl
cp /etc/letsencrypt/live/your-domain.com/fullchain.pem ssl/
cp /etc/letsencrypt/live/your-domain.com/privkey.pem ssl/
```

### 启动生产环境

Windows:
```bash
start-prod.bat
```

Linux/Mac:
```bash
chmod +x start-prod.sh
./start-prod.sh
```

### 访问信息

- 管理控制台: https://your-domain.com/admin
- 用户名: admin
- 密码: 您在 .env 中设置的密码

### 停止服务

```bash
docker compose -f docker-compose.prod.yml down
```

## 生产环境特性

- 使用 PostgreSQL 数据库（替代 H2）
- Nginx 反向代理 + SSL/TLS 加密
- 健康检查和监控端点
- 数据持久化
- 自动重启策略
- 严格的 HTTPS 配置

## 常见问题

### SSL 错误 (ssl_required)

确保：
1. 已配置有效的 SSL 证书
2. `KC_HTTP_ENABLED=false` 已设置
3. `KEYCLOAK_HOSTNAME_STRICT_HTTPS=true` 已设置
4. Nginx 配置正确

### 数据库连接失败

检查：
1. PostgreSQL 容器是否正常运行
2. 数据库凭据是否正确
3. 网络连接是否正常

### 端口冲突

修改 `.env` 文件中的端口配置：
```env
KEYCLOAK_HTTP_PORT=8080
NGINX_HTTP_PORT=80
NGINX_HTTPS_PORT=443
```

## 安全建议

1. 修改默认管理员密码
2. 使用强密码保护数据库
3. 定期更新 SSL 证书
4. 配置防火墙规则
5. 启用日志监控
6. 定期备份数据

## 备份数据

备份 PostgreSQL 数据：
```bash
docker exec keycloak-db pg_dump -U keycloak keycloak > backup.sql
```

恢复数据：
```bash
docker exec -i keycloak-db psql -U keycloak keycloak < backup.sql
```

## 查看日志

开发环境：
```bash
docker compose logs -f
```

生产环境：
```bash
docker compose -f docker-compose.prod.yml logs -f
```

查看特定服务日志：
```bash
docker compose -f docker-compose.prod.yml logs -f keycloak
docker compose -f docker-compose.prod.yml logs -f nginx
```
