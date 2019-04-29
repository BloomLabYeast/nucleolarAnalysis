function [clusterNumber, intensityStd, rawStd, area] = countClusters_walker(filename)
%% Read file into 3D matrix
imMat = readTiffStack(filename);
%% Set up strel
h = fspecial('gaussian',[5 5], 2);
%% Loop through image
for n = 1:size(imMat, 3)
    plane = imMat(:,:,n);
    %normalize plane so it mimick's experimental image processing
    tempPlane = plane - min(plane(:));
    normPlane = tempPlane./max(tempPlane(:));
    %% Pull out clusters in image
    nanPlane = normPlane;
    nanPlane(nanPlane < multithresh(nanPlane(:))) = nan;
    planeDecon = deconvblind(normPlane, h);
    planeThresh1 = planeDecon;
    planeThresh1(planeThresh1<multithresh(planeThresh1)) = nan;
    planeThresh2 = planeThresh1;
    planeThresh2(planeThresh2<multithresh(planeThresh2)) = nan;
    planeThresh2(isnan(planeThresh2)) = 0;
    planeMax = imregionalmax(planeThresh2);
    cc = bwconncomp(planeMax);
    clusterNumber(n) = cc.NumObjects;
    %% Use OTSU to BG sub the image and then re-normalize
    nucNan = normPlane;
    nucNan(normPlane < multithresh(normPlane)) = nan;
    nucTemp = nucNan - min(nucNan, [], 'omitnan');
    nucNorm = nucTemp./max(nucTemp);
    intensityStd(n) = std(nucNorm(:), 'omitnan');
    rawStd(n) = std(plane(:));
    area(n) = sum(~isnan(nucNan(:)));
%     if n == 1
%         f = figure('WindowState', 'maximized');
%         subplot(1,3,1);
%         imshow(normPlane, []);
%         title(num2str(std(normPlane(:))));
%         subplot(1,3,2);
%         imshow(nucNorm, []);
%         title(num2str(std(nanPlane(:), 'omitnan')));
%         subplot(1,3,3);
%         imshow(planeMax, []);
%         waitforbuttonpress;
%         close(f);
%     end
end