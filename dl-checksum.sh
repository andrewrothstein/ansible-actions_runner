#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/actions/runner/releases/download
APP=actions-runner

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local archive_type=${4:-tar.gz}
    local platform="${os}-${arch}"
    local file="${APP}-${platform}-${ver}.${archive_type}"
    local url="${MIRROR}/v${ver}/${file}"
    local lfile="${DIR}/${file}"

    printf "    # %s\n" $url
    if [ ! -e $lfile ];
    then
        curl -sSLf -o $lfile $url
    fi

    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dlver () {
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver linux arm
    dl $ver linux arm64
    dl $ver linux x64
    dl $ver osx arm64
    dl $ver osx x64
    dl $ver win x64 zip
}

dlver ${1:-2.293.0}
