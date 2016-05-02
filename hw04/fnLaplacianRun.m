function RunLap = fnLaplacianRun(data,knn);
    tempLap = fnLaplacian(data,'nn',knn);
    i_size = size(tempLap,1);
    j_size = size(tempLap,2);
    Laplacian = zeros(i_size,j_size);

    for i = 1: i_size
        for j = 1: j_size
            Laplacian(i,j) = tempLap(i,j);
        end
    end
    RunLap = Laplacian;
end    