sudo dd if=/dev/zero of=/dev/sdb bs=1k count=1024
sudo fdisk /dev/sdb << __EOF__
n




w
__EOF__
sudo mkfs.ext4 -F -O ^metadata_csum,^64bit /dev/sdb1

sudo dd if=u-boot-2013.10-ti2013.12.01-am3352_som/MLO of=/dev/sdb count=1 seek=1 conv=notrunc bs=128k
sudo dd if=u-boot-2013.10-ti2013.12.01-am3352_som/u-boot.img of=/dev/sdb count=2 seek=1 conv=notrunc bs=384k 

sudo mkdir -p /mnt/sd
sudo mount /dev/sdb1 /mnt/sd

tar -xvzf am3352-debian-3_12_FS_release_3.tgz -C /mnt/sd
ls /mnt/sd 
# The correct result should be: bin/ dev/ home/ lost+found/ mnt/ proc/ run/ srv/ tmp/ usr/ boot/ etc/ lib/ media/ opt/ root/ sbin/ sys/ uEnv.txt var/

sudo cp linux-3.12.10-ti2013.12.01-am3352_som/zImage /mnt/sd/boot

sudo cp linux-3.12.10-ti2013.12.01-am3352_som/am335x-olimex-som.dts /mnt/sd/boot
sync

sudo rm -rf /mnt/sd/lib/modules/* 
sudo cp -rfv linux-3.12.10-ti2013.12.01-am3352_som/out/lib/modules/3.12.10-g2db3193f-dirty/ /mnt/sd/lib/modules/ 

sudo cp -rfv linux-3.12.10-ti2013.12.01-am3352_som/out/lib/firmware/* /mnt/sd/lib/firmware/ 
sync
sudo umount /mnt/sd
