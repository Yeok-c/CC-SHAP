### On Runpod CUDA 11.8, Pytorch 2.1.0 container
mv /workspace_bak /workspace
### Next you have to setup your huggingface
# - Tokens
# - This repo: https://huggingface.co/meta-llama/Llama-2-13b-chat-hf #(regardless of what model you're using). Takes a few hours for approval.

### Running
# Run `python faithfulness.py [TASK] [MODEL] 100`.
# Example `python faithfulness.py comve llama2-7b-chat 100`

# I ran into a CUDA problem - no GPU detected
# https://stackoverflow.com/questions/60987997/why-torch-cuda-is-available-returns-false-even-after-installing-pytorch-with

