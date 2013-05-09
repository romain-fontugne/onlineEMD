function [] = plotIMFs(stage,incompleteIMF)

% data is the first residual
x = stage(1).data;

% Look for the last IMF
i=1;
while stage(i).windowHead~=1
    i=i+1;
end
nbIMF=i;

xSize = length(x);

if(nargin==1)
    incompleteIMF=1;
end

% Plot the data, IMF and residual
% figure;
subplot(nbIMF+2,1,1);
plot(x,'-b','LineWidth',2);% the original signal is in the first row of the subplot
axis tight;
axis tight
ylabel('data')
set(gca,'xtick',[])
xlim([1 xSize])
for i=2:nbIMF
    
    if i~=nbIMF
        startIncomplete = length(stage(i).imf);
    else
        startIncomplete = length(stage(i).data);
    end
    
    % Plot the IMF
    subplot(nbIMF+2,1,i);
    plot(stage(i-1).imf(1:startIncomplete),'-b','LineWidth',2);
    axis tight;
    
    if incompleteIMF
        hold on;
    
        % Highlight the IMF part that is being processed
        plot(startIncomplete:length(stage(i-1).imf),stage(i-1).imf(startIncomplete:end),'color',[1,0,0],'LineWidth',2)
        axis tight;
        hold off
    end
    
    ylabel (['IMF ' num2str(i-1)]);
    set(gca,'xtick',[])
    xlim([1 xSize])

    if i==nbIMF   %Plot the residual
       subplot(nbIMF+2,1,i+1);
       plot(stage(i).data,'-b','LineWidth',2);
       axis tight;
       ylabel ('Res.');
       set(gca,'xtick',[])
       xlim([1 xSize])
    end
end

