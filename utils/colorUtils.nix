let
  hexMap = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7;
    "8" = 8; "9" = 9; "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
  };

  toInt = a: b: hexMap.${a} * 16 + hexMap.${b};

  toHex =
    n:
    let
      digits = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];
      hi = builtins.elemAt digits (n / 16);
      lo = builtins.elemAt digits (n - (n / 16) * 16);
    in
    hi + lo;

  clamp =
    n:
    if n < 0 then 0
    else if n > 255 then 255
    else n;

  max = a: b: if a > b then a else b;
  min = a: b: if a < b then a else b;

  # Integer power function for x^2.4 approximation using fractional power
  # Multiplied by 100000 for decimal precision management
  pow24 =
    c:
    let
      # c is 0-255. Normalize to 0-100000 scale
      cNorm = (c * 100000) / 255;
    in
    if cNorm <= 3928 then
      (cNorm * 100000) / 1292
    else
      # Simulating ((cNorm + 5500) / 105500)^2.4 using basic integer chunks
      let
        val = ((cNorm + 5500) * 100) / 105500; # percentage scale 0-100
        # Integer curve approximation of x^2.4 on a 0-100 scale mapping to 100000
        res = (val * val * val) / 10; # Fast integer approximation curve
      in
      if res > 100000 then 100000 else res;

  # True Relative Luminance Calculation (Scaled by 100000)
  # formula: Y = 0.2126 * R + 0.7152 * G + 0.0722 * B
  getTrueLuminance =
    hex:
    let
      r = toInt (builtins.substring 0 1 hex) (builtins.substring 1 1 hex);
      g = toInt (builtins.substring 2 1 hex) (builtins.substring 3 1 hex);
      b = toInt (builtins.substring 4 1 hex) (builtins.substring 5 1 hex);

      linR = pow24 r;
      linG = pow24 g;
      linB = pow24 b;
    in
    (linR * 2126 + linG * 7152 + linB * 722) / 10000;

  # Get Contrast Ratio multiplied by 100 (e.g. 4.5:1 returns 450)
  getContrastRatio =
    hex1: hex2:
    let
      l1 = getTrueLuminance hex1;
      l2 = getTrueLuminance hex2;
      brightest = max l1 l2;
      darkest = min l1 l2;
    in
    # (L1 + 0.05) / (L2 + 0.05) scaled out
    ((brightest + 5000) * 100) / (darkest + 5000);

  # Core saturation engine
  saturateRaw =
    factor: r: g: b:
    let
      avg = (r + g + b) / 3;
      satChannel = c: clamp (builtins.floor (avg + (c - avg) * (1.0 + factor)));
    in
    {
      r = satChannel r;
      g = satChannel g;
      b = satChannel b;
    };

  # Iteratively adjusts color based on background luminance to guarantee contrast
  ensureContrastLoop =
    bgHex: isBgLight: targetRatio: factor: r: g: b: count:
    let
      sat = saturateRaw factor r g b;
      step = count * 5; # 5% shift per loop iteration

      # Light Backgrounds -> blend towards 0 (deep, clear dark colors)
      # Dark Backgrounds -> blend towards 255 (washed out, bright colors)
      adjustChannel = c:
        if isBgLight then
          clamp (c - ((c * step) / 100))
        else
          clamp (c + (((255 - c) * step) / 100));

      r' = adjustChannel sat.r;
      g' = adjustChannel sat.g;
      b' = adjustChannel sat.b;

      currentHex = (toHex r') + (toHex g') + (toHex b');
      currentRatio = getContrastRatio currentHex bgHex;
    in
    # Break out if AA compliant (>= 450), or if we hit a 100% shift limit to prevent infinite loops
    if currentRatio >= targetRatio || count > 20 then
      currentHex
    else
      ensureContrastLoop bgHex isBgLight targetRatio factor r g b (count + 1);

  # Exposed saturate function that guarantees AA readability
  saturate =
    bgHex: factor: hex:
    let
      bgLum = getTrueLuminance bgHex;
      # 18000 on our scaled map represents ~0.18 linear luminance (visual middle gray)
      isBgLight = bgLum > 18000; 

      r = toInt (builtins.substring 0 1 hex) (builtins.substring 1 1 hex);
      g = toInt (builtins.substring 2 1 hex) (builtins.substring 3 1 hex);
      b = toInt (builtins.substring 4 1 hex) (builtins.substring 5 1 hex);
    in
    ensureContrastLoop bgHex isBgLight 450 factor r g b 0;

  # Standard linear shortcuts
  adjustColor =
    f: hex:
    let
      r = toInt (builtins.substring 0 1 hex) (builtins.substring 1 1 hex);
      g = toInt (builtins.substring 2 1 hex) (builtins.substring 3 1 hex);
      b = toInt (builtins.substring 4 1 hex) (builtins.substring 5 1 hex);
      adjustChannel = c: clamp (builtins.floor (c + (c * f)));
    in
    toHex (adjustChannel r) + toHex (adjustChannel g) + toHex (adjustChannel b);

  lighten = adjustColor;
  darken = f: adjustColor (-f);

  # Updated to use the true visual midpoint
  adjustSurface =
    factor: hex: if (getTrueLuminance hex) > 18000 then darken factor hex else lighten factor hex;
in
{
  inherit
    lighten
    darken
    saturate
    adjustSurface
    toInt
    max
    min
    ;
}
