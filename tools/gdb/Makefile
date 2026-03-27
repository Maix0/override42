OUTPUT         = gdb.tar.gz
OUTPUT_DIR    ?= ../.out
CONTAINER_NAME = gdb-builder

PATCHES = $(wildcard ./patches/*.patch)

all: gdb

gdb: $(OUTPUT_DIR)/$(OUTPUT)
	tar xvzf $(OUTPUT_DIR)/$(OUTPUT) -C $(OUTPUT_DIR) gdb-linaro/bin/gdb --strip-component=2
	touch $(OUTPUT_DIR)/gdb

$(OUTPUT_DIR)/$(OUTPUT): $(PATCHES) ./Dockerfile
	echo "Using patches: $(PATCHES)"
	docker build . -t $(CONTAINER_NAME) --network=host --rm
	docker run -d --name $(CONTAINER_NAME) --rm $(CONTAINER_NAME) sleep infinity
	mkdir  -p $(OUTPUT_DIR)
	docker cp $(CONTAINER_NAME):/dist/gdb.tar.gz $(OUTPUT_DIR)/$(OUTPUT)
	docker stop $(CONTAINER_NAME)
	docker rmi $(CONTAINER_NAME)
	touch $(OUTPUT_DIR)/$(OUTPUT)


sources:
	mkdir -p sources && cd sources && (curl -L https://launchpad.net/gdb-linaro/7.4/7.4-2012.04/+download/gdb-linaro-7.4-2012.04.tar.bz2 | tar xvjf - --strip-components=1)
