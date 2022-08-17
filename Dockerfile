FROM ubuntu:20.04

ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive

RUN cd /home && \
	mkdir janus && \
	cd /home/janus/ && \
	mkdir cert

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
	sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
	apt-get clean && \
	apt-get update

RUN apt-get -y update && \
	apt-get install -y \
		libavutil-dev \
		libavformat-dev \
		libavcodec-dev \
		libmicrohttpd-dev \
		libjansson-dev \
		libssl-dev \
		libsofia-sip-ua-dev \
		libglib2.0-dev \
		libopus-dev \
		libogg-dev \
		libcurl4-openssl-dev \
		liblua5.3-dev \
		libconfig-dev \
		libusrsctp-dev \
		libwebsockets-dev \
		libnanomsg-dev \
		librabbitmq-dev \
		libnice-dev \
		pkg-config \
		gengetopt \
		libtool \
		automake \
		build-essential \
		wget \
		git \
		nginx \
		gtk-doc-tools \
		gdb \
		net-tools \
		vim 

RUN cd /home/janus && \
	wget https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz && \
	tar xfv v2.3.0.tar.gz && \
	cd libsrtp-2.3.0 && \
	./configure --prefix=/usr --enable-openssl && \
	make shared_library && \
	make install

RUN cd /home/janus && \
	git clone https://github.com/meetecho/janus-gateway.git && \
	cd janus-gateway && \
	sh autogen.sh && \
	./configure --enable-post-processing --prefix=/opt/janus && \
	make && \
	make install && \
	make configs

COPY janus.jcfg /opt/janus/etc/janus/
COPY janus.transport.http.jcfg /opt/janus/etc/janus/
COPY nginx.conf /etc/nginx/
COPY cert.pem /home/janus/cert/
COPY key.pem /home/janus/cert/

EXPOSE 8188
EXPOSE 8088
EXPOSE 8089
EXPOSE 8889
EXPOSE 8000
EXPOSE 7088
EXPOSE 7089
EXPOSE 443
EXPOSE 10000-10200/udp