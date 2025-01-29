### On Runpod CUDA 11.8, Pytorch 2.1.0 container
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
conda init --all

conda create -n cc_shap python==3.11 --yes
conda activate cc_shap 

conda install --file requirements.txt -c conda-forge --yes # I already updated requirement.txt to rule out 2025 unavailable packages 

git submodule update --init

python -m spacy download en_core_web_sm

pip install sentencepiece


### Next you have to setup your huggingface
# - Tokens
# - This repo: https://huggingface.co/meta-llama/Llama-2-13b-chat-hf #(regardless of what model you're using). Takes a few hours for approval.
huggingface-cli login

### Running
# Run `python faithfulness.py [TASK] [MODEL] 100`.
# Example `python faithfulness.py comve llama2-7b-chat 100`

# I ran into a CUDA problem - no GPU detected
# https://stackoverflow.com/questions/60987997/why-torch-cuda-is-available-returns-false-even-after-installing-pytorch-with

