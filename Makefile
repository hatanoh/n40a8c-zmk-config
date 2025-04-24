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
