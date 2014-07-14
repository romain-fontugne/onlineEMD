%%
% Example of Online EMD with synthetic data
%%

figure();

%% Input data
% Toy signal
samp  = pi/2:.5:10000;
comp1 = sin(samp);
comp2 = sin(linspace(pi/2,10000/10,length(samp)));
comp3 = sin(linspace(pi/2,10000/30,length(samp)));
trend = linspace(0,10,length(samp));
x = comp1 + comp2 + comp3 + trend;


%% Parameters
nbExtrema = 10;  % Size of the sliding window (number of extrema per window) (must be higher than 10)
nbMaxIMF = -1;  % Number of IMFs to extract (-1 for unlimited)

%% Initialization
stage = oemd_init(nbMaxIMF,nbExtrema,0); %Initializate data structures

%% Execution
%Simulate data stream
'Press any key to add data'

sizeDataPkt = 20;   % arrival rate of the data (This is NOT the window size!)
for i=1:sizeDataPkt:length(x)-sizeDataPkt

   newDataPkt = x(i:i+sizeDataPkt-1);

   stage(1).data = [stage(1).data newDataPkt]; %add new samples to the stream   
   stage = oemd_iter(stage); % iterate
   plotIMFs(stage);
   
   pause
end