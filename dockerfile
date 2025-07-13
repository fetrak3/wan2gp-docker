# Dockerfile for Wan2GP compatible with RTX 10XX–40XX (CUDA 12.4, PyTorch 2.6.0) + JupyterLab

FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install core utilities and Python 3.10
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip \
    git \
    build-essential \
    cmake \
    ninja-build && \
    ln -sf /usr/bin/python3.10 /usr/bin/python && \
    python -m pip install --upgrade pip

# Clone the Wan2GP repository
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git /workspace/Wan2GP
WORKDIR /workspace/Wan2GP

# Create venv and activate it, install dependencies + JupyterLab
RUN python -m venv wan2gp && \
    . wan2gp/bin/activate && \
    pip install --upgrade pip && \
    pip install wheel && \
    pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124 && \
    pip install -r requirements.txt && \
    pip install flash-attn==2.7.2.post1 --no-build-isolation --no-cache-dir && \
    pip install jupyterlab

# Expose Gradio and JupyterLab ports
EXPOSE 7860
EXPOSE 8888

# Default command: launch both Gradio and JupyterLab
CMD . wan2gp/bin/activate && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' & \
    python wgp.py --i2v --profile 3 --attention flash --listen --server_port 7860
