# ============================================================
# Ollama GPU Server - Optimized for Quadro P2000 (4GB Pascal)
# ============================================================

FROM ollama/ollama:latest

# ============================================================
# System dependencies
# ============================================================
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ollama/models

# ============================================================
# Core Ollama runtime settings
# ============================================================
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_KEEP_ALIVE=-1
ENV OLLAMA_MAX_LOADED_MODELS=1
ENV OLLAMA_NUM_PARALLEL=1
ENV OLLAMA_MAX_QUEUE=64
ENV OLLAMA_ORIGINS=*
ENV OLLAMA_NOPRUNE=true
ENV OLLAMA_DEBUG=false
ENV OLLAMA_NOHISTORY=true

# ============================================================
# Memory & Compute Tuning (Quadro P2000 4GB)
# ============================================================
# 4096 gives room for ~2GB models to run 100% on GPU
ENV OLLAMA_CONTEXT_LENGTH=4096

# Flash Attention is NOT supported on Pascal architecture
ENV OLLAMA_FLASH_ATTENTION=false

# Quantized KV cache saves critical VRAM on 4GB cards
ENV OLLAMA_KV_CACHE_TYPE=q4_0

# Minimal overhead buffer so Ollama utilizes all ~4GB VRAM
ENV OLLAMA_GPU_OVERHEAD=128

ENV OLLAMA_LOAD_TIMEOUT=5m

# ============================================================
# NVIDIA CUDA
# ============================================================
ENV CUDA_VISIBLE_DEVICES=0
ENV CUDA_DEVICE_ORDER=PCI_BUS_ID
ENV OLLAMA_VULKAN=0

EXPOSE 11434

# ============================================================
# Pull lightweight models designed for 4GB VRAM
# ============================================================
RUN (ollama serve &) && sleep 5 && \
    ollama pull hf.co/laravelcompany/laravelmail && \
    ollama pull hf.co/unsloth/SmolLM3-3B-GGUF:Q4_K_M

ENTRYPOINT ["ollama"]
CMD ["serve"]