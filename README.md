# Born2beroot
The 42 project Born2beroot explores the fundamentals of system administration by inviting us to instal and configure a virtual machine with VirtualBox.

## Pre-requisites
* [Oracle VirtualBox](https://www.virtualbox.org/) (6.1 at the time of this writing).
* [Debian](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/) (11.2.0 at the time of this writing).
* Enough free disk space.

## Installation
Installation instructions below are a work in progress.

### In VirtualBox
1. Launch VirtualBox & click New.
3. Name Born2beroot, sotre it in /sgoinfre/goinfre/Perso/your_login if at 42, or else on a large USB stick. Choose Linux & Debian.
4. 1024MB memory is good.
5. Create a virtual hard disk now.
6. VDI.
7. Dynamically allocated.
8. 30GB if doing bonuses. 12GB is enough if not.
9. Start Born2beroot virtual machine.

### Installing Debian
1. Select Debian ISO image as startup disk.
2. When Debian starts, choose Install, not graphcal install.
3. Choose language, geographical & keyboard layout settings.
4. Hostname must be your_login42 (ex. mcombeau42).
5. Domain name leave empty.
6. Choose strong root password & confirm.
7. Create user. your_login works for username & name.
8. Choose password for new user.

### Partitioning disks
1. Choose manual partitionning.
2. Choose sda Harddisk - SCSI (0,0,0) (sda) ...
3. Yes create partition table.
4. Select pri/log FREE SPACE.
5. Create a new partition, this will be for unencrypted /boot partition.
6. 500 MB is enough.
7. Primary.
8. Beginning.
9. Change mount point to /boot.
10. Done.
11. Select pri/log FREE SPACE.
12. Create a new partition. This will be for our encrypted logical volumes.
13. Use all of the free space left, i.e "max".
14. Logical.
15. Change mount point to "Do not mount it".
16. Done.
17. Configure encrypted volumes.
18. Yes write changes.

...
WIP!
...

---
Made by mcombeau: mcombeau@student.42.fr | LinkedIn: [mcombeau](https://www.linkedin.com/in/mia-combeau-86653420b/) | Website: [codequoi.com](https://www.codequoi.com)
