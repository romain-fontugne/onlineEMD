% computational time benchmark
data = load('CoryHall_main_xfmr_AF_Total_.dat');
data = data(:,2);

begin = 1;
len = 250000;
step = 10000;
nbTrial = 20;
execTimeRill = zeros(nbTrial,1);
execTimeOEMD = zeros(nbTrial,1);

%% Parameters for Online EMD
nbExtrema = 10;  % Size of the sliding window (number of extrema per window, must be higher than 10)

for j =1:nbTrial
    sampleSize = [begin+j*step:step:begin+j*step+len];
    run = 1
    for i = sampleSize
        
        x = data(begin+(j-1)*step:i)';

    %     %% EMD with fix number of sifting
    %     start = cputime;
    %     [imf] = emdc_fix([],x,10);
    % %     imf = emd(x,'FIX',5);
    %     execTime(1,run) = cputime-start;
    %     nbIMF(1,run) = size(imf,1)-1;     
    %     


        %% EMD with the stoping criteria from Rilling 2003
        start = cputime;
        [imf,sift] = emdc([],x);
    %     imf = emd(x,'MAXITERATIONS',1000000);
        execTimeRill(j,run) = cputime-start


        %% OnlineEMD
        start = cputime;

        % Initialization
        stage = oceemdan_init(0, 1, length(x),1); %Initializate data structures

        stage(1).data = x; %add new samples to the stream   
        stage = oceemdan_iter(stage, nbExtrema, -1); %iterate
        execTimeOEMD(j,run) = cputime-start

        run = run + 1
    end
end

%%
sampleSize = begin+step:step:begin+step+len;
figure;
% plot(sampleSize,execTime(1,:),'-b+','LineWidth',2,'MarkerSize',9);
errorbar(sampleSize,mean(execTimeRill(:,:)),std(execTimeRill(:,:)),'-.k*','LineWidth',2,'MarkerSize',6);
hold on;
errorbar(sampleSize,mean(execTimeOEMD(:,:)),std(execTimeOEMD(:,:)),'-r+','LineWidth',2,'MarkerSize',6);
legend('EMD (Rilling et al.)','Online EMD (10 siftings)','Location','NorthWest');
xlabel('Number of samples','FontSize',12);
ylabel('Execution Time (seconds)','FontSize',12);
set(gca,'FontSize',12);
axis([sampleSize(1) sampleSize(end)+step 0 450])


%     start = cputime;
%     %% EMD with the confidence limit stopping criteria
% %     imf = emd(x,'FIX_H',4,'MAXITERATIONS',1000000);
%     imf = emd(x,'FIX_H',4,'MAXITERATIONS',1000000);
%     execTime(1,run) = cputime-start;
%     nbIMF(1,run) = size(imf,1)-1;
    %     
%     %% local EMD
%     start = cputime;
%     [imf,~,~] = emd_local(x);
%     execTime(3,run) = cputime-start;
%     nbIMF(3,run) = size(imf,1)-1;     

    