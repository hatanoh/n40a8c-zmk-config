include container.mk
container_name ?= please set container name

BOARD ?= seeeduino_xiao_ble
SHIELD ?= n40a8c
FIRM = $(SHIELD)-$(BOARD)-zmk.uf2
ZMK_DIR = $(PWD)/../zmk
CONFIG_DIR = $(PWD)
BUILD_DIR = build_$(SHIELD)_$(BOARD)
TARGET = $(ZMK_DIR)/app/$(BUILD_DIR)/zephyr/zmk.uf2

.PHONY: build clean

build: $(TARGET)

$(TARGET):
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -d $(BUILD_DIR) -b $(BOARD) -S studio-rpc-usb-uart -- -DSHIELD=$(SHIELD) -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG="/workspaces/zmk-config" 
	docker exec -w /workspaces/zmk/app -it $(container_name) cp $(BUILD_DIR)/zephyr/zmk.uf2 /workspaces/zmk-config/firmware/$(FIRM)


restart:
	docker stop $(container_name)
	(cd ..; rm zmk-config ; ln -sf `basename $(PWD)` zmk-config)
	devcontainer up --workspace-folder $(ZMK_DIR)

shell:
	docker exec -w /workspaces/zmk -it $(container_name) /bin/bash

clean:
	docker exec -it $(container_name) rm -rf /workspaces/zmk/app/$(BUILD_DIR)
