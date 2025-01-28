{
  hostName,
  myvars,
  ...
}:
#############################################################
#
#  Host & Users configuration
#
#############################################################
{
  networking.hostName = hostName;
  networking.computerName = hostName;
  system.defaults.smb.NetBIOSName = hostName;

  users.users."${myvars.user}" = {
    home = "/Users/${myvars.user}";
    description = myvars.user;
  };

  nix.settings.trusted-users = [myvars.user];
}
