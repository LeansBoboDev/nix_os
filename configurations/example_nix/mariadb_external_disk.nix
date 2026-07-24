{ pkgs, ... }:

{
  # Mount the external disk that will hold the MariaDB data directory.
  # Use /dev/disk/by-uuid/... (stable across reboots) instead of /dev/sdX.
  # Find the UUID with `lsblk -f`. Filesystem must support unix permissions
  # (ext4/btrfs/xfs) — not exfat/ntfs.
  fileSystems."/srv/mariadb" = {
    device = "/dev/disk/by-uuid/change_it_to_the_disk_uuid_using_lsblk";
    fsType = "ext4";
    # If the disk is unplugged, boot continues normally instead of waiting/
    # dropping to emergency mode. mysql.service still won't start without it
    # (see the requires/after below).
    options = [ "nofail" ];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    # Data directory lives on the external disk mounted above, instead of
    # the default /var/lib/mysql on the system disk/SD card.
    dataDir = "/srv/mariadb/mysql";

    # Local access only: no port is opened, clients on this machine connect
    # through the unix socket at /run/mysqld/mysqld.sock.
    settings.mysqld = {
      # 0.0.0.0 (Everyone)
      # 127.0.0.1 (Localhost Only)
      bind-address = "0.0.0.0";
    };

    ensureDatabases = [ "database_name_change_it_ok" ];
    ensureUsers = [
      {
        # Auth is via unix socket (peer auth): the Linux user "linux_user_name_change_itok_probably_will_be_admin"
        # connects as this MySQL user with no password. Create that Linux user
        # (or add its name here to match an existing one) before relying on this.

        # Consider changing the password after the database up
        # sudo mysql -e "ALTER USER 'linux_user_name_change_it_ok_probably_will_be_admin'@'%' IDENTIFIED BY 'very_stong_password_goes_here';"
        name = "linux_user_name_change_it_ok_probably_will_be_admin";
        ensurePermissions = {
          "database_name_change_it_ok.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Make sure the external disk is mounted before MariaDB starts, otherwise
  # it may initialize a fresh database directly on the empty mount point.
  # Unit name is the mount path with "/" turned into "-" (systemd-escape).
  systemd.services.mysql = {
    after = [ "srv-mariadb.mount" ];
    requires = [ "srv-mariadb.mount" ];
  };
}
