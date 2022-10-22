packages = \
	   github.com/gokrazy/breakglass \
	   github.com/gokrazy/serial-busybox \
	   github.com/gokrazy/timestamps \
	   github.com/gokrazy/bakery/cmd/bake

commonflags = \
	      -kernel_package=github.com/anupcshan/gokrazy-odroidxu4-kernel \
	      -eeprom_package= \
	      -serial_console=disabled \
	      -firmware_package= \
	      -hostname=odroidbake \
	      -device_type=odroidhc1

install-tools:
	rm -f go.mod go.sum
	go mod init github.com/anupcshan/gokrazy-odroidxu4-example
	go get github.com/gokrazy/tools/cmd/gokr-packer

odroidbake.img:
	GOARCH=arm gokr-packer -overwrite=$@ $(commonflags) -target_storage_bytes=$$((1500*1024*1024)) $(packages)

update:
	GOARCH=arm gokr-packer -update=yes $(commonflags) $(packages)

testboot:
	GOARCH=arm gokr-packer -update=yes $(commonflags) -testboot $(packages)

disk:
	GOARCH=arm gokr-packer -overwrite=/dev/mmcblk0 $(commonflags) $(packages)

clean:
	rm -f *.img
