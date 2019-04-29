function [clusterNumber, intensityStd, pixelArea, planeMax] = expCountClusters(mip)
%% Set up strel
%% Count clusters
h = fspecial('gaussian',[5 5], 2);
planeDecon = deconvblind(mip, h);
planeThresh1 = planeDecon;
planeThresh1(planeThresh1<multithresh(planeThresh1)) = nan;
planeThresh2 = planeThresh1;
planeThresh2(planeThresh2<multithresh(planeThresh2)) = nan;
planeThresh2(isnan(planeThresh2)) = 0;
% structuring element
SE = strel('disk', 1);
planeOpen = imopen(planeThresh2, SE);
planeMax = imregionalmax(planeOpen);
cc = bwconncomp(planeMax);
clusterNumber = cc.NumObjects;
%% Calculate normalized std of intensity
nucNan = mip;
nucNan(mip < multithresh(mip)) = nan;
pixelArea = sum(~isnan(nucNan(:)));
nucTemp = nucNan - min(nucNan, [], 'omitnan');
nucNorm = nucTemp./max(nucTemp);
intensityStd = std(nucNorm(:), 'omitnan');
end