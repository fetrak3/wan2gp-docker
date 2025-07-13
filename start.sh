#!/bin/bash
set -e

cd /workspace

if [ ! -d "Wan2GP" ]; then
    git clone https://github.com/deepbeepmeep/Wan2GP.git
fi

cd Wan2GP

pip install --upgrade pip wheel
pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124
pip install -r requirements.txt
pip install flash-attn==2.7.2.post1 jupyterlab

jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token="" --NotebookApp.password="" &

python wgp.py --i2v --profile 3 --listen --server-port 7860 --attention flash
