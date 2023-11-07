# HTTPBin Nginx Compose



在本地搭建 httpbin 服务，同时在前面搭建两层 OpenResty，用于模拟存在多层 Nginx，分别作为入口反向代理和 API 网关的场景。



## 必备环境

- Docker
- Docker Compose
- Bash 及兼容 Shell



## 使用指南

OS X & Linux:

常用命令：

```bash
# 启动
access-httpbin.sh [on]

# 停止
access-httpbin.sh off

# 显示帮助
access-httpbin.sh -h
```



详细说明：

```
access-httpbin.sh -h

Usage:
  access-httpbin.sh [options] [access_type]

Options:
  -h                                 Show this help.

  -o <outer_nginx_port>              Specify the outer nginx port (default: 12345).
  -i <inner_nginx_port>              Specify the inner nginx port (default: 12346).
  -b <original_httpbin_port>         Specify the original httpbin service port (default: 12347).
  -p <root_path>                     Specify the tool files directory (default: this script path).

Access Type:
  on                                 Startup services (default).
  off                                Shutdown services.
```



Windows: 暂无可用脚本。

