# Born2beroot
The 42 project Born2beroot explores the fundamentals of system administration by inviting us to install and configure a virtual machine with VirtualBox.

---

:us: For a more detailed guide, read my articles in English about this project: 
* [Born2beroot 01: Creating a Debian Virtual Machine](https://www.codequoi.com/en/born2beroot-01-creating-a-debian-virtual-machine/)
* [Born2beroot 02: Configuring a Debian Virtual Server](https://www.codequoi.com/en/born2beroot-02-configuring-a-debian-virtual-server/)

:fr: Pour un guide plus en profondeur, lire mes articles en français sur ce projet : 
* [Born2beroot 01 : créer une machine virtuelle Debian](https://www.codequoi.com/born2beroot-01-creer-une-machine-virtuelle-debian/)
* [Born2beroot 02 : configurer un serveur virtuel Debian](https://www.codequoi.com/born2beroot-02-configurer-un-serveur-virtuel-debian/)

---

## Status
Awaiting evaluation.

## Pre-requisites
* [Oracle VirtualBox](https://www.virtualbox.org/) (6.1 at the time of this writing).
* [Debian](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/) (11.2.0 at the time of this writing).
* Enough free disk space.

## Installing Born2beroot
Installation instructions below are a work in progress.

### Creating a Virtual Machine in Virtualbox
1. Launch VirtualBox & click New.
3. Name Born2beroot, sotre it in ```/sgoinfre/goinfre/Perso/your_login``` if at 42, or else on a large USB stick. Choose Linux & Debian.
4. ```1024MB``` memory is good.
5. Create a virtual hard disk now.
6. ```VDI```.
7. ```Dynamically allocated```.
8. ```30GB``` if doing bonuses. ```12GB``` is enough if not.
9. Start Born2beroot virtual machine.

### Installing Debian
1. Select Debian ISO image as startup disk.
2. When Debian starts, choose ```Install```, not graphcal install.
3. Choose language, geographical & keyboard layout settings.
4. Hostname must be ```your_login42``` (ex. mcombeau42).
5. Domain name leave empty.
6. Choose strong root password & confirm.
7. Create user. ```your_login``` works for username & name.
8. Choose password for new user.

### Partitioning disks
1. Choose ```Manual``` partitionning.
2. Choose sda Harddisk - ```SCSI (0,0,0) (sda)``` ...
3. ```Yes``` create partition table.

We will crete 2 partitions, the first will be for an unencrypted /boot partition, the other for the encrypted logical volumes :
* ```pri/log xxGB FREE SPACE``` >> ```Create a new partition``` >> ```500 MB``` >> ```Primary``` >> ```Beginning``` >> ```Mount point``` >> ```/boot``` >> ```Done```.
* ```pri/log xxGB FREE SPACE``` >> ```Create a new partition``` >> ```max``` >> ```Logical``` >> ```Mount point``` >> ```Do not mount it``` >> ```Done```.

#### Encrypting disks
1. ```Configure encrypted volumes``` >> ```Yes```.
2. ```Create encrypted volumes```
3. Choose ```sda5``` ONLY to encrypt. We DO NOT want to encrypt the ```sda /boot``` partition.
4. ```Done``` >> ```Finish``` >> ```Yes```.
5. ... wait for formatting to finish...
6. Choose a strong password for disk encryption. DO NOT forget it!

#### Logical Volume Manager (LVM)
Create a volume group:
1. ```Configure the Logical Volume Manager``` >> ```Yes```.
3. ```Create Volume Group``` >> ```LVMGroup``` >> ```/dev/mapper/sda5_crypt```.

Create Logical Volumes:
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```root``` >> ```2.8G``` or ```10G``` for bonus
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```home``` >> ```3.8G``` or ```5G``` for bonus
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```swap``` >> ```1G``` or ```2.3G``` for bonus
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```tmp``` >> ```3G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```srv``` >> ```3G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```var``` >> ```3G```
* ```Create Logical Volume``` >> ```LVMGroup``` >> ```var-log``` >> ```4G```

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

### Finish Installation
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

## Born2beroot Configuration
### Sudo setup

Log in as root:
```bash
$ su root
```

Install sudo:
```bash
# apt update
# apt upgrade
# apt install sudo
```

Add user to sudo group:
```bash
# sudo usermod -aG sudo <username>
```
Then ```exit``` root session and ```exit``` again to return to login prompt. Log in again as user.
Let's check if this user has sudo privileges:
```bash
$ sudo whoami
```
It should answer ```root```. If not, modify sudoers file as explained below and add this line:
```bash
username  ALL=(ALL:ALL) ALL
```

Edit sudoers.tmp file as root with the command:
```bash
# sudo visudo
```
And add these default settings as per subject instructions:
```bash
Defaults     passwd_tries=3
Defaults     badpass_message="Wrong password. Try again!"
Defaults     logfile="/var/log/sudo/sudo.log"
Defaults     log_input
Defaults     log_output
Defaults     requiretty
```
If ```var/log/sudo``` directory does not exist, ```mkdir var/log/sudo```.

### UFW setup
Install and enable UFW:
```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install ufw
$ sudo ufw enable
```

Check UFW status:
```bash
$ sudo ufw status verbose
```

Allow or deny ports:
```bash
$ sudo ufw allow <port>
$ sudo ufw deny <port>
```

Remove port rule:
```bash
$ sudo ufw delete allow <port>
$ sudo ufw delete deny <port>
```
Or, another method for rule deletion:
```bash
$ sudo ufw status numbered
$ sudo ufw delete <port index number>
```
Careful with the numbered method, the index numbers change after a deletion, check between deletes to get the correct port index number!

### SSH setup
Install OpenSSH:
```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install openssh-server
```

Check SSH status:
```bash
$ sudo systemctl status ssh
```

Change SSH listening port to 4242:
```bash
$ sudo nano /etc/ssh/sshd_config
```
Find this line:
```bash
#Port 22
```
And uncomment (delete #) and change it to 4242:
```bash
Port 4242
```

Restart SSH service
```bash
$ sudo systemctl restart ssh
```
Don't forget to add a UFW rule to allow port 4242!

Forward the host port 4242 to the guest port 4242: in VirtualBox, 
* go to VM >> Settings >> Network >> Adapter 1 >> Advanced >> Port Forwarding.
* add a rule: Host port 4242 and guest port 4242.

Restart SSH service after this change.

In the host terminal, connect like this:
```bash
$ ssh <username>@localhost -p 4242
```
Or like this:
```bash
$ ssh <username>@127.0.0.1 -p 4242
```
To quit the ssh connection, just ```exit```.

### Password Policy for Born2beroot
Edit ```/etc/login.defs``` and find "password aging controls". Modify them as per subject instructions:
```bash
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```
These changes aren't automatically applied to existing users, so use chage command to modify for any users and for root:
```bash
$ sudo chage -M 30 <username/root>
$ sudo chage -m 2 <username/root>
$ sudo chage -W 7 <username/root>
```
Use ```chage -l <username/root>``` to check user settings.

Install password quality verification library:
```bash
$ sudo apt install libpam-pwquality
```

Then, edit the ```/etc/security/pwquality.conf``` file like so:
``` bash
# Number of characters in the new password that must not be present in the 
# old password.
difok = 7
# The minimum acceptable size for the new password (plus one if 
# credits are not disabled which is the default)
minlen = 10
# The maximum credit for having digits in the new password. If less than 0 
# it is the minimun number of digits in the new password.
dcredit = -1
# The maximum credit for having uppercase characters in the new password. 
# If less than 0 it is the minimun number of uppercase characters in the new 
# password.
ucredit = -1
# ...
# The maximum number of allowed consecutive same characters in the new password.
# The check is disabled if the value is 0.
maxrepeat = 3
# ...
# Whether to check it it contains the user name in some form.
# The check is disabled if the value is 0.
usercheck = 1
# ...
# Prompt user at most N times before returning with error. The default is 1.
retry = 3
# Enforces pwquality checks on the root user password.
# Enabled if the option is present.
enforce_for_root
# ...
```
Change user passwords to comply with password policy:
```bash
$ sudo passwd <user/root>
```

### Hostname, Users and Groups
The hostname must be ```your_intra_login42```, but the hostname must be changed during the Born2beroot evaluation. The following commands might help:
```bash
$ sudo hostnamectl set-hostname <new_hostname>
$ hostnamectl status
```

There must be a user with ```your_intra_login``` as username. During evaluation, you will be asked to create, delete, modify user accounts. The following commands are useful to know:
* ```useradd``` : creates a new user.
* ```usermod``` : changes the user’s parameters: ```-l``` for the username, ```-c``` for the full name, ```-g``` for groups by group ID.
* ```userdel -r``` : deletes a user and all associated files.
* ```id -u``` : displays user ID.
* ```users``` : shows a list of all currently logged in users.
* ```cat /etc/passwd | cut -d ":" -f 1``` : displays a list of all users on the machine.
* ```cat /etc/passwd | awk -F '{print $1}'``` : same as above.

The user named your_intra_login must be part of the ```sudo``` and ```user42``` groups. You must also be able to manipulate user groups during evaluation with the following commands:
* ```groupadd``` : creates a new group.
* ```gpasswd -a``` : adds a user to a group.
* ```gpasswd -d``` : removes a user from a group.
* ```groupdel``` : deletes a group.
* ```groups``` : displays the groups of a user.
* ```id -g``` : shows a user’s main group ID.
* ```getent group``` : displays a list of all users in a group.

### Monitoring.sh
Write [```monitoring.sh```](https://github.com/mcombeau/Born2beroot/blob/main/monitoring.sh) file as root and put it in /root directory.

Check the following commands to figure out how to write the script:
* ```uname``` : architecture information
* ```/proc/cpuinfo``` : CPU information
* ```free``` : RAM information
* ```df``` : disk information
* ```top -bn1``` : process information
* ```who``` : boot and connected user information
* ```lsblk``` : partition and LVM information
* ```/proc/net/sockstat``` : TCP information
* ```hostname``` : hostname and IP information
* ```ip link show``` / ```ip address``` : IP and MAC information

Remember to give the script execution permissions, i.e.:
```bash
chmod 755 monitoring.sh
```

The ```wall``` command allows us to broadcast a message to all users in all terminals. This can be incorporated into the monitoring.sh script or added later in cron.

To schedule the broadcast every 10 minutes, we need to enable cron:
```bash
# systemctl enable cron
```
Then start a crontab file for root:
```bash
# crontab -e
```
And add the job like this:
```bash
*/10 * * * * bash /root/monitoring.sh
```
Or, if the wall command isn't incorporated into the monitoring script:
```bash
*/10 * * * * bash /root/monitoring.sh | wall
```
## Signature.txt
To extract the VM's signature for the correction, go to the Virtual Box VMs folder in your local computer:
* Windows: ```%HOMEDRIVE%%HOMEPATH%\VirtualBox VMs\```
* Linux: ```~/VirtualBox VMs/```
* MacM1: ```~/Library/Containers/com.utmapp.UTM/Data/Documents/```
* MacOS: ```~/VirtualBox VMs/```

Then use the following command (replace ```centos_serv``` with your machine name):
* Windows: ```certUtil -hashfile centos_serv.vdi sha1```
* Linux: ```sha1sum centos_serv.vdi```
* For Mac M1: ```shasum Centos.utm/Images/disk-0.qcow2```
* MacOS: ```shasum centos_serv.vdi```

And save the signature to a file named ```signature.txt```.


---
Made by mcombeau: mcombeau@student.42.fr | LinkedIn: [mcombeau](https://www.linkedin.com/in/mia-combeau-86653420b/) | Website: [codequoi.com](https://www.codequoi.com)
