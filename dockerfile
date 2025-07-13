FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system Python 3.10, pip, git
RUN apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3-pip git curl && \
    ln -sf python3.10 /usr/bin/python && \
    ln -sf pip3 /usr/bin/pip && \
    apt-get clean

WORKDIR /workspace

CMD bash -c '\
    git clone https://github.com/deepbeepmeep/Wan2GP.git && \
    cd Wan2GP && \
    pip install --upgrade pip wheel && \
    pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124 && \
    pip install -r requirements.txt && \
    pip install flash-attn==2.7.2.post1 jupyterlab && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token="" --NotebookApp.password="" & \
    python wgp.py --i2v --profile 3 --listen --server-port 7860 --attention flash \
'
