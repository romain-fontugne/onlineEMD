%%
% Example of the sliding EEMD
%%

clear all; close all; clc;

nbExec = 100;
step = 10000;
exec = zeros(4,nbExec);


emdLabel = {'Online EMD','EMD'};


%  white noise
x1=randn(1,1100000); 

% Toy signal
samp  = pi/2:.5:550000;
comp1 = sin(samp);
trend = linspace(0,10000,length(samp));
x2 = comp1 + trend;

    
for emdFct = 1:2
    emdLabel{emdFct}
    for signal = 1:2
        signal
        if signal == 1
            x = x1;
        else
            x = x2;
        end
        
        %% Initialization of Online EMD
        if emdFct == 1
            % Parameters
            nbExtrema = 20;  % Size of the sliding window (number of extrema per window) (must be higher than 10)
            nbMaxIMF = -1;  % Number of IMFs to extract (-1 for unlimited)
            if signal == 2
                nbMaxIMF = 1;
            end
            
            % Parameters for executing in an EEMD-fashion
            noiseLevel = 0.;
            nbRealisation = 1;  

            % Initialization
            stage = oemd_init(noiseLevel, nbRealisation, length(x),0); %Initializate data structures
        
        else
            nbMaxIMF=0;
            if signal == 2
                nbMaxIMF = 1;
            end
        end
        
        
        %% Execution
        
        for i = 1:nbExec
            t = cputime; 
            if emdFct == 1
                stage(1).data = [stage(1).data x(1+(i-1)*step:i*step)]; %add new samples to the stream   
                stage = oemd_iter(stage, nbExtrema, nbMaxIMF); %iterate

            else
                % for the classical EMD we look at each execution time
               [imf, nbIter] = emdc([],x(1:i*step),[],nbMaxIMF);
%                 [imf] = emd(x(1:i*step),'FIX_H',4);
            end
            exec(2*(emdFct-1)+signal,i) = cputime-t;
        end

    %     plotIMFs(stage,0);
    end
end


%% Plot the excution times

figure()
for emdFct = 1:2
    for signal = 1:2
        if emdFct == 1
            if signal ==1
                semilogy(step:step:nbExec*(step+1),exec(2*(emdFct-1)+signal,:),'-ro','DisplayName',[emdLabel{emdFct} ': White Noise'],'LineWidth',3,'MarkerSize',8);
            else 
                hold on
                semilogy(step:step:nbExec*(step+1),exec(2*(emdFct-1)+signal,:),'-r+','DisplayName',[emdLabel{emdFct} ': Sin+trend'],'LineWidth',3,'MarkerSize',8);
            end
        else
            if signal ==1
                semilogy(step:step:nbExec*(step+1),exec(2*(emdFct-1)+signal,:),'-bo','DisplayName',[emdLabel{emdFct} ': White Noise'],'LineWidth',3,'MarkerSize',8);
            else 
                hold on
                semilogy(step:step:nbExec*(step+1),exec(2*(emdFct-1)+signal,:),'-b+','DisplayName',[emdLabel{emdFct} ': Sin+trend'],'LineWidth',3,'MarkerSize',8);
            end
        end
    end
end
legend('show','Location','Best');
grid on;

turn the grid gray
set(gca,'XMinorGrid','Off');
set(gca,'Xcolor',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5]);
Caxes = copyobj(gca,gcf);
set(Caxes, 'color', 'none', 'xcolor', 'k', 'xgrid', 'off', 'ycolor','k', 'ygrid','off');

ylabel('Execution Time (seconds)','Color','k');
xlabel('Number of samples','Color','k');

print('whitenoise_execTime.eps','-depsc');
