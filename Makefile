packages = github.com/gokrazy/breakglass github.com/gokrazy/serial-busybox github.com/gokrazy/bakery/cmd/bake
commonflags = -kernel_package=github.com/anupcshan/gokrazy-odroidxu4-kernel -eeprom_package= -serial_console=disabled -firmware_package= -force_no_gpt

install-tools:
	go mod edit -replace=github.com/gokrazy/tools=github.com/anupcshan/tools@add-odroid-support
	GOPROXY=direct go get github.com/gokrazy/tools/cmd/gokr-packer

odroidbake.img: temp.img
	cp $< /tmp/test.img
	dd iflag=dsync oflag=dsync if=./bootloader/bl1.bin of=/tmp/test.img seek=1 conv=notrunc
	dd iflag=dsync oflag=dsync if=./bootloader/bl2.bin of=/tmp/test.img seek=31 conv=notrunc
	dd iflag=dsync oflag=dsync if=./bootloader/u-boot.bin of=/tmp/test.img seek=63 conv=notrunc
	dd iflag=dsync oflag=dsync if=./bootloader/tzsw.bin of=/tmp/test.img seek=1503 conv=notrunc
	mv /tmp/test.img $@

temp.img: install-tools
	GOARCH=arm gokr-packer -overwrite=$@ $(commonflags) -target_storage_bytes=$$((1500*1024*1024)) $(packages)

update: install-tools
	GOARCH=arm gokr-packer -update=yes $(commonflags) $(packages)

disk: install-tools
	GOARCH=arm gokr-packer -overwrite=/dev/mmcblk0 $(commonflags) $(packages)
	dd iflag=dsync oflag=dsync if=./bootloader/bl1.bin of=/dev/mmcblk0 seek=1 conv=notrunc
	dd iflag=dsync oflag=dsync if=./bootloader/bl2.bin of=/dev/mmcblk0 seek=31 conv=notrunc
	dd iflag=dsync oflag=dsync if=./bootloader/u-boot.bin of=/dev/mmcblk0 seek=63 conv=notrunc
	dd iflag=dsync oflag=dsync if=./bootloader/tzsw.bin of=/dev/mmcblk0 seek=1503 conv=notrunc

clean:
	rm -f *.img
