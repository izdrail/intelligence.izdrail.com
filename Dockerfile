# Start from the official Ollama image
FROM ollama/ollama:latest

# Start the server in background & pull the model
RUN (ollama serve &) && sleep 5 && ollama pull gemma3:latest

# Expose API port
EXPOSE 11434

# Start Ollama
CMD ["serve"]