DOWNLOAD_DIR   = .dl
ISO_NAME       = OverRide.iso
ISO_URL        = https://cdn.intra.42.fr/isos/OverRide.iso

QEMU           = qemu-system-x86_64
COPY           = wl-copy

SSH_PORT_VM    = 4242
SSH_PORT_HOST  = 4242


VM_NAME        = OverRide
VM_PROVIDER    = qemu

ifneq (,$(findstring 42paris.fr,$(shell hostname)))
COPY           = xsel --clipboard
SSH_PORT_HOST  = 4243
VM_PROVIDER    = vbox
endif

export SSH_PORT_HOST

help:
	@echo -e "you can set VM_PROVIDER to either qemu or vbox"
	@echo -e "\tstart:                           start the VM in the current terminal"
	@echo -e "\tstop:                            stop all rainfall VMs"
	@echo -e "\tiso:                             download the iso"
	@echo -e "\tssh   LEVEL=X:                   connect to the correct level using ssh"
	@echo -e "\tcopy  LEVEL=X FILE=<filename>:   copy a file to the host using scp"
	@echo -e "\tlevel LEVEL=X:                   copy _template to create new level"
	@echo -e "\tsetup:                           build tools and copy them to the vm"
	@echo -e "\tgdb:                             build custom gdb"
	@echo -e "\tsshpass:                         build sshpass"


start: start@$(VM_PROVIDER)
stop:  stop@$(VM_PROVIDER)

start@qemu: iso
	$(QEMU) --enable-kvm \
		-cpu host \
		-m 4096 \
		-boot d \
		-cdrom $(DOWNLOAD_DIR)/$(ISO_NAME) \
		-nic user,hostfwd=tcp::$(SSH_PORT_HOST)-:$(SSH_PORT_VM) \
		-display none



stop@qemu:
	ps aux | rg "$(QEMU)" | rg "$(ISO_NAME)" | rg -v 'rg' | awk '{ print $$2 }' | xargs kill -SIGINT

stop@vbox:
	VBoxManage controlvm "$(VM_NAME)" poweroff
start@vbox: iso
	-VBoxManage createvm --name "$(VM_NAME)" --register
	-VBoxManage modifyvm "$(VM_NAME)" --memory 4096 --boot1 dvd --nic1 nat --natpf1 "fwd,tcp,,$(SSH_PORT_HOST),,$(SSH_PORT_VM)"
	-VBoxManage storagectl "$(VM_NAME)" --name "IDE" --add ide
	-VBoxManage storageattach "$(VM_NAME)" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "$(DOWNLOAD_DIR)/$(ISO_NAME)"
	VBoxManage startvm "$(VM_NAME)" --type headless
	

iso: $(DOWNLOAD_DIR)/$(ISO_NAME);

$(DOWNLOAD_DIR)/$(ISO_NAME):
	mkdir -p $(DOWNLOAD_DIR);
	wget "$(ISO_URL)" -O "$(DOWNLOAD_DIR)/$(ISO_NAME)";

LEVEL=0
LEVEL_PREFIX=level0
export LEVEL
ifneq ("$(LEVEL)", "0")
	PASSFILE="./levels/$(shell sh -xc "echo $$(( $(LEVEL) - 1 ))")/flag"
else
	PASSFILE="./levels/0/passwd"
endif


ssh: sshpass
	@printf "\n\n";
	@-cat $(PASSFILE)
	@#-cat $(PASSFILE) | tr -d '\n' | $(COPY)
	@printf "\n\n";
	-TERM=xterm tools/.out/sshpass -f$(PASSFILE) ssh -p $(SSH_PORT_HOST) "$(LEVEL_PREFIX)$(LEVEL)@override.local.maix.me"

FILE=./$(LEVEL_PREFIX)$(LEVEL)
copy: sshpass
	@mkdir -p files;
	@printf "\n\n";
	@-cat $(PASSFILE)
	@#-cat $(PASSFILE) | tr -d '\n' | $(COPY)
	@printf "\n\n";
	-TERM=xterm tools/.out/sshpass -f$(PASSFILE) scp -P $(SSH_PORT_HOST) "$(LEVEL_PREFIX)$(LEVEL)@override.local.maix.me:~/$(FILE)" "files/$(FILE)"

level:
	cp -r ./levels/_template ./levels/$(LEVEL)
	fastmod --accept-all -F "<next_level>"    "$(LEVEL_PREFIX)$(shell sh -c 'echo  $$(( $(LEVEL) + 1))')" "./levels/$(LEVEL)"
	fastmod --accept-all -F "<current_level>" "$(LEVEL_PREFIX)$(LEVEL)" "./levels/$(LEVEL)"
	fastmod --accept-all -F "<password>"      "$(shell cat $(PASSFILE) | tr -d '\n')" "./levels/$(LEVEL)"

setup:
	@echo "Make sure the vm is running !"
	make -C tools copy

sshpass:
	make -C tools sshpass
gdb: 
	make -C tools gdb

clean:
	make -C tools clean
