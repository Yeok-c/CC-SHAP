# Yeok's fork
conda create -n cc_shap python==3.11
conda activate cc_shap

Install torch
https://pytorch.org/get-started/previous-versions/ # you may have to browse here, I used:

pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118

conda install --file requirements.txt -c conda-forge # I already updated requirement.txt to rule out 2025 unavailable packages 

pip install scipy transformers

python -m spacy download en_core_web_sm

### Next you have to setup your huggingface
- Tokens
- This repo: https://huggingface.co/meta-llama/Llama-2-13b-chat-hf #(regardless of what model you're using). Takes a few hours for approval.

### Running
Run `python faithfulness.py [TASK] [MODEL] 100`.
Example `python faithfulness.py comve gpt2`

I ran into a CUDA problem - no GPU detected
https://stackoverflow.com/questions/60987997/why-torch-cuda-is-available-returns-false-even-after-installing-pytorch-with

# CC-SHAP

This is the implementation of the paper "On Measuring Faithfulness or Self-Consistency of Natural Language Explanations" https://arxiv.org/abs/2311.07466 accepted at ACL 2024!

## Cite
```bibtex
@article{parcalabescu2023measuring,
  title={On measuring faithfulness or self-consistency of natural language explanations},
  author={Parcalabescu, Letitia and Frank, Anette},
  journal={Proceedings of the 62nd Annual Meeting of the Association for Computational Linguistics (ACL 2024)},
  year={2024},
  url      = {https://arxiv.org/abs/2311.07466},
  note = "to appear",
  abstract = "Large language models (LLMs) can explain their own predictions, through post-hoc or Chain-of-Thought (CoT) explanations. However the LLM could make up reasonably sounding explanations that are unfaithful to its underlying reasoning. Recent work has designed tests that aim to judge the faithfulness of either post-hoc or CoT explanations. In this paper we argue that existing faithfulness tests are not actually measuring faithfulness in terms of the models' inner workings, but only evaluate their self-consistency on the output level. The aims of our work are two-fold. i) We aim to clarify the status of existing faithfulness tests in terms of model explainability, characterising them as self-consistency tests instead. This assessment we underline by constructing a Comparative Consistency Bank for self-consistency tests that for the first time compares existing tests on a common suite of 11 open-source LLMs and 5 datasets -- including ii) our own proposed self-consistency measure CC-SHAP. CC-SHAP is a new fine-grained measure (not test) of LLM self-consistency that compares a model's input contributions to answer prediction and generated explanation. With CC-SHAP, we aim to take a step further towards measuring faithfulness with a more interpretable and fine-grained method.", 
}
```

## Usage
To reproduce the experiments:
1. Install the `requirements.txt`
1. Download the data by cloning the following repos.
  - e-SNLI `git clone https://github.com/OanaMariaCamburu/e-SNLI`
  - ComVE: `git clone https://github.com/wangcunxiang/SemEval2020-Task4-Commonsense-Validation-and-Explanation`
  - BBH samples: `git clone https://github.com/milesaturpin/cot-unfaithfulness`
1. Make sure you have enough compute resources for the largest models. We ran our experiments with 4x NVIDIA A40 (48 GB).
1. Run `python faithfulness.py [TASK] [MODEL] 100`.

## Credits
The Shapley value implementation in the `shap` folder is a modified version of https://github.com/slundberg/shap .

## Disclaimer
This is work in progress. Code and paper will be revised and improved for conference submissions (submission which is subject of anonimity period unfortunately).
