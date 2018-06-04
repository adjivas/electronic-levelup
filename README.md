# [AM335x](https://www.olimex.com/wiki/Building_Debian_AM3352_SOM)
[![Build Status](https://travis-ci.org/adjivas/electronic-levelup.svg?branch=little-ti)](https://travis-ci.org/adjivas/electronic-levelup)

### 4. Format and setup the SD-card
Once you know which one is your microSD (as sda#) use it instead of the sdX name in the references below:
then:
```bash
sudo dd if=/dev/zero of=/dev/sdx bs=1k count=1024
sudo fdisk /dev/sdx << __EOF__
n




w
__EOF__
sudo mkfs.ext4 -F -O ^metadata_csum,^64bit /dev/sdx1
```

### 5. Write the Uboot on sd card
You should be in /home/user/AM3352-SOM-olimex/u-boot-2013.10-ti2013.12.01-am3352\_som# directory:
```bash
dd if=u-boot-2013.10-ti2013.12.01-am3352_som/MLO of=/dev/sdX count=1 seek=1 conv=notrunc bs=128k
dd if=u-boot-2013.10-ti2013.12.01-am3352_som/u-boot.img of=/dev/sdX count=2 seek=1 conv=notrunc bs=384k 
```

### 6. Debian rootfs
Now mount the microSD card EXT4 FS partition: 
```bash
mkdir /mnt/sd
mount /dev/sdX1 /mnt/sd
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
cp arch/arm/boot/zImage /mnt/sd/boot/
```

#### 6.2. Write am335x-olimex-som.dtb file
Copy the am335x-olimex-som.dtb file to the mounted first partition of the SD card 
```bash
cp linux-3.12.10-ti2013.12.01-am3352_som/arch/arm/boot/dts/am335x-olimex-som.dts /mnt/sd/boot/am335x-olimex-som.dtb
sync
```

#### 6.3 Now you have to replace the new generated kernel modules
from /home/user/AM3352-SOM-olimex/linux-3.12.10-ti2013.12.01-am3352\_som/out/lib/modules/ to the new Debian file system, but first remove the old modules:
```bash
rm -rf /mnt/sd/lib/modules/* 
cp -rfv linux-3.12.10-ti2013.12.01-am3352_som/out/lib/modules/3.12.10-g2db3193f-dirty/ /mnt/sd/lib/modules/ 
```

```bash
sync
umount /mnt/sd
```
