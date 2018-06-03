# [AM335x](https://www.olimex.com/wiki/AM335x#title)
[![Build Status](https://travis-ci.org/adjivas/electronic-levelup.svg?branch=ti)](https://travis-ci.org/adjivas/electronic-levelup)

## [1 Prepare card](https://www.olimex.com/wiki/AM335x#Prepare_card)
To make sure everything will run without problem wipe all data on the MMC:
```bash
sudo dd if=/dev/zero of=/dev/sdx bs=1k count=1024
```

Format the disk:
```bash
sudo fdisk /dev/sdx << __EOF__
n




w
__EOF__
```

Make ext4 filesystem:
```bash
sudo mkfs.ext4 -F -O ^metadata_csum,^64bit /dev/sdx1
```

### [3.2 Writing U-Boot](https://www.olimex.com/wiki/AM335x#Writing_U-Boot)
#### [MMC](https://www.olimex.com/wiki/AM335x#MMC)
Insert your card and write *MLO* and *u-boot.img*:
```bash
sudo dd if=images/MLO of=/dev/sdx count=1 seek=1 bs=128k 
sudo dd if=images/u-boot.img of=/dev/sdx count=2 seek=1 bs=384k
```

### [4.4 Kernel writing](https://www.olimex.com/wiki/AM335x#Kernel_writing)
#### [MMC card](https://www.olimex.com/wiki/AM335x#MMC_card)
We assume that you already installed *rootfs* on the card. Mount card, if its not mounted yet:
```bash
sudo mount /dev/sdx1 /mnt
```

Copy *zImage* and device-tree blobs:
```bash
sudo mkdir /mnt/boot
sudo cp boot/zImage /mnt/boot/
sudo cp boot/dts/am335x*.dtb /mnt/boot
```

### [5.3 Write file system](https://www.olimex.com/wiki/AM335x#Write_file_system)
#### [5.3.1 Write to MMC card](https://www.olimex.com/wiki/AM335x#Write_to_MMC_card)
Mount the card and simply copy files:
```bash
sudo cp -rpf rootfs/* /mnt
sudo umount /mnt
```
