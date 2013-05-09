%%
% Example of the sliding EEMD
%%

% TODO: change it to use ensemble EMD

%% Input data
data = load('test/CoryHall_main_xfmr_AF_Total_.dat');
data = data(:,2);
x= data(57000:116000)';

%% Parameters
nbExtrema = 12;  % Size of the sliding window (number of extrema per window) (must be higher than 10)
nbMaxIMF = -1;  % Number of IMFs to extract (-1 for unlimited)

% Parameters for executing in an EEMD-fashion
noiseLevel = 0.0;
nbRealisation = 1;  

%% Initialization
stage = oceemdan_init(noiseLevel, nbRealisation, length(x),1); %Initializate data structures

%% Execution
figure;
newDataPkt = x ;%x(i:i+sizeDataPkt-1);

stage(1).data = [stage(1).data newDataPkt]; %add new samples to the stream   
stage = oceemdan_iter(stage, nbExtrema, nbMaxIMF); %iterate
plotIMFs(stage);
