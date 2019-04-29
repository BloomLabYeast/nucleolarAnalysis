% Since tiffs are labeled 0 to 19, use for loop iterator, m, to index
% preallocate container variables, 20 images with 22 time points
clusterMat = zeros([20, 22]);
bgSubStdMat = zeros([20, 22]);
areaMat = zeros([20, 22]);
for m = 0:19
    [clusterMat(m+1,:), bgSubStdMat(m+1,:), rawMat(m+1,:), areaMat(m+1,:)] = countClusters_walker(sprintf('%d.tif', m));
end
meanStd = mean(bgSubStdMat,2);
stdStd = std(bgSubStdMat, 0, 2);
meanCluster = mean(clusterMat, 2);
stdCluster = std(clusterMat, 0, 2);
meanArea = mean(areaMat, 2) * 0.0645 * 0.0645;
stdArea = std(areaMat, 0, 2) * 0.0645 * 0.0645;
meanRaw = mean(rawMat, 2);
stdRaw = std(rawMat, 0, 2);