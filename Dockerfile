## Temporary image to build the libraries and only save the needed artifacts
FROM ubuntu:20.04

# set non-interactive Docker build
ENV DEBIAN_FRONTEND=noninteractive

# TauDEM Dev variables
ARG taudem_dev_commit=bf9417172225a9ce2462f11138c72c569c253a1a
ARG taudem_dev_dir=/taudem
ARG taudem_dev_bin_dir=$taudem_dev_dir/bin
ENV taudem_dev_bin_dir=$taudem_dev_bin_dir

# TauDEM accelerated variables
ARG taudem_acc_commit=81f7a07cdd3721617a30ee4e087804fddbcffa88
ARG cybergis_dir=/cybergis
ARG taudem_acc_dir=$cybergis_dir/taudem
ARG taudem_acc_bin_dir=$taudem_acc_dir/build/bin
ENV taudem_acc_bin_dir=$taudem_acc_bin_dir

# TauDEM testing variables
ARG taudem_tests_commit=taudem_compare
ARG taudem_tests_dirs=/tests
ENV taudem_tests_dirs=$taudem_tests_dirs

## install dependencies from respositories
RUN apt-get --fix-missing update \
    && apt-get install -y \
    git=1:2.25.1-1ubuntu3 \
    cmake=3.16.3-1ubuntu1 \
    mpich=3.3.2-2build1 \
    gdal-bin=3.0.4+dfsg-1build3 \
    libgdal-dev=3.0.4+dfsg-1build3 \
    python3-pip=20.0.2-5ubuntu1.1 \
    && rm -rf /var/lib/apt/lists/* 

# Install Python modules
RUN pip3 install rasterio==1.1.8 

# clone taudem 
RUN git clone https://github.com/fernandoa123/cybergis-toolkit.git $cybergis_dir
RUN git clone https://github.com/dtarb/taudem.git $taudem_dev_dir

## make directories
RUN mkdir -p $taudem_acc_bin_dir $taudem_dev_bin_dir
RUN mkdir -p $taudem_tests_dirs

## Compile taudem ##
RUN cd $taudem_dev_dir \
    && git checkout $taudem_dev_commit \
    && cd src \
    && make

## Compile taudem repo with accelerated flow directions ##
RUN cd $taudem_acc_dir \
    && git checkout $taudem_acc_commit \
    && cd build \
    && cmake .. \
    && make

## ADD TO PATH
#ENV PATH=$taudem_acc_bin_dir:$PATH

## ADDING FIM GROUP ##
ARG GroupID=1370800235
ARG GroupName=fim
RUN addgroup --gid $GroupID $GroupName
RUN umask 002
RUN newgrp $GroupName 

# clone taudem tests
ADD . $taudem_tests_dirs

# Add tests to Path
ENV PATH=$taudem_tests_dirs:$PATH

## setup taudem tests
RUN cd $taudem_tests_dirs \
    && git checkout $taudem_tests_commit \
    && bash Input/prepare-test-env.sh

# add environment setting for python
ENV PYTHONUNBUFFERED=TRUE


