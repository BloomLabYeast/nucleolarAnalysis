fileStruct = dir('*.tif');
%Assume an input of files in the file structure array
%pre-allocate
mipCell = cell([1,numel(fileStruct)]);
normCell = cell([1,numel(fileStruct)]);
stdArray = zeros([numel(fileStruct),1]);
clusterArray = zeros([numel(fileStruct), 1]);
areaArray = zeros([numel(fileStruct), 1]);
%Loop over the fileStruct array
for n = 1:numel(fileStruct)
    imMat = readTiffStack(fileStruct(n).name);
    mip = max(imMat, [], 3);
    mipCell{1,n} = mip;
    normMip = mip - min(mip(:));
    normMip = normMip./max(normMip(:));
    normCell{1,n} = normMip;
    [clusterArray(n), stdArray(n,1), areaArray(n,1), planeMax] = expCountClusters(normMip);
%     h = figure('WindowState', 'maximized');
%     title(num2str(clusterArray(n)));
%     subplot(1,2,1);
%     imshow(normMip, []);
%     subplot(1,2,2);
%     imshow(planeMax, []);
%     waitforbuttonpress;
%     close(h);
end
meanCluster = mean(clusterArray);
stdCluster = std(clusterArray);
meanStd = mean(stdArray);
stdStd = std(stdArray);
meanArea = mean(areaArray) * 0.0648 * 0.0648;
stdArea = std(areaArray)  * 0.0648 * 0.0648;
