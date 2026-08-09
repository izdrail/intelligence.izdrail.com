# ============================================================
# Ollama GPU Server
# NVIDIA Quadro P2000
# ============================================================

FROM ollama/ollama:latest

# ============================================================
# Ollama server
# ============================================================

ENV OLLAMA_HOST=0.0.0.0:11434

# Keep models loaded for 24 hours
ENV OLLAMA_KEEP_ALIVE=24h

# Only keep one model loaded in VRAM
ENV OLLAMA_MAX_LOADED_MODELS=1

# One inference request at a time
ENV OLLAMA_NUM_PARALLEL=1

# Maximum queued requests
ENV OLLAMA_MAX_QUEUE=64

# Allow Open WebUI / Activepieces / other clients
ENV OLLAMA_ORIGINS=*

# Don't prune model blobs automatically
ENV OLLAMA_NOPRUNE=true

# ============================================================
# Context / KV cache
# ============================================================

# P2000 has only 4GB VRAM.
# 32768 is useful but models may need CPU RAM/offloading.
ENV OLLAMA_CONTEXT_LENGTH=32768

# Flash Attention
ENV OLLAMA_FLASH_ATTENTION=true

# Quantised KV cache saves VRAM
ENV OLLAMA_KV_CACHE_TYPE=q4_0

# Reserve 2GB for GPU/system overhead
ENV OLLAMA_GPU_OVERHEAD=2048

# Large timeout for model loading
ENV OLLAMA_LOAD_TIMEOUT=10m

# ============================================================
# NVIDIA CUDA
# ============================================================

# Your machine has one NVIDIA GPU.
ENV CUDA_VISIBLE_DEVICES=0

# Keep CUDA device ordering deterministic
ENV CUDA_DEVICE_ORDER=PCI_BUS_ID

# ============================================================
# Vulkan
# ============================================================

# Use NVIDIA CUDA rather than Vulkan.
ENV OLLAMA_VULKAN=0

# ============================================================
# Debugging
# ============================================================

ENV OLLAMA_DEBUG=true

# ============================================================
# Ollama history
# ============================================================

ENV OLLAMA_NOHISTORY=false

# ============================================================
# System
# ============================================================

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Ollama model directory
RUN mkdir -p /root/.ollama/models

# ============================================================
# API
# ============================================================

EXPOSE 11434


# Start the server in background & pull models
RUN (ollama serve &) && sleep 5 && \
    ollama pull hf.co/laravelcompany/laravelmail && \
    ollama pull gemma3:4b && \
    ollama pull gemma4:e2b



# ============================================================
# Start
# ============================================================

ENTRYPOINT ["ollama"]

CMD ["serve"]
