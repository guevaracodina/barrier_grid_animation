# scanimation
Scanimation (a.k.a. Barrier-grid animation, picket-fence animation or kinegram) is an animation effect created by moving a striped transparent overlay across an interlaced image.
SYNTAX
[encodedAnimation, venetianBlindsPattern] = scanimation...
(transparentColumnWidth, animationFolder)
INPUTS
[OPTIONAL INPUTS]
transparentColumnWidth    Integer to indicate the width of the
                          transparent columns (default: 4)
animationFolder           Folder where the individual frames are stored.
                          These should be black and white pictures, a number 
                          between 2 and 6 images works fine in most 
                          situations (default: current)
OUTPUTS
encodedAnimation          Image to be printed on white paper (2D matrix)
venetianBlindsPattern     Image to be printed on a transparent medium (2D matrix)
______________________________________________________________________________
Copyright (C) 2020 Edgar Guevara, PhD
______________________________________________________________________________
