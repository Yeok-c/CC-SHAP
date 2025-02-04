# ARG UBUNTU_VER=22.04
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PY_VER=3.11
ARG PANDAS_VER=2.2.3
# FROM ubuntu:${UBUNTU_VER}
# FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

# System packages 
RUN apt-get update && apt-get install -yq curl wget jq vim

# Use the above args 
ARG CONDA_VER
ARG OS_TYPE
# Install miniconda to /miniconda
RUN curl -LO "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh"
RUN bash Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh -p /miniconda -b
RUN rm Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
ENV PATH=/miniconda/bin:${PATH} 
RUN conda update -y conda

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \ 
    apt-get install -y nano

RUN wget -O - https://gist.githubusercontent.com/Hazmi35/3ec6dbccc53c810f670d2680fcccc085/raw/dee78072c4074898175389e50c2ad23b74e54d8c/script.sh | sh -
# RUN (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
#     && sudo mkdir -p -m 755 /etc/apt/keyrings \
#         && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
#         && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
#     && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
#     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
#     && sudo apt update \
#     && sudo apt install gh -y
ARG PY_VER
# ARG PANDAS_VER

RUN cd /workspace \
    && git clone https://github.com/Yeok-c/CC-SHAP \
    && cd CC-SHAP \
    && git fetch \
    && git pull \
    && git submodule update --init


# Install packages from conda 
RUN conda create -n cc_shap python==${PY_VER} --yes \
    && conda init --all

# SHELL ["/bin/bash", "-c"]

SHELL ["conda", "run", "-n", "cc_shap", "/bin/bash", "-c"]

RUN echo "source activate cc_shap" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH


RUN conda install --file /workspace/CC-SHAP/requirements.txt -c conda-forge --yes 

RUN cd /workspace/CC-SHAP \
    && python -m spacy download en_core_web_sm \
    && pip install sentencepiece \
    && python wordnet_download.py

# Seems like somewhere it got replaced, reinstall
RUN conda install pytorch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 pytorch-cuda=11.8 -c pytorch -c nvidia



# RUN mv /workspace /workspace_bak

# Usage 
# docker build -t yeokch/cc-shap:<tag> .
# docker push yeokch/cc-shap:<tag>
# docker run -it --rm yeokch/cc-shap:<tag> /bin/bash