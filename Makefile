BOARD ?= seeeduino_xiao_ble
SHIELD ?= n40a8c

ZMK_DIR = $(PWD)/../zmk
CONFIG_DIR = $(PWD)
BUILD_DIR = build_$(SHIELD)_$(BOARD)
FIRM_DIR = zmk-config/firmware
FIRM = $(SHIELD)-$(BOARD)-zmk.uf2

TARGET = $(CONFIG_DIR)/firmware/$(FIRM)

.PHONY: build clean

build: $(TARGET)

$(TARGET):
	devcontainer exec --workspace-folder $(ZMK_DIR) bash -c "(cd app ; west build -d $(BUILD_DIR) -b $(BOARD) -S studio-rpc-usb-uart -- -DSHIELD=$(SHIELD) -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG="/workspaces/zmk-config" && cp $(BUILD_DIR)/zephyr/zmk.uf2 /workspaces/$(FIRM_DIR)/$(FIRM))"

shell:
	devcontainer exec --workspace-folder $(ZMK_DIR) bash

clean:
	devcontainer exec --workspace-folder $(ZMK_DIR) rm -rf /workspaces/zmk/app/$(BUILD_DIR)
	rm -f $(TARGET)

start:
	devcontainer up --workspace-folder $(ZMK_DIR) 

stop:
	docker stop `docker ps | grep vsc-zmk | cut -f 1 -d " "`

setup:
	-(cd ..; git clone https://github.com/zmkfirmware/zmk.git )
	docker volume create --driver local -o o=bind -o type=none -o device="$(PWD)" zmk-config
	docker volume create --driver local -o o=bind -o type=none -o device="$(PWD)/modules" zmk-modules
	devcontainer up --workspace-folder $(ZMK_DIR)
	devcontainer exec --workspace-folder $(ZMK_DIR) west init -l app/
	devcontainer exec --workspace-folder $(ZMK_DIR) west update

remove:
	-devcontainer exec --workspace-folder $(ZMK_DIR) bash -c "rm -rf app/build_*"
	-devcontainer exec --workspace-folder $(ZMK_DIR) rm -rf .west
	-docker stop `docker ps | grep vsc-zmk | cut -f 1 -d " "`
	-docker container rm `docker container ls | grep vsc-zmk | cut -f 1 -d " "`
	-docker image rm `docker image ls | grep vsc-zmk | awk '{print $$3}'`
	-docker volume rm `docker volume ls -q | grep zmk-`

distclean: remove 
	rm -rf ../zmk
	rm -f firmware/*.uf2
	docker system prune -f
