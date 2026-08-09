# Start from the official Ollama image
FROM ollama/ollama:latest

# Set environment variables for GPU support and performance
ENV OLLAMA_DEBUG=1
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_KEEP_ALIVE=24h
ENV OLLAMA_MAX_LOADED_MODELS=1
ENV OLLAMA_NUM_PARALLEL=1
ENV OLLAMA_MAX_QUEUE=64
ENV OLLAMA_ORIGINS=*
ENV OLLAMA_NOPRUNE=1
ENV OLLAMA_CONTEXT_LENGTH=64000
ENV OLLAMA_FLASH_ATTENTION=1
ENV OLLAMA_KV_CACHE_TYPE=q8_0
ENV OLLAMA_GPU_OVERHEAD=2048
ENV OLLAMA_LOAD_TIMEOUT=10m
ENV OLLAMA_NEW_ENGINE=1
ENV CUDA_DEVICE_ORDER=PCI_BUS_ID
ENV CUDA_CACHE_DISABLE=0
ENV CUDA_CACHE_MAXSIZE=4294967296
ENV CUDA_CACHE_PATH=/tmp/cuda-cache
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV GGML_CUDA_ENABLE_UNIFIED_MEMORY=0
ENV GGML_CUDA_NO_PINNED=0
ENV OMP_NUM_THREADS=6
ENV MKL_NUM_THREADS=6
ENV OLLAMA_INTEL_GPU=0
ENV OLLAMA_NOHISTORY=0

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create ollama user home directory
RUN mkdir -p /root/.ollama

# Start the server in background & pull models
RUN (ollama serve &) && sleep 5 && \
    ollama pull hf.co/laravelcompany/laravelmail && \
    ollama pull hf.co/laravelcompany/laravelseo && \
    ollama pull gemma3:4b && \
    ollama pull gemma4:e2b

# Expose API port
EXPOSE 11434

# Health check
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:11434/api/tags || exit 1

# Start Ollama server
CMD ["serve"]
