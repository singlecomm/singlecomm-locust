FROM python:3.6.3

EXPOSE 8089

ENV PYZMQ_VERSION="==16.0.2"
ENV ZEROMQ_VERSION="4.2.2"

RUN apt-get install ca-certificates python-dev gcc g++ build-base git libtool pkgconfig autoconf automake wget libstdc++ && \
    wget https://github.com/zeromq/libzmq/releases/download/v${ZEROMQ_VERSION}/zeromq-${ZEROMQ_VERSION}.tar.gz && \
    tar -xzf zeromq-${ZEROMQ_VERSION}.tar.gz && \
    cd zeromq-${ZEROMQ_VERSION} && \
    ./autogen.sh && ./configure && make && make install && \
    rm -rf /tmp/zeromq-${ZEROMQ_VERSION}* && rm -rf /tmp/* && \
	pip install locustio boto3 pyzmq${PYZMQ_VERSION}

ADD . /locust

WORKDIR /locust

RUN chmod +x /locust/start.sh

CMD /locust/start.sh