OUTPUT_DIR=$(shell realpath .out)
export OUTPUT_DIR

DEFAULT_USER=level00
DEFAULT_PASS=level00

SSH_HOST_PORT=4242
ifneq (,$(findstring 42paris.fr,$(shell hostname)))
SSH_HOST_PORT=4243
endif

copy: sshpass gdb
	$(OUTPUT_DIR)/sshpass -p $(DEFAULT_PASS) scp -P $(SSH_HOST_PORT) $(OUTPUT_DIR)/gdb $(DEFAULT_USER)@override.local.maix.me:/tmp/

clean:
	make -C sshpass clean
	rm -rf $(OUTPUT_DIR)

gdb:     $(OUTPUT_DIR)/gdb sshpass
sshpass: $(OUTPUT_DIR)/sshpass

$(OUTPUT_DIR)/sshpass:
	make -C sshpass
$(OUTPUT_DIR)/gdb:
	make -C gdb
