
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
import sys

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

# Take args from cli for model name
model_name = sys.argv[1]

if model_name not in MODELS:
    raise ValueError(f"Model {model_name} not found in MODELS.")

dtype = torch.float32 if 'llama2-7b' in model_name else torch.float16
with torch.no_grad():
    model = AutoModelForCausalLM.from_pretrained(MODELS[model_name], torch_dtype=dtype, device_map="auto", token=True)
tokenizer = AutoTokenizer.from_pretrained(MODELS[model_name], use_fast=False, padding_side='left')
print(f"Done loading model and tokenizer after {time.time()-t1:.2f}s.")
