OUTPUT_DIR ?= ../.out
OUTPUT      = sshpass

SOURCE_URL = https://sourceforge.net/projects/sshpass/files/sshpass/1.10/sshpass-1.10.tar.gz/download
SOURCE_DIR = source

all: $(OUTPUT_DIR)/$(OUTPUT)

$(OUTPUT_DIR)/$(OUTPUT): $(SOURCE_DIR)/sshpass
	mkdir -p $(OUTPUT_DIR)
	cp $^ $@

$(SOURCE_DIR)/sshpass: $(SOURCE_DIR)/config.h
	make -C $(SOURCE_DIR)

$(SOURCE_DIR)/config.h: $(SOURCE_DIR)/.CACHETAG
	cd $(SOURCE_DIR) && ./configure

$(SOURCE_DIR)/.CACHETAG:
	rm -rf $(SOURCE_DIR)
	mkdir -p $(SOURCE_DIR)
	curl -L $(SOURCE_URL) | tar xvzf - -C $(SOURCE_DIR) --strip-components=1
	touch $(SOURCE_DIR)/.CACHETAG

clean:
	rm -rf $(SOURCE_DIR)

fclean: clean
	rm -f $(OUTPUT_DIR)/$(OUTPUT)

re: fclean all
