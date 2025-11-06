# Start from the official Ollama image
FROM ollama/ollama:latest

# Start the server in background & pull the model
RUN (ollama serve &) && sleep 5 && ollama pull llama3.2:1b

# Expose API port
EXPOSE 11434

# Start Ollama
CMD ["serve"]