
nbTrial = 20;
dataLength = 350000;
samp = 50000;
execTime = zeros(nbTrial,length(0:samp:dataLength));
nbIMF = zeros(nbTrial,length(0:samp:dataLength));

data = load('/home/romain/Unison/Exp/GUTP/dataBerkeley/CoryHallSorted2011/CoryHall_main_xfmr_AF_Total_.dat');
data = data(:,2);

for t = 1:nbTrial
    
    start = 1+(t-1)*10000;
    rangeTest = [start:samp:start+dataLength];
    %% Parameters for Online EMD
    nbExtrema = 11;  % Size of the sliding window (number of extrema per window) (must be higher than 6?)


    % computational time benchmark
    run = 1
    for i = rangeTest

        x = data(start:i)';
    %     
    %     start = cputime;
    %     %% EMD c code
    %     [imf, nbIter] = emdc_fix([],x,100);
    %     execTime(1,run) = cputime-start;
    %     nbIMF(1,run) = size(imf,1)-1;

        startTime = cputime;
        %% EMD Rilling stopping criterion
        [imf, nbIter] = emdc([],x);
        execTime(t,run) = cputime-startTime;
        nbIMF(t,run) = size(imf,1)-1;

        %% OnlineEMD

%         start = cputime;
%         stage = oceemdan_init(0, 1, length(x)); %Initializate data structures
%         stage(1).data = x; %add new samples to the stream   
%         stage = oceemdan_iter(stage, nbExtrema, -1); %iterate
%         execTime(3,run) = cputime-start;
%         nbIMF(f,run) = size(stage,2)-1;
% 

        run = run + 1
    end
    execTime
end
%%
% Plot the execution time for each algorithm
% figure;
% semilogy(execTime(1,:),'b-');
% hold on;
% semilogy(execTime(2,:),'k-');
% semilogy(execTime(3,:),'r-');