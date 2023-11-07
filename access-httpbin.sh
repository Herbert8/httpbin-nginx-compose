#!/bin/bash

# Bash 脚本 set 命令教程
# http://www.ruanyifeng.com/blog/2017/11/bash-set.html
set -o errexit
# set -o xtrace
set -o nounset
set -o pipefail


show_help () {
    cat << EOF

Usage:
  $(basename "${BASH_SOURCE[0]}") [options] [access_type]

Options:
  -h                                 Show this help.

  -o <outer_nginx_port>              Specify the outer nginx port (default: 12345).
  -i <inner_nginx_port>              Specify the inner nginx port (default: 12346).
  -b <original_httpbin_port>         Specify the original httpbin service port (default: 12347).
  -p <root_path>                     Specify the tool files directory (default: this script path).

Access Type:
  on                                 Startup services (default).
  off                                Shutdown services.

EOF

}

# 脚本所在路径作为基础路径
base_path_docker_compose () {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd)"
}


procress_args () {

    ACCESS_TYPE=${ACCESS_TYPE:-on}

    export HTTPBIN_OUTER_NGINX_PORT=${HTTPBIN_OUTER_NGINX_PORT:-12345}
    export HTTPBIN_INNER_NGINX_PORT=${HTTPBIN_INNER_NGINX_PORT:-12346}
    export HTTPBIN_ORIGINAL_PORT=${HTTPBIN_ORIGINAL_PORT:-12347}
    export HTTPBIN_ROOT_PATH=${HTTPBIN_ROOT_PATH:-$(base_path_docker_compose)}

    while getopts "o:i:b:r:h" opt_name; do              # 通过循环，使用 getopts，按照指定参数列表进行解析，参数名存入 opt_name
        case "$opt_name" in                           # 根据参数名判断处理分支
        'o')                                          # -u
            export HTTPBIN_OUTER_NGINX_PORT="$OPTARG" # 从 $OPTARG 中获取参数值
            ;;
        'i')
            export HTTPBIN_INNER_NGINX_PORT="$OPTARG"
            ;;
        'b')
            export HTTPBIN_ORIGINAL_PORT="$OPTARG"
            ;;
        'r')
            export HTTPBIN_ROOT_PATH="$OPTARG"
            ;;
        'h')
            show_help
            exit 1
            ;;
        ?) # 其它未指定名称参数
            echo "Unknown argument(s)."
            exit 2
            ;;
        esac
    done

    shift $((OPTIND-1))

    ACCESS_TYPE=${1:-on}
}



show_and_run_cmd_line () {
    local cmd_line=$1
    echo "$cmd_line"
    eval "$cmd_line"
}


main () {

    # docker-compose 文件
    local DOCKER_COMPOSE_FILE
    DOCKER_COMPOSE_FILE=$(base_path_docker_compose)/httpbin-compose.yml

    # 处理参数
    procress_args "$@"

    local PROJECT_NAME
    PROJECT_NAME=$(basename "${HTTPBIN_ROOT_PATH}")

    if [[ "$ACCESS_TYPE" == "on" ]]; then
        docker-compose --file "${DOCKER_COMPOSE_FILE}" --project-name "${PROJECT_NAME}" up -d
        echo '==========================='
        echo 'Test httpbin availability:'
        show_and_run_cmd_line "ncat -zv localhost ${HTTPBIN_OUTER_NGINX_PORT}"
        ncat_ret=$?
        echo '==========================='
        show_and_run_cmd_line "curl -v 'http://localhost:${HTTPBIN_OUTER_NGINX_PORT}/ip'"
        curl_ret=$?
        if [[ "0" -eq "$ncat_ret" && "0" -eq "$curl_ret" ]]; then
            echo
            echo '*****************************'
            echo -e "HTTPBin with Outer Nginx Port:\t\t[ $HTTPBIN_OUTER_NGINX_PORT ]"
            echo -e "HTTPBin with Inner Nginx Port:\t\t[ $HTTPBIN_INNER_NGINX_PORT ]"
            echo -e "HTTPBin Original Port:\t\t\t[ $HTTPBIN_ORIGINAL_PORT ]"
            echo -e "HTTPBin Nginx Compose Project Name:\t[ $PROJECT_NAME ]"
            echo -e "HTTPBin Nginx Compose Root:\t\t[ $HTTPBIN_ROOT_PATH ]"
        fi
    else
        docker-compose --file "${DOCKER_COMPOSE_FILE}" --project-name "${PROJECT_NAME}" down
    fi
}

main "$@"
















