# [AM335x](https://www.olimex.com/wiki/Building_Debian_AM3352_SOM)
[![Build Status](https://travis-ci.org/adjivas/electronic-levelup.svg?branch=little-ti)](https://travis-ci.org/adjivas/electronic-levelup)

### 4. Format and setup the SD-card
Once you know which one is your microSD (as sda#) use it instead of the sdX name in the references below:
then:
```bash
sudo dd if=/dev/zero of=/dev/sdX bs=1k count=1024
sudo fdisk /dev/sdX << __EOF__
n




w
__EOF__
sudo mkfs.ext4 -F -O ^metadata_csum,^64bit /dev/sdX1
```

### 5. Write the Uboot on sd card
You should be in /home/user/AM3352-SOM-olimex/u-boot-2013.10-ti2013.12.01-am3352\_som# directory:
```bash
sudo dd if=u-boot-2013.10-ti2013.12.01-am3352_som/MLO of=/dev/sdX count=1 seek=1 conv=notrunc bs=128k
sudo dd if=u-boot-2013.10-ti2013.12.01-am3352_som/u-boot.img of=/dev/sdX count=2 seek=1 conv=notrunc bs=384k 
```

### 6. Debian rootfs
Now mount the microSD card EXT4 FS partition: 
```bash
sudo mkdir -p /mnt/sd
sudo mount /dev/sdX1 /mnt/sd
```

and unarchive the rootfs
```bash
tar am3352-debian-3_12_FS_release_3.tgz -C /mnt/sd
ls /mnt/sd 
# The correct result should be: bin/ dev/ home/ lost+found/ mnt/ proc/ run/ srv/ tmp/ usr/ boot/ etc/ lib/ media/ opt/ root/ sbin/ sys/ uEnv.txt var/
```

#### 6.1. Write kernel zImage you built to the SD-card
copy the Kernel zImage to boot directory in the first partition 
```bash
sudo cp linux-3.12.10-ti2013.12.01-am3352_som/zImage /mnt/sd/boot
```

#### 6.2. Write am335x-olimex-som.dtb file
Copy the am335x-olimex-som.dtb file to the mounted first partition of the SD card 
```bash
sudo cp linux-3.12.10-ti2013.12.01-am3352_som/am335x-olimex-som.dts /mnt/sd/boot
sync
```

#### 6.3 Now you have to replace the new generated kernel modules
from /home/user/AM3352-SOM-olimex/linux-3.12.10-ti2013.12.01-am3352\_som/out/lib/modules/ to the new Debian file system, but first remove the old modules:
```bash
sudo rm -rf /mnt/sd/lib/modules/* 
sudo cp -rfv linux-3.12.10-ti2013.12.01-am3352_som/out/lib/modules/3.12.10-g2db3193f-dirty/ /mnt/sd/lib/modules/ 
```
add the files from the generated /out/lib/firmware folder to /mnt/sd/lib/firmware folder on sd card
```bash
sudo cp -rfv linux-3.12.10-ti2013.12.01-am3352_som/out/lib/firmware/* /mnt/sd/lib/firmware/ 
sync
sudo umount /mnt/sd
```
