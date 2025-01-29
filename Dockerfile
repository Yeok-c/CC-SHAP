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
RUN conda init

ARG PY_VER
ARG PANDAS_VER
# Install packages from conda 

RUN conda create -n cc_shap python==${PY_VER} --yes
RUN conda activate cc_shap 
RUN conda install -c anaconda -y \
    pandas=${PANDAS_VER}
RUN conda install --file requirements.txt -c conda-forge --yes # I already updated requirement.txt to rule out 2025 unavailable packages 

RUN cd /workspace
RUN git clone https://github.com/Yeok-c/CC-SHAP
RUN cd CC-SHAP
RUN git submodule update --init

RUN python -m spacy download en_core_web_sm
RUN pip install sentencepiece
RUN python wordnet_download.py
