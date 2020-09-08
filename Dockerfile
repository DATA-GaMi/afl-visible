FROM ubuntu:16.04
MAINTAINER d974513857
LABEL description="Dockerfile for afl-visivle base image"

#基本库安装
RUN apt-get update
RUN apt-get install -y ssh vim wget curl git nano libtool libtool-bin glib2.0 libpixman-1-dev htop autoconf automake build-essential apt-transport-https cmake sudo software-properties-common gperf libselinux1-dev  bison texinfo flex zlib1g-dev libexpat1-dev libmpg123-dev python3-pip python-pip unzip pkg-config apt-utils gcc g++ gcc-5-plugin-dev
RUN systemctl enable ssh
# /lib/systemd/systemd-sysv-install enable ssh
#安装llvm与clang
RUN echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main\ >> /etc/apt/sources.list.d/llvm.list
RUN echo deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main\ >> /etc/apt/sources.list.d/llvm.list
RUN apt-get update
RUN wget -c https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && bash llvm.sh 9
RUN apt-get install -y lld-9 lldb-9 clang-9
#安装AFL-visible
RUN git clone https://github.com/DATA-GaMi/afl-visible.git AFL-visible &&\
    cd AFL-visible && export DEMO_PATH=$PWD/demo && export TOOL_PATH=$PWD/visfuzz &&\
    cd $TOOL_PATH/fuzz && mkdir build &&\
    cd build && cmake ../llvm/  && make &&\
    export VISFUZZ_BUILD=$PWD &&\
    cd $TOOL_PATH/fuzz/afl &&\
    make distrib && make install &&\ 
    cd llvm_mode && make && make install && cd .. &&\
    cd $DEMO_PATH/re2 &&\
    git clone https://github.com/DATA-GaMi/repo.git &&\
    bash compile.sh
