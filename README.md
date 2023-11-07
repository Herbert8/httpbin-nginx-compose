# HTTPBin Nginx Compose



在本地搭建 httpbin 服务，同时在前面搭建两层 OpenResty，用于模拟存在多层 Nginx，分别作为入口反向代理和 API 网关的场景。



## 必备环境

- Docker
- Docker Compose
- Bash 及兼容 Shell



## 使用指南

OS X & Linux:

```bash
# 启动
access-httpbin.sh [on]

# 停止
access-httpbin.sh off
```

Windows: 暂无可用脚本。

