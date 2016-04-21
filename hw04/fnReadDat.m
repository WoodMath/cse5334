function [raw, classes, trainData] = fnReadDat(filename) 
    raw = csvread(filename);
    
    classes = raw(1,:);
    trainData = raw(2:size(raw,1),:);
end