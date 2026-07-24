{ secrets, osConfig, ... }: {
  programs.neomutt.enable = true;
  programs.mbsync.enable = true;
  services.mbsync.enable = true; # systemd timer (5m)

  accounts.email.accounts.yarn = {
    primary = true;
    address = secrets.emailAddress;
    realName = "yarncat";
    userName = secrets.emailAddress;

    passwordCommand = "cat ${osConfig.age.secrets.email-password.path}";

    mbsync = {
      enable = true;
      create = "both";
    };

    imap = {
      host = "imap.purelymail.com";
      port = 993;
      tls.enable = true;
    };

    smtp = {
      host = "smtp.purelymail.com";
      port = 465;
      tls.enable = true;
    };

    folders = {
      inbox = "INBOX";
      sent = "Sent";
      trash = "Deleted Messages";
    };

    neomutt.enable = true;
  };
}
