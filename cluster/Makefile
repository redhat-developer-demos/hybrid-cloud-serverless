ENV_FILE := .env
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})
CURRENT_DIR = $(shell pwd)
ANSIBLE_RUNNER_IMAGE := example/ansible-runner

.PHONY:	build
build:	
	@docker build -t example/ansible-runner .

.PHONY: run
run:
	@docker run -it  \
   -v $(CURRENT_DIR)/project:/runner/project:z \
   -v $(CURRENT_DIR)/project/bin:/runner/project/bin:z \
   -v $(CURRENT_DIR)/project/.argocd:/runner/.argocd:z \
   -v $(CURRENT_DIR)/inventory:/runner/inventory:z \
   -v $(CURRENT_DIR)/env:/runner/env:z \
   --env-file $(CURRENT_DIR)/.env \
   $(ANSIBLE_RUNNER_IMAGE)


