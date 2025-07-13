FROM nvidia/cuda:12.4.1-runtime-ubuntu20.04

# Set up basics
RUN apt-get update && \
    apt-get install -y git python3.10 python3.10-venv python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Clone the repo & create virtualenv
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git /workspace/Wan2GP && \
    python -m venv /workspace/Wan2GP/wan2gp

WORKDIR /workspace/Wan2GP

# The actual installs & run will happen here
CMD . wan2gp/bin/activate && \
    pip install --upgrade pip && \
    pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124 && \
    pip install -r requirements.txt && \
    pip install wheel && \
    pip install flash-attn==2.7.2.post1 jupyterlab && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token="" --NotebookApp.password="" & \
    python wgp.py --i2v --profile 3 --listen --server-port 7860 --attention flash
