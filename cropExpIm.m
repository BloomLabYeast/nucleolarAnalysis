fileStruct = dir('*.tif');
%Assume an input of files in the file structure array
%pre-allocate
mipCell = cell([1,numel(fileStruct)]);
cropCell = cell([1,numel(fileStruct)]);
normCell = cell([1,numel(fileStruct)]);
stdArray = zeros([numel(fileStruct),1]);
clusterArray = zeros([numel(fileStruct), 1]);
areaArray = zeros([numel(fileStruct), 1]);
%Loop over the fileStruct array
for n = 1:numel(fileStruct)
    imMat = readTiffStack(fileStruct(n).name);
    mip = max(imMat, [], 3);
    mipCell{1,n} = mip;
    [~, idx] = max(mip(:));
    [row, col] = ind2sub(size(mip), idx);
    try
    cropMip = mip(row-27:row+27, col-27:col+27);
    catch
        padMip = padarray(mip, [27, 27], 'replicate', 'both');
        padRow = row + 27;
        padCol = col + 27;
        cropMip = padMip(padRow-27:padRow+27, padCol-27:padCol+27);
    end
    cropCell{1,n} = cropMip;
    normMip = cropMip - min(cropMip(:));
    normMip = normMip./max(normMip(:));
    normCell{1,n} = normMip;
    [clusterArray(n), stdArray(n,1),areaArray(n,1), planeMax] = expCountClusters(normMip);
end
meanCluster = mean(clusterArray);
stdCluster = std(clusterArray);
meanStd = mean(stdArray);
stdStd = std(stdArray);
meanArea = mean(areaArray) * 0.0648 * 0.0648;
stdArea = std(areaArray)  * 0.0648 * 0.0648;