%%
% Example of the sliding EEMD
%%

%% Input data
load('test/ecg');
x=ecg;

% x=x(:)';
% desvio_x=std(x);
% if desvio_x > 1e-10
%     x=x/desvio_x;
% end

%% Parameters
nbExtrema = 10;  % Size of the sliding window (number of extrema per window) (must be higher than 10)
nbMaxIMF = -1;  % Number of IMFs to extract (-1 for unlimited)

% Parameters for executing in an EEMD-fashion
noiseLevel = 0.2;
nbRealisation = 1;  

%% Initialization
stage = oemd_init(noiseLevel, nbRealisation, length(x),1); %Initializate data structures

%% Execution
figure;

stage(1).data = [stage(1).data x]; %add new samples to the stream   
stage = oemd_iter(stage, nbExtrema, nbMaxIMF); %iterate
plotIMFs(stage,0);
