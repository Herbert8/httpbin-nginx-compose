#!/bin/bash

# Bash 脚本 set 命令教程
# http://www.ruanyifeng.com/blog/2017/11/bash-set.html
set -o errexit
# set -o xtrace
set -o nounset
set -o pipefail


# 脚本所在路径作为基础路径
BASE_PATH_DOCKER_COMPOSE=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd)

ACCESS_TYPE=${1:-on}
export HTTPBIN_PORT=${2:-12345}
export HTTPBIN_ORIGINAL_PORT=${3:-12346}
export HTTPBIN_ROOT_PATH=${4:-${BASE_PATH_DOCKER_COMPOSE}}


# docker-compose 文件
DOCKER_COMPOSE_FILE=${BASE_PATH_DOCKER_COMPOSE}/httpbin-compose.yml


PROJECT_NAME=$(basename "${HTTPBIN_ROOT_PATH}")

show_and_run_cmd_line () {
    local cmd_line=$1
    echo "$cmd_line"
    eval "$cmd_line"
}

if [[ "$ACCESS_TYPE" == "on" ]]; then
    docker-compose --file "${DOCKER_COMPOSE_FILE}" --project-name "${PROJECT_NAME}" up -d
    echo '==========================='
    echo 'Test httpbin availability:'
    show_and_run_cmd_line "ncat -zv localhost ${HTTPBIN_PORT}"
    echo '==========================='
    show_and_run_cmd_line "curl -v 'http://localhost:${HTTPBIN_PORT}/ip'"
else
    docker-compose --file "${DOCKER_COMPOSE_FILE}" --project-name "${PROJECT_NAME}" down
fi