# Network Device Backup Scripts

This repo is a collection of simple scripts to help you automatically backup your network devices. It is released under the GPLv3 license. If you need a version released under a different license, or need commercial support, contact [Rootwork InfoTech LLC](https://rootwork.it).

Further explanation of the concepts can be found in my article [Secure Automated Network Device Backups](https://shocksolution.com/2019/09/03/secure-automated-network-device-backups/). If you have comments or questions, please comment on the article, and feel free to submit a pull request for this repo.

## Backup Server Configuration

The backup server must have an SFTP server installed and secured. For routers in the VyOS family, including Ubiquiti EdgeRouters running EdgeOS, the SFTP backup user must be able to connect to SFTP with a passwordless SSH key. For Netgear switches, password-based login to the SFTP server is required. I highly recommend that the backup user is only allowed SFTP access (not SSH or SCP) within a chroot jail.

Once SFTP is working, create a directory for each network device within the backup user's home directory (in the SFTP path):

```
backup
├── core-switch
├── edge-switch
├── router
```

Set up a nightly cron job that uses script `makeBackupDirs.sh` to create a date-stamped subdirectory within each device's directory. This cron job should finish prior to the scheduled backups for the network devices.

## Netgear Switches

`netgearBackup.sh` is designed to back up fully managed Netgear switches, such as the M4200 and M4300 series. I have not tested it on the M4100, M5300, or M6100 series, but it may work if they use the same operating system. It should also work on some of the older Layer 3 Netgear switches, but may require slight modifications.

### Backup Server Configuration

These switches don't have the ability to trigger a scheduled backup, so you need a cron job that runs the script `netgearbackup.sh` on the backup server.  The server also needs to have the package installed which provides the `expect` utility. On yum/dnf systems, the package is just called `expect`.

Use the simple script `testnetgear.sh` to test your backup configuration. Placing login credentials in this script avoids having the passwords stored in your bash history.

### Switch Configuration

I recommend creating a user called "backup" on the switch with read-only privileges. This user's password will be stored in the crontab on the backup server. If untrusted users can access the backup server and read the crontab, you should consider modifying the script to look for credentials in a file in a secure path.

## VyOS/EdgeOS Routers

VyOS/EdgeOS, including Ubiquiti EdgeRouters, supports running scheduled backups from the router. Install `vyosBackup.sh` in `/config/scripts` and use the command-line interface to create a scheduled task. It should look something like this:

```
show system task-scheduler

 task BACKUP {
     crontab-spec "50 1 * * *"
     executable {
         path /config/scripts/vyosBackup.sh
     }
 }
```

The SFTP user must have a passwordless SSH private key on the router, and you must update the script with the path to this key. Note that anyone who compromises the router will have SSH access to your backup server as well, so I highly recommend restricting the backup user to SFTP only in a chroot jail, to minimize the impact of a security breach on the router.