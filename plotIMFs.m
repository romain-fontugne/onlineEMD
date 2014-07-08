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

c = [[0,0,0]; [0,0,1]; [0.1,0.6,1]];

seq = [1, length(x)];
if length(x)>500 && length(x)<1502
    seq = [1, 500, length(x)];
elseif length(x)>1501
    seq = [1, 500, 1500, length(x)];
end

for ji = 1:length(seq)-1
    j = seq(ji);
   jj = seq(ji+1);

   plot(j:jj,x(j:jj),'-','LineWidth',2,'Color',c(ji,:)); % the original signal is in the first row of the subplot
   hold on;
end

axis tight;
hold off;
% plot(x,'-b','LineWidth',2);

ylabel('Data')
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
    
    seq = [1, startIncomplete];
    if startIncomplete>500 && startIncomplete<1502
        seq = [1, 500, startIncomplete];
    elseif startIncomplete>1501
        seq = [1, 500, 1500, startIncomplete];
    end
    for ji = 1:length(seq)-1
        j = seq(ji);
       jj = seq(ji+1);
        plot(j:jj,stage(i-1).imf(j:jj),'-','LineWidth',2,'Color',c(ji,:));
        hold on;
    end
        axis tight;
    hold off
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
        
        seq = [1, length(stage(i).data)];
        if length(stage(i).data)>500 && length(stage(i).data)<1502
            seq = [1, 500, length(stage(i).data)];
        elseif length(stage(i).data)>1501
            seq = [1, 500, 1500, length(stage(i).data)];
        end
        for ji = 1:length(seq)-1
            j = seq(ji);
           jj = seq(ji+1);

           plot(j:jj,stage(i).data(j:jj),'-','LineWidth',2,'Color',c(ji,:));
           hold on;
       end
           
       axis tight;
       hold off;
       ylabel ('Res.');
       set(gca,'xtick',[])
       xlim([1 xSize])
    end
end

