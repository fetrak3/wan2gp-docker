FROM python:3.10-slim

# System deps for pip packages, building flash-attn, and UI
RUN apt-get update && apt-get install -y \
    git build-essential cmake curl libgl1 \
    && apt-get clean

# Set working directory (aligns with RunPod volume mount)
WORKDIR /workspace

# Upgrade pip + install basics
RUN pip install --upgrade pip setuptools wheel

# CMD runs everything at container start
CMD bash -c '\
    python3 -m venv wan2gp && \
    . wan2gp/bin/activate && \
    git clone https://github.com/deepbeepmeep/Wan2GP.git /workspace/Wan2GP && \
    cd /workspace/Wan2GP && \
    pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124 && \
    pip install -r requirements.txt && \
    pip install flash-attn==2.7.2.post1 jupyterlab && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token="" --NotebookApp.password="" & \
    python wgp.py --i2v --profile 3 --listen --server-port 7860'
