{
  ...
}:
{
  programs.git.settings.user = {
    name = "yaaaarn";
    email = "30006414+yaaaarn@users.noreply.github.com";
  }; 

  imports = [
    ./programs
    ./shell
    ./desktops
    ./ui
  ];
}
