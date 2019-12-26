# Simple-bootloader
A simple bootloader that can be executed on a PC from a USB flash memory, HDD, SDD, etc.
The bootloader is written in 16-bit NASM assembly.

Compile it to a binary using nasm:
```
nasm -f bin boot.asm -o boot.bin
```
#To run the bootloader in a emulator
Execute the compiled bootloader using QEMU:
```
qemu-system-i386 boot.bin
```

#To run the bootloader on hardware
Now wee need to write the bootloader to the MBR of an empty storage device, in this case an USB flash memory. We will use dd to write.
First of all, make sure the storage device is formatted to FAT32. Format to FAT32 using mkfs.vfat. Use fdisk to find the path to your storage device:
```
sudo fdisk -l
```
In my case the path to my storage device is /dev/sdb1. #VERY important that you don't get this wrong since there is a risk of data loss
Unmount the storage device and format it to FAT32 using the following commands:
```
sudo umount /dev/sdb1
sudo mkfs.vfat /dev/sdb1
```

Now we use dd to write the first 446 bytes of our boot.bin to the MBR of the storage device:
```
sudo dd bs=446 count=1 conv=notrunc if=boot.bin of=/dev/sdb
```
We will write directly to the storage device and not to any partition, hence the lack of number after 'sdb'.
The MBR is 512 bytes in size but we will only write 446 bytes. The reason for this is to save some place for the BPB and other data that is already present in the MBR, otherwise BIOS may refuse to load our bootloader.

To make this code executable we also need to write the last two bytes of boot.bin to the last two bytes of the MBR:
```
sudo dd bs=1 count=2 seek=510 skip=510 conv=notrunc if=boot.bin of=/dev/sdb
```

Reboot the computer and navigate to the BIOS boot menu. In there, make sure to boot from Legacy and set your storage device containing the bootloader as the top priority in the boot order.




