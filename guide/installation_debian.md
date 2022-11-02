# Born2beroot Debian Installation

Installing the Born2beroot VM has several steps involved: the creation of the virtual machine (VM) in VirtualBox, the installation of Debian OS with the creation of the root user, the partitionning of disks (including LVM) and the choice of initial software.

There is a [configuration guide](https://github.com/mcombeau/Born2beroot/blob/main/guide/configuration_debian.md) and a [bonus guide](https://github.com/mcombeau/Born2beroot/blob/main/guide/bonus_debian.md), as well.

## Pre-requisites
* [Oracle VirtualBox](https://www.virtualbox.org/) (6.1 at the time of this writing).
* [Debian](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/) (11.2.0 at the time of this writing).
* Enough free disk space.

## Creating a Virtual Machine in Virtualbox
1. Launch VirtualBox & click New.
3. Name Born2beroot, sotre it in ```/sgoinfre/goinfre/Perso/your_login``` if at 42, or else on a large USB stick. Choose Linux & Debian.
4. ```1024MB``` memory is good.
5. Create a virtual hard disk now.
6. ```VDI```.
7. ```Dynamically allocated```.
8. ```10 to 13 GB``` is enough for both mandatory and bonus parts.
9. Start Born2beroot virtual machine.

## Installing Debian
1. Select Debian ISO image as startup disk.
2. When Debian starts, choose ```Install```, not graphcal install.
3. Choose language, geographical & keyboard layout settings.
4. Hostname must be ```your_login42``` (ex. mcombeau42).
5. Domain name leave empty.
6. Choose strong root password & confirm.
7. Create user. ```your_login``` works for username & name.
8. Choose password for new user.

## Partitioning disks
1. Choose ```Manual``` partitionning.
2. Choose sda Harddisk - ```SCSI (0,0,0) (sda)``` ...
3. ```Yes``` create partition table.

We will crete 2 partitions, the first will be for an unencrypted /boot partition, the other for the encrypted logical volumes :
* ```pri/log xxGB FREE SPACE``` >> ```Create a new partition``` >> ```500 MB``` >> ```Primary``` >> ```Beginning``` >> ```Mount point``` >> ```/boot``` >> ```Done```.
* ```pri/log xxGB FREE SPACE``` >> ```Create a new partition``` >> ```max``` >> ```Logical``` >> ```Mount point``` >> ```Do not mount it``` >> ```Done```.

### Encrypting disks
1. ```Configure encrypted volumes``` >> ```Yes```.
2. ```Create encrypted volumes```
3. Choose ```sda5``` ONLY to encrypt. We DO NOT want to encrypt the ```sda /boot``` partition.
4. ```Done``` >> ```Finish``` >> ```Yes```.
5. ... wait for formatting to finish...
6. Choose a strong password for disk encryption. DO NOT forget it!

### Logical Volume Manager (LVM)
Create a volume group:
1. ```Configure the Logical Volume Manager``` >> ```Yes```.
3. ```Create Volume Group``` >> ```LVMGroup``` >> ```/dev/mapper/sda5_crypt```.

Create Logical Volumes:
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```root``` >> ```2.8G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```home``` >> ```2G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```swap``` >> ```1G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```tmp``` >> ```2G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```srv``` >> ```1.5G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```var``` >> ```2G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```var-log``` >> ```2G```

When done, ```Display configuration details``` to double check & ```Finish```.

Set filesystems and mount points for each logical volume:
* Under "LV home", ```#1 xxGB``` >> ```Use as``` >> ```Ext4``` >> ```Mount point``` >> ```/home``` >> ```Done```
* Under "LV root", ```#1 xxGB``` >> ```Use as``` >> ```Ext4``` >> ```Mount point``` >> ```/``` >> ```Done```
* Under "LV swap", ```#1 xxGB``` >> ```Use as``` >> ```swap area``` >> ```Done```
* Under "LV srv", ```#1 3GB``` >> ```Use as``` >> ```Ext4``` >> ```Mount point``` >> ```/srv``` >> ```Done```
* Under "LV tmp", ```#1 3GB``` >> ```Use as``` >> ```Ext4``` >> ```Mount point``` >> ```/tmp``` >> ```Done```
* Under "LV var", ```#1 3GB``` >> ```Use as``` >> ```Ext4``` >> ```Mount point``` >> ```/var``` >> ```Done```
* Under "LV var-log", ```#1 4GB``` >> ```Use as``` >> ```Ext4``` >> ```Mount point``` >> ```Enter manually``` >> ```/var/log``` >> ```Done```

Scroll down & ```Finish partitioning and write changes to disk```. ```Yes```.

## Finish Installation
1. ```No```, no need to scan.
2. Choose ```country``` & ```mirror```.
3. Leave proxy field ```blank```.
4. ```No```, no need to participate in study.
5. Uncheck all software.
6. ```Yes```, install GRUB >> ```/dev/sda```
7. ```Continue```.
Installation complete! The virtual machine will now reboot. Enter encryption password and log into created user.

We can verify that the install went correctly by running the following commands:
```bash
$ lsblk
$ cat /etc/os-release
```

---
Made by mcombeau: mcombeau@student.42.fr | LinkedIn: [mcombeau](https://www.linkedin.com/in/mia-combeau-86653420b/) | Website: [codequoi.com](https://www.codequoi.com)
