FROM mongo:5.0.5

RUN apt-get update
RUN apt install -y zip python3 python3-pip

RUN pip3 install awscli awscli-plugin-endpoint

COPY ./config/config /root/.aws/config
COPY ./config/credentials /root/.aws/credentials

ADD backup.sh backup.sh

CMD ["sh", "backup.sh"]
