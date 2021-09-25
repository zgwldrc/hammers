#!/bin/bash
# edit by owen@hoo.com at 2021-09-25
# install aliyun cli on ubuntu 20.04 focal
set -e
profile=${1:-""}
region=${2:-""}
akid=${3:-""}
aks=${4:-""}

function _aliyun_configure(){
    # configure without interactivity
    # non-interactively configure
    # aliyun configure set [--profile <profileName>] [--region <regionId>] ... [凭证选项]
    aliyun configure set \
    --profile ${profile} \
    --mode AK \
    --region ${region} \
    --access-key-id ${akid} \
    --access-key-secret ${aks}
}

function _usage(){
    echo Usage: $(basename "$0") '<profile> <region> <akid> <aks>'
}

function _aliyun_download(){
    local dl_url="https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz?spm=a2c4g.11186623.0.0.1e5239cfoE0syg&file=aliyun-cli-linux-latest-amd64.tgz"
    mkdir -p ~/bin
    wget -O- ${dl_url} | tar xz -C ~/bin
    test -x ~/bin/aliyun && return 0 || return 1
}


############################################# Run
# check num of arguments 
if [ "$#" -ne 4 ];then
    echo "Illegal number of arguments"
    _usage
    exit 1
fi
# install
# check wget installed
if which wget>/dev/null; then
    echo "wget installed, ready to download aliyun cli"
else
    echo "wget not installed, please install wget then retry"
    exit 2
fi

# check aliyun installed
if which aliyun>/dev/null; then
    echo "aliyun cli installed, ready to config profile"
else
    echo "aliyun cli not installed, prepare to installing..."
    _aliyun_download && (
        echo "~/bin/aliyun installed success"
        echo "add ~/bin/aliyun to your PATH env before using"
        echo "export PATH=~/bin:\${PATH}"
        echo "echo 'export PATH=~/bin:\${PATH}' >> ~/.bashrc"
    ) || (
        echo "~/bin/aliyun can not executable"
        echo "configure can not proceed"
        exit 1
    )
    PATH=~/bin:${PATH}
    echo "PATH is "$PATH
fi

# check aliyun 

_aliyun_configure && (
    echo "aliyun cli install and configure successfully..."
)