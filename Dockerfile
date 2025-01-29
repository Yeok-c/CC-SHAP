# ARG UBUNTU_VER=22.04
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PY_VER=3.11
ARG PANDAS_VER=2.2.3
# FROM ubuntu:${UBUNTU_VER}
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04
# FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

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


ARG PY_VER
# ARG PANDAS_VER

RUN cd /workspace \
    && git clone https://github.com/Yeok-c/CC-SHAP \
    && cd CC-SHAP \
    && git submodule update --init

    # Install packages from conda 
RUN conda create -n cc_shap python==${PY_VER} --yes \
    && conda init --all

SHELL ["conda", "run", "-n", "cc_shap", "/bin/bash", "-c"]

RUN conda install --file /workspace/CC-SHAP/requirements.txt -c conda-forge --yes 

RUN cd /workspace/CC-SHAP \
    && python -m spacy download en_core_web_sm \
    && pip install sentencepiece \
    && python wordnet_download.py