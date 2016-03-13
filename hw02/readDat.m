function [raw, classes, trainData] = readDat(filename) 
    raw = csvread(filename);
    
    classes = raw(1,:);
    trainData = raw(2:645,:);
end