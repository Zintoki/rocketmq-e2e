#!/bin/sh

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Detection distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
elif [ -f /etc/debian_version ]; then
    DISTRO="Debian"
else
    DISTRO=$(uname -s)
fi

DISTRO_LOWER=$(echo "$DISTRO" | tr '[:upper:]' '[:lower:]')

# Select the package manager and install commands based on your distribution
if [ "$DISTRO_LOWER" == "ubuntu" ] || [ "$DISTRO_LOWER" == "debian" ]; then
    PACKAGE_MANAGER="apt-get"
    INSTALL_COMMAND="sudo $PACKAGE_MANAGER install -y"
    $INSTALL_COMMAND libssl-dev libboost-all-dev libspdlog-dev libgtest-dev libfmt-dev libbz2-dev zlib1g-dev libc6-dev libpthread-stubs0-dev cmake automake g++ autoconf libtool
else
    echo "You need to install the corresponding package in distribution: $DISTRO"
    exit 1
fi

if [ ! -d "rocketmq-client-cpp-2.1.0" ]; then
    echo "rocketmq-client-cpp-2.1.0 folder does not exist, start to download and decompress..."
    curl -LO https://github.com/apache/rocketmq-client-cpp/archive/refs/tags/2.1.0.zip
    if [ ! -f "2.1.0.zip" ]; then
        echo "rocketmq-client-cpp-2.1.0.zip file does not exist"
        exit 1
    fi
    unzip 2.1.0.zip
    rm 2.1.0.zip
    echo "rocketmq-client-cpp-2.1.0 Download and decompress complete."
    cd rocketmq-client-cpp-2.1.0
    bash build.sh
    cd ..
fi

if [ ! -d "rocketmq-client-cpp-2.1.0/tmp_build_dir" ]; then
    if [ ! -f "rocketmq-client-cpp-2.1.0/tmp_build_dir/librocketmq.a" ]; then
        echo "librocketmq.a file does not exist, start to build..."
        exit 1
    fi
fi

if [ ! -d "rocketmq-client-cpp-2.1.0/tmp_include_dir" ]; then
    mkdir -p rocketmq-client-cpp-2.1.0/tmp_include_dir/rocketmq
    cp -r rocketmq-client-cpp-2.1.0/include/* rocketmq-client-cpp-2.1.0/tmp_include_dir/rocketmq
fi

export ROCKETMQ_CPP_LIB=$(pwd)/rocketmq-client-cpp-2.1.0/tmp_build_dir

export ROCKETMQ_CPP_INC=$(pwd)/rocketmq-client-cpp-2.1.0/tmp_include_dir

echo "Installation complete!"
# cd project base dir to compile mqadmin utils for other language e2e test using
cd ../common &&  mvn -Prelease -DskipTests clean package -U
# set env for mqadmin (use source to set linux env variables in current shell)
cd ../rocketmq-admintools && source bin/env.sh
# run cpp e2e test case
cd ../cpp/rocketmq-client-cpp-tests/cpp4.x
cmake . -B build && cd build
make -j && cd ..
./rocketmq_test --gtest_output=xml:rocketmq_cpp_test.xml
