FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3-pip git curl && \
    ln -sf python3.10 /usr/bin/python && \
    ln -sf pip3 /usr/bin/pip && \
    apt-get clean

WORKDIR /workspace

COPY start.sh /workspace/start.sh
RUN chmod +x /workspace/start.sh

CMD ["/workspace/start.sh"]
