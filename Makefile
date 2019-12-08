BASE_PATH = app
PROJECT_NAME = chalice_app
IMAGE = $(PROJECT_NAME):latest

# Container
copy_requirements:
	@cp $(BASE_PATH)/$(PROJECT_NAME)/requirements.txt docker/resources/requirements.txt

build: copy_requirements
	@docker build -f docker/Dockerfile -t $(IMAGE) ./docker
	@rm docker/resources/requirements.txt

container:
	@docker run --rm -it\
	 -v $(PWD)/$(BASE_PATH):/$(BASE_PATH) \
	 -v ~/.aws/credentials:/root/.aws/credentials \
	 -w /$(BASE_PATH)/$(PROJECT_NAME) \
	 -p 8080:8080/ \
	 $(IMAGE) \
	 $(COMMAND)

ssh:
	@make container COMMAND=sh

# Chalice
newProject:
	@sudo rm -rf $(BASE_PATH)/$(PROJECT_NAME)
	@make container COMMAND="chalice new-project $(PROJECT_NAME)"
	@sudo chown -R $(USERNAME):$(USERNAME) $(BASE_PATH)/$(PROJECT_NAME)

deploy:
	@make container COMMAND="chalice deploy"

delete:
	@make container COMMAND="chalice delete"

up:
	@make container COMMAND="chalice local --host=0.0.0.0 --port=8080"
