include container.mk
container_name ?= please set container name

ZMK_DIR = $(PWD)/../zmk
CONFIG_DIR = $(PWD)
BOARD = seeeduino_xiao_ble 
SHIELD = n40a8c
TARGET = $(ZMK_DIR)/app/build/zephyr/zmk.uf2

.PHONY: build clean

build: $(TARGET)

$(TARGET):
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -d build -b $(BOARD) -S studio-rpc-usb-uart -- -DSHIELD=$(SHIELD) -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG="/workspaces/zmk-config" 
	docker exec -w /workspaces/zmk/app -it $(container_name) cp build/zephyr/zmk.uf2 build/zmk.uf2


restart:
	docker stop $(container_name)
	(cd ..; rm zmk-config ; ln -sf `basename $(PWD)` zmk-config)
	devcontainer up --workspace-folder $(ZMK_DIR)

shell:
	docker exec -w /workspaces/zmk -it $(container_name) /bin/bash

clean:
	docker exec -it $(container_name) rm -rf /workspaces/zmk/app/build
