# 🐳 Variables
IMAGE_NAME = izdrail/intelligence.izdrail.com
CONTAINER_NAME = intelligence.izdrail.com
PORT = 11434

# 🔨 Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# 🚀 Run the container (detached)
run:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):11434 $(IMAGE_NAME)

# 🛑 Stop the container
stop:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

# 🔄 Restart container
restart: stop run

# 🧪 Test the model
test:
	curl -s http://localhost:$(PORT)/api/generate -d "{\"model\": \"gemma3:latest\", \"prompt\": \"Rewrite the following text: The house is green and the boy listen to the music. \", \"stream\": false}" | jq .

# 🧹 Clean up image + container
clean: stop
	docker rmi $(IMAGE_NAME) || true
