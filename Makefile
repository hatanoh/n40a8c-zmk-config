include settings.mk
container_name ?= please set container name
BOARD ?= seeeduino_xiao_ble
SHIELD ?= n40a8c

ZMK_DIR = $(PWD)/../zmk
CONFIG_DIR = $(PWD)
BUILD_DIR = build_$(SHIELD)_$(BOARD)
FIRM_DIR = zmk-config/firmware
FIRM = $(SHIELD)-$(BOARD)-zmk.uf2
TARGET = $(ZMK_DIR)/app/$(BUILD_DIR)/zephyr/zmk.uf2

.PHONY: build clean

build: $(TARGET)

$(TARGET):
	devcontainer exec --workspace-folder $(ZMK_DIR) bash -c "(cd app ; west build -d $(BUILD_DIR) -b $(BOARD) -S studio-rpc-usb-uart -- -DSHIELD=$(SHIELD) -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG="/workspaces/zmk-config")"
	devcontainer exec --workspace-folder $(ZMK_DIR) cp app/$(BUILD_DIR)/zephyr/zmk.uf2 /workspaces/$(FIRM_DIR)/$(FIRM)

restart:
	docker stop $(container_name)
	(cd ..; rm zmk-config ; ln -sf `basename $(PWD)` zmk-config)
	devcontainer up --workspace-folder $(ZMK_DIR)

shell:
	devcontainer exec --workspace-folder $(ZMK_DIR) bash

clean:
	devcontainer exec --workspace-folder $(ZMK_DIR) rm -rf /workspaces/zmk/app/$(BUILD_DIR)
