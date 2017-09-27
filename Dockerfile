FROM alpine:3.6

EXPOSE 8089

ENV PYZMQ_VERSION="==16.0.2"
ENV ZEROMQ_VERSION="4.2.2"

RUN apk --no-cache --update add ca-certificates python python-dev gcc g++

RUN apk add --no-cache build-base git libtool pkgconfig autoconf automake wget && \
    wget "https://bootstrap.pypa.io/get-pip.py" -O /dev/stdout | python && \
    pip install pyzmq${PYZMQ_VERSION} && \
    cd /tmp && \
    wget https://github.com/zeromq/libzmq/releases/download/v${ZEROMQ_VERSION}/zeromq-${ZEROMQ_VERSION}.tar.gz && \
    tar -xzf zeromq-${ZEROMQ_VERSION}.tar.gz && \
    cd zeromq-${ZEROMQ_VERSION} && \
    ./autogen.sh && ./configure && make && make install && \
    rm -rf /tmp/zeromq-${ZEROMQ_VERSION}* && rm -rf /tmp/* && \
    apk add --no-cache libstdc++

RUN pip install locustio boto3

ADD . /locust

WORKDIR /locust

RUN chmod +x /locust/start.sh

CMD /locust/start.sh