FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.10, git, and venv tools
RUN apt-get update && \
    apt-get install -y git python3.10 python3-pip curl && \
    ln -sf python3.10 /usr/bin/python && \
    ln -sf pip3 /usr/bin/pip && \
    apt-get clean

# Create a working directory
WORKDIR /workspace

# Clone Wan2GP repo
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git

# Default command: set up venv + pip installs at runtime
CMD bash -c '\
    cd Wan2GP && \
    pip install --upgrade pip wheel && \
    pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124 && \
    pip install -r requirements.txt && \
    pip install flash-attn==2.7.2.post1 jupyterlab && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token=\"\" --NotebookApp.password=\"\" & \
    python wgp.py --i2v --profile 3 --listen --server-port 7860 --attention sage \
'
