data = sin(-pi/2:300000)+sin([-pi/2:300000]/10)+sin([-pi/2:300000]/30)+sin([-pi/2:pi/300001:pi/2]);  

rangeTest = [50000:10000:300000];
execTime = zeros(3,length(rangeTest));
nbIMF = zeros(3,length(rangeTest));

%% Parameters for Online EMD
nbExtrema = 11;  % Size of the sliding window (number of extrema per window) (must be higher than 10)


% computational time benchmark
run = 1
for i = rangeTest

    x = data(1:i);
    
%     start = cputime;
%     %% EMD c code
%     [imf, nbIter] = emdc_fix([],x,2000);
%     execTime(1,run) = cputime-start;
%     nbIMF(1,run) = size(imf,1)-1;
    
    start = cputime;
    %% EMD Rilling stopping criterion
    [imf, nbIter] = emdc([],x);
    execTime(2,run) = cputime-start;
    nbIMF(2,run) = size(imf,1)-1;
    
    %% OnlineEMD
    
    start = cputime;
    stage = oceemdan_init(0, 1, length(x),1); %Initializate data structures
    stage(1).data = x; %add new samples to the stream   
    stage = oceemdan_iter(stage, nbExtrema, -1); %iterate
    execTime(3,run) = cputime-start;
    nbIMF(3,run) = size(stage,2)-1;
     
    execTime
    run = run + 1
end
