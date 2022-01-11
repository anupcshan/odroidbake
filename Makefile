packages = \
	   github.com/gokrazy/breakglass \
	   github.com/gokrazy/serial-busybox \
	   github.com/gokrazy/bakery/cmd/bake

commonflags = \
	      -kernel_package=github.com/anupcshan/gokrazy-odroidxu4-kernel \
	      -eeprom_package= \
	      -serial_console=disabled \
	      -firmware_package= \
	      -hostname=odroidbake \
	      -device_type="Hardkernel Odroid HC1"

install-tools:
	rm -f go.mod
	go mod init github.com/anupcshan/gokrazy-odroidxu4-example
	go mod edit \
		-replace=github.com/gokrazy/tools=github.com/anupcshan/tools@support-hc2 \
		-replace=github.com/gokrazy/internal=github.com/anupcshan/internal@support-hc2 \
		-replace=github.com/gokrazy/gokrazy=github.com/anupcshan/gokrazy@update-device-files \
		-replace=github.com/gokrazy/bakery=github.com/anupcshan/bakery@master
	GOPROXY=direct go get github.com/gokrazy/tools/cmd/gokr-packer

odroidbake.img:
	GOARCH=arm gokr-packer -overwrite=$@ $(commonflags) -target_storage_bytes=$$((1500*1024*1024)) $(packages)

update:
	GOARCH=arm gokr-packer -update=yes $(commonflags) $(packages)

disk:
	GOARCH=arm gokr-packer -overwrite=/dev/mmcblk0 $(commonflags) $(packages)

clean:
	rm -f *.img
