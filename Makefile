.PHONY: all clean menuconfig savedefconfig list-defconfigs distclean

# Default Buildroot directory (can be overridden with `make BUILDROOT_DIR=/path`)
BUILDROOT_DIR ?= $(shell pwd)/buildroot

# Default board name (can be overridden with `make BOARD_NAME=other_board`)
BOARD_NAME ?= rpi5
export BOARD_NAME

# Default external directory for custom packages
BR2_EXTERNAL ?= $(shell pwd)/application

# Build the plaything project for selected board
all:
	@echo "Configuring Buildroot with custom board defconfig..."
	$(MAKE) -C $(BUILDROOT_DIR) custom_raspberrypi5_defconfig
	$(MAKE) -C $(BUILDROOT_DIR)
	
# Open Buildroot menuconfig for customization
menuconfig:
	$(MAKE) -C $(BUILDROOT_DIR) menuconfig

# Saves the current Buildroot defconfig to custom_raspberrypi5_defconfig
savedefconfig:
	$(MAKE) -C $(BUILDROOT_DIR) savedefconfig BR2_DEFCONFIG=../application/configs/custom_raspberrypi5_defconfig

image:
	sudo dd if=$(BUILDROOT_DIR)/output/images/sdcard.img of=/dev/sda bs=4M status=progress

# Clean the Buildroot build directory
clean:
	$(MAKE) -C $(BUILDROOT_DIR) clean

# Completely reset Buildroot to a fresh state
distclean:
	$(MAKE) -C $(BUILDROOT_DIR) distclean
	@echo "Buildroot directory reset. You may need to reconfigure."