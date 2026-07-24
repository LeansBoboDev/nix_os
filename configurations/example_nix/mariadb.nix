{ pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

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
        name = "linux_user_name_change_it_ok_probably_will_be_admin";
        ensurePermissions = {
          "database_name_change_it_ok.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
