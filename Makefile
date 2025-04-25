BOARDS = seeeduino_xiao_ble seeeduino_xiao_rp2040
BOARD ?= seeeduino_xiao_ble
SHIELD ?= n40a8c

ZMK_DIR = $(PWD)/../zmk
CONFIG_DIR = $(PWD)
MODULES_DIR = $(PWD)/modules
BUILD_DIR = build/$(SHIELD)_$(BOARD)
FIRM_DIR = zmk-config/firmware
FIRM = $(SHIELD)-$(BOARD)-zmk.uf2

TARGET = $(CONFIG_DIR)/firmware/$(FIRM)
SRCS = $(shell find ./boards/shields/$(SHIELD) ./config -type f)

.PHONY: build clean buildall cleanall

buildall:
	for bd in $(BOARDS); do make build BOARD=$$bd; done

cleanall:
	for bd in $(BOARDS); do make clean BOARD=$$bd; done

build: $(TARGET)
$(TARGET): $(SRC)
	devcontainer exec --workspace-folder $(ZMK_DIR) bash -c "(cd app ; west build -d $(BUILD_DIR) -b $(BOARD) -S studio-rpc-usb-uart -- -DSHIELD=$(SHIELD) -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG="/workspaces/zmk-config" && cp $(BUILD_DIR)/zephyr/zmk.uf2 /workspaces/$(FIRM_DIR)/$(FIRM))"

clean:
	devcontainer exec --workspace-folder $(ZMK_DIR) rm -rf app/$(BUILD_DIR)
	rm -f $(TARGET)

start:
	devcontainer up --workspace-folder $(ZMK_DIR) 

stop:
	docker stop `docker ps | grep vsc-zmk | cut -f 1 -d " "`

shell:
	devcontainer exec --workspace-folder $(ZMK_DIR) bash

setup:
	-(cd ..; git clone https://github.com/zmkfirmware/zmk.git )
	docker volume create --driver local -o o=bind -o type=none -o device="$(CONFIG_DIR)" zmk-config
	docker volume create --driver local -o o=bind -o type=none -o device="$(MODULES_DIR)" zmk-modules
	devcontainer up --workspace-folder $(ZMK_DIR)
	devcontainer exec --workspace-folder $(ZMK_DIR) west init -l app/
	devcontainer exec --workspace-folder $(ZMK_DIR) west update

remove:
	-devcontainer exec --workspace-folder $(ZMK_DIR) bash -c "rm -rf app/build"
	-devcontainer exec --workspace-folder $(ZMK_DIR) rm -rf .west
	-docker stop `docker ps | grep vsc-zmk | cut -f 1 -d " "`
	-docker container rm `docker container ls | grep vsc-zmk | cut -f 1 -d " "`
	-docker image rm `docker image ls | grep vsc-zmk | awk '{print $$3}'`
	-docker volume rm `docker volume ls -q | grep zmk-`

distclean: remove 
	rm -rf ../zmk
	rm -f firmware/*.uf2
	docker system prune -f
