# Yeok's fork
Literally everything automated in the container
You just have to

```
export HF_HOME=/workspace/huggingface
conda activate cc_shap
huggingface-cli login
```

### Running
Run `python faithfulness.py [TASK] [MODEL] 100`.
Example `python faithfulness.py comve llama2-7b-chat 100`

Models, metrics and tasks available:
```
TESTS = [
         'atanasova_counterfactual',
         'atanasova_input_from_expl',
         'cc_shap-posthoc',
         'turpin',
         'lanham',
         'cc_shap-cot',
         ]

MODELS = {
    'bloom-7b1': 'bigscience/bloom-7b1',
    'opt-30b': 'facebook/opt-30b',
    'llama30b': '/workspace/mitarb/parcalabescu/llama30b_hf',
    'oasst-sft-6-llama-30b': '/workspace/mitarb/parcalabescu/transformers-xor_env/oasst-sft-6-llama-30b-xor/oasst-sft-6-llama-30b',
    'gpt2': 'gpt2',
    'llama2-7b': 'meta-llama/Llama-2-7b-hf',
    'llama2-7b-chat': 'meta-llama/Llama-2-7b-chat-hf',
    'llama2-13b': 'meta-llama/Llama-2-13b-hf',
    'llama2-13b-chat': 'meta-llama/Llama-2-13b-chat-hf',
    'mistral-7b': 'mistralai/Mistral-7B-v0.1',
    'mistral-7b-chat': 'mistralai/Mistral-7B-Instruct-v0.1',
    'falcon-7b': 'tiiuae/falcon-7b',
    'falcon-7b-chat': 'tiiuae/falcon-7b-instruct',
    'falcon-40b': 'tiiuae/falcon-40b',
    'falcon-40b-chat': 'tiiuae/falcon-40b-instruct',
}

LABELS = {
    'comve': ['A', 'B'], # ComVE
    'causal_judgment': ['A', 'B'],
    'disambiguation_qa': ['A', 'B', 'C'],
    'logical_deduction_five_objects': ['A', 'B', 'C', 'D', 'E'],
    'esnli': ['A', 'B', 'C'],
}
```

I ran into a CUDA problem - no GPU detected
I think it's cuz my NVCC and Cudatoolkit is 12.1
But the requirements.txt is expected for 11.8
Anyways I gave up running it on my own computer (it's not fast enough anyways) and got a compute instance on RunPod
https://stackoverflow.com/questions/60987997/why-torch-cuda-is-available-returns-false-even-after-installing-pytorch-with

## On Runpod
### Install conda first
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
conda init --all

### Follow the same steps as installation on top

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
