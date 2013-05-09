files = dir('/home/romain/Unison/Exp/GUTP/dataBerkeley/CoryHallSorted2011/*.dat');

nbFiles = size(files,1);
rangeTest = [10000:10000:500000];
execTime = zeros(nbFiles,length(rangeTest));
nbIMF = zeros(nbFiles,length(rangeTest));

for f = 1:size(files,1)
    
    data = load(['/home/romain/Unison/Exp/GUTP/dataBerkeley/CoryHallSorted2011/' files(f).name]);
    data = data(:,2);

    %% Parameters for Online EMD
    nbExtrema = 14;  % Size of the sliding window (number of extrema per window) (must be higher than 6?)


    % computational time benchmark
    run = 1
    for i = rangeTest

        if length(data)<i
                continue
        end


        x = data(1:i)';
    %     
    %     start = cputime;
    %     %% EMD c code
    %     [imf, nbIter] = emdc_fix([],x,100);
    %     execTime(1,run) = cputime-start;
    %     nbIMF(1,run) = size(imf,1)-1;

        start = cputime;
        %% EMD Rilling stopping criterion
        [imf, nbIter] = emdc([],x);
        execTime(2,run) = cputime-start;
        nbIMF(2,run) = size(imf,1)-1;

        %% OnlineEMD

%         start = cputime;
%         stage = oceemdan_init(0, 1, length(x)); %Initializate data structures
%         stage(1).data = x; %add new samples to the stream   
%         stage = oceemdan_iter(stage, nbExtrema, -1); %iterate
%         execTime(3,run) = cputime-start;
%         nbIMF(f,run) = size(stage,2)-1;

        execTime
        run = run + 1
    end

end
%%
% Plot the execution time for each algorithm
% figure;
% semilogy(execTime(1,:),'b-');
% hold on;
% semilogy(execTime(2,:),'k-');
% semilogy(execTime(3,:),'r-');
