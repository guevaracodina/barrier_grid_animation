function [encodedAnimation, venetianBlindsPattern] = scanimation(varargin)
% Scanimation (a.k.a. Barrier-grid animation, picket-fence animation or
% kinegram) is an animation effect created by moving a striped transparent
% overlay across an interlaced image.
% SYNTAX
% [encodedAnimation, venetianBlindsPattern] = scanimation...
% (transparentColumnWidth, animationFolder)
% INPUTS
% [OPTIONAL INPUTS]
% transparentColumnWidth    Integer to indicate the width of the
%                           transparent columns (default: 4)
% animationFolder           Folder where the individual frames are stored.
%                           These should be black and white pictures, a number 
%                           between 2 and 6 images works fine in most 
%                           situations (default: current)
% OUTPUTS
% encodedAnimation          Image to be printed on white paper (2D matrix)
% venetianBlindsPattern     Image to be printed on a transparent medium (2D matrix)
% ______________________________________________________________________________
% Copyright (C) 2020 Edgar Guevara, PhD
% ______________________________________________________________________________

% only want 2 optional input at most
numvarargs                  = length(varargin);
if numvarargs > 2
    error('scanimation:TooManyInputs', 'Requires at most 2 optional inputs');
end
% set defaults for optional inputs
optargs                     = { 4, pwd };
% now put these defaults into the optargs cell array, and overwrite the ones
% specified in varargin.
optargs(1:numvarargs)       = varargin;
% Place optional args in memorable variable names
[transparentColumnWidth, animationFolder]   = optargs{:};
% Read all images in animationFolder
fileList = dir(animationFolder);
idxImages=1;
for idxFiles=1:length(fileList)
    currentName = fileList(idxFiles).name;
    currentFile = fullfile(animationFolder, currentName);
    try
        currentImg = imread(currentFile);  % try to read image
        imageList{idxImages} = currentFile;
        idxImages=idxImages+1;
    catch
    end
end
nFrames = numel(imageList);
% Compute width of the opaque columns in the striped pattern
opaqueColumnWidth = (nFrames - 1)*transparentColumnWidth;
imgWidth = size(currentImg, 2);
imgHeight = size(currentImg, 1);
nColumns = ceil(imgWidth / transparentColumnWidth);
% Initialize the striped pattern
venetianBlindsPattern = repmat([zeros([imgHeight, opaqueColumnWidth]), ones([imgHeight, transparentColumnWidth])], [1, nColumns]);
% Encode all frames in a single interlaced image
encodedAnimation = nan([size(venetianBlindsPattern), 3]);
for iFrames = 1:nFrames
    currentImg = imread(imageList{iFrames});
    for iColumns = 1: nColumns
        encodedAnimation(:, transparentColumnWidth*(iFrames-1)+opaqueColumnWidth*(iColumns-1)+1+(iColumns-1)*transparentColumnWidth:...
            transparentColumnWidth*(iFrames-1)+opaqueColumnWidth*(iColumns-1)+transparentColumnWidth+(iColumns-1)*transparentColumnWidth,:) = ...
            currentImg(:, 1+(iColumns-1)*transparentColumnWidth:transparentColumnWidth+(iColumns-1)*transparentColumnWidth, :);
    end
end
% Copy the striped pattern to all RGB channels
venetianBlindsPattern = repmat(venetianBlindsPattern, [1 1 3]);
% Properly resize the striped pattern
venetianBlindsPattern = imresize(venetianBlindsPattern, [nFrames*imgHeight, nColumns*(opaqueColumnWidth + transparentColumnWidth)]);
% Properly resize the interlaced image (where the animation is encoded)
encodedAnimation = imresize(encodedAnimation, [nFrames*imgHeight, nColumns*(opaqueColumnWidth + transparentColumnWidth)]);
% Save output images
imwrite(venetianBlindsPattern, 'venetianBlindsPattern.png');
imwrite(encodedAnimation, 'encodedAnimation.png');
end

% EOF