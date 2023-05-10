FROM ubuntu:20.04
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy curl && \
    apt-get install -y unzip && \
    apt-get -y install jq    
RUN apt-get update && apt-get install -y gnupg wget
## Add PPA MongoDB Repository for libmongocryptd
RUN wget -qO - https://www.mongodb.org/static/pgp/libmongocrypt.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/libmongocrypt.gpg
RUN echo "deb [ arch=amd64,arm64 ] https://libmongocrypt.s3.amazonaws.com/apt/ubuntu focal/libmongocrypt/1.7 universe" | tee /etc/apt/sources.list.d/libmongocrypt.list
# Install libmongocryptd
RUN apt-get update && apt-get install -y  python3.8 python3-pip libmongocrypt0
RUN python3 -m pip install -U pip
COPY requirements.txt .
RUN pip install -r requirements.txt
# Install crypt_shared library for Ubuntu 20.04, for more information see https://www.mongodb.com/docs/manual/core/queryable-encryption/reference/shared-library/#download-the-automatic-encryption-shared-library
COPY mongo_crypt_v1.so /usr/local/lib/mongo_crypt_v1.so