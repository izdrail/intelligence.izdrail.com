# Start from the official Ollama image
FROM ollama/ollama:latest

# Set environment variables for GPU support and performance
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_KEEP_ALIVE=5m0s
ENV OLLAMA_FLASH_ATTENTION=true
ENV OLLAMA_MAX_LOADED_MODELS=1
ENV OLLAMA_NUM_PARALLEL=1
ENV CUDA_VISIBLE_DEVICES=0
ENV OLLAMA_DEBUG=false

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create ollama user home directory
RUN mkdir -p /root/.ollama

# Start the server in background & pull models
RUN (ollama serve &) && sleep 5 && \
    ollama pull gemma:7b && \
    ollama pull mistral:7b && \
    ollama pull neural-chat:7b && \
    ollama pull dolphin-mixtral:8x7b && \
    ollama pull orca-mini:13b

# Expose API port
EXPOSE 11434

# Health check
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:11434/api/tags || exit 1

# Start Ollama server
CMD ["ollama", "serve"]