{ config, ... }:
{
  system.stateVersion = 6;
  system.primaryUser = config.unravelled.system.mainUser;
}
