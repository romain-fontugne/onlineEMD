%%
% Example of Online EMD with ECG data
%%

%% Input data
load('data/ecg');
x=ecg;

% x=x(:)';
% desvio_x=std(x);
% if desvio_x > 1e-10
%     x=x/desvio_x;
% end

%% Parameters
nbExtrema = 10;  % Size of the sliding window (number of extrema per window) (must be higher than 10)
nbMaxIMF = -1;  % Number of IMFs to extract (-1 for unlimited)

%% Initialization
stage = oemd_init(nbMaxIMF,nbExtrema,1); %Initializate data structures

%% Execution
figure;

stage(1).data = [stage(1).data x]; %add new samples to the stream   
stage = oemd_iter(stage); %iterate
plotIMFs(stage,0);
