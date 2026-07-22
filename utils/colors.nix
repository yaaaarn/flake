{ lib }:
let
  colorUtils = import ./colorUtils.nix;

  colors = [
    "0f111d" # "0f111d"
    (colorUtils.saturate bg 0.4 "ff70c6")
    (colorUtils.saturate bg 0.4 "86ff9c")
    (colorUtils.saturate bg 0.4 "bcff82")
    (colorUtils.saturate bg 0.4 "b9da9e")
    (colorUtils.saturate bg 0.4 "7dffd4")
    (colorUtils.saturate bg 0.4 "78e0ff")
    "ffffff" # "ffffff"
  ];

  bg = builtins.elemAt colors 0;

  # Importing the functions we defined above

  bright = map (colorUtils.lighten 0.5) colors;
  brightOverridden = [ "5c677a" ] ++ (builtins.tail bright); 
in
{
  crust = colorUtils.darken 0.2 bg;
  background = bg;
  foreground = colorUtils.adjustSurface 3.5 "303742";

  # Automatically lightens "0f111d" (since it's dark)
  surface = colorUtils.adjustSurface 0.25 bg;

  # Automatically lightens "303742"
  foreground-alt = colorUtils.adjustSurface 0.5 "303742";

  x = colors ++ brightOverridden;
}
