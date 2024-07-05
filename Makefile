# 使用的镜像名称和版本标签
REGISTRY ?= 
ORG ?= 
REPO ?= mihomo
IMAGE_TAG ?= v1.18.6
IMAGE_FULL_NAME := $(if $(REGISTRY),$(REGISTRY)/,)$(if $(ORG),$(ORG)/,)$(REPO):$(IMAGE_TAG)

# 参数
TARGETOS ?= linux
TARGETARCH ?= amd64
TARGETVARIANT = 
MIHOMO_VERSION ?= $(IMAGE_TAG)

# Docker守护进程
DOCKER := docker

print-vars:
	@echo "IMAGE_FULL_NAME is $(IMAGE_FULL_NAME)"

# 构建Docker镜像
build:
	$(DOCKER) build -t $(IMAGE_FULL_NAME) . \
	--build-arg TARGETOS=$(TARGETOS) --build-arg TARGETARCH=$(TARGETARCH) \
	--build-arg TARGETVARIANT=$(TARGETVARIANT) --build-arg MIHOMO_VERSION=$(MIHOMO_VERSION) \
	--build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(https_proxy)

# 推送Docker镜像
push: build
	$(DOCKER) push $(IMAGE_FULL_NAME)

# 运行Docker容器
run:
	$(DOCKER) run -d --name $(REPO) $(IMAGE_FULL_NAME)

# 停止并删除容器
stop-remove:
	$(DOCKER) stop $(REPO)|| true
	$(DOCKER) rm $(REPO) || true

# 删除镜像
image-rm:
	$(DOCKER) rmi $(IMAGE_FULL_NAME) || true

# 清理：停止容器并删除容器和镜像
clean: stop-remove image-rm

# 显示容器日志
logs:
	$(DOCKER) logs $(REPO)

# 交互式进入容器
shell:
	$(DOCKER) exec -it $(REPO) /bin/sh

# 检查镜像是否存在
image-exists:
	$(DOCKER) images $(IMAGE_FULL_NAME) > /dev/null ; echo $$?

.PHONY: build run stop-remove image-rm clean logs shell image-exists