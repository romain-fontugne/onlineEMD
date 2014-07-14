function [stream] = oemd_iter(stream)
%OCEEMDAN_ITER 

bound = 3;
nbExtrema = stream(1).nbExtrema;
maxIMF = stream(1).maxIMF;

if(nargin==2)
    maxIMF = -1;
end

[minInd, maxInd] = extr(stream(1).data(stream(1).windowTail:end));
minInd=minInd+stream(1).windowTail-1;
maxInd=maxInd+stream(1).windowTail-1;
extrInd = sort([minInd maxInd]);

if maxIMF==0 || (length(extrInd) < nbExtrema) %Not enough extrema to extract IMF
    return
end

%[stop_sift,moyenne,s] = stop_sifting(stream(1).data(stream(1).windowTail:end),[1:max(size(stream(1).data(stream(1).windowTail:end)))],0.05,0.5,0.05,'spline',0,4);

while length(extrInd) >= nbExtrema %Enough data to compute the corresponding IMFs
    
    if stream(1).windowTail ~= 1 && extrInd(1) ~= stream(1).windowTail+1  %needed to fix issues with extr function
        extrInd = [stream(1).windowTail+1 extrInd];
    end
    
    newWindowHead=extrInd(nbExtrema);
    
    switch stream(1).emdAlgo
        case 0
            % Rilling stopping criteria (C code)
            [acumIMF]=emdc([],stream(1).data(stream(1).windowTail:newWindowHead+1),[],1);            
        case 1
            % Fix: 10 Siftings (C code)
            [acumIMF]=emdc_fix([],stream(1).data(stream(1).windowTail:newWindowHead+1),10,1);
        case 2
            % Confidence limit stopping criteria (Matlab code)
            [acumIMF] = emd(stream(1).data(stream(1).windowTail:newWindowHead+1),'MAXMODES',1,'FIX_H',4);
%             [acumIMF] = emd(stream(1).data(stream(1).windowTail:newWindowHead+1),'MAXMODES',1,'STOP',[0.05,0.5,0.05]);
        otherwise
            error('EMD function unknown')
%         [acumIMF]=emd(stream(1).data(stream(1).windowTail:newWindowHead+1),'MAXMODES',1);
%          [acumIMF]=emd(stream(1).data(stream(1).windowTail:newWindowHead+1),'MAXMODES',1,'FIX',5);
%             
    end

    %Store the computed mean IMF
    prevWindowHead = stream(1).windowHead;
%     sigma = 1;%((nbExtrema-1)/6)-(1/3);
    if stream(1).windowTail ~= 1
        ind = zeros(1,length(extrInd(1)-stream(1).windowTail:extrInd(nbExtrema)-stream(1).windowTail)); 
        lastExtrema = (1:nbExtrema-1)+1-(nbExtrema+1)/2;
        i1 = 1+extrInd(1:nbExtrema-1)-stream(1).windowTail;
        i2 = extrInd(2:nbExtrema)-stream(1).windowTail;
        len = 1+i2(1:nbExtrema-1)-i1(1:nbExtrema-1);
        for i=1:nbExtrema-1
            ind(i1(i):i2(i)) = ((1/len(i))+(lastExtrema(i)-1):1/len(i):lastExtrema(i));
        end
        ind = ind.*(bound/((nbExtrema-1)/2));
        ind(1) = -bound;
        w = (1/(sqrt(2*pi))*exp(-1/2*ind.^2)) - (1/(sqrt(2*pi))*exp(-1/2*bound^2));  % normal distribution with sigma = 1
        weightedIMF = w.*acumIMF(1,2:end-1); 

        %Concatenate and sum with the IMF previously computed
        stream(1).imf(stream(1).windowTail+1:stream(1).windowTail+length(weightedIMF)) = [stream(1).imf(stream(1).windowTail+1:prevWindowHead-1)+(weightedIMF(1:(prevWindowHead-1)-stream(1).windowTail)) weightedIMF(prevWindowHead-stream(1).windowTail:end)];
        stream(1).weights(stream(1).windowTail+1:stream(1).windowTail+length(weightedIMF)) = [stream(1).weights(stream(1).windowTail+1:prevWindowHead-1)+(w(1:(prevWindowHead-1)-stream(1).windowTail)) w(prevWindowHead-stream(1).windowTail:end)]; 
        %Normalize
        stream(1).imf(stream(1).windowTail+1:extrInd(2)-1) = stream(1).imf(stream(1).windowTail+1:extrInd(2)-1)./stream(1).weights(stream(1).windowTail+1:extrInd(2)-1);
    else
        weights = zeros(1,length(1:extrInd(nbExtrema)-1));
        weights(1:extrInd(2)) = 1;
        for i=2:nbExtrema-1
            indPart = 1+extrInd(i):extrInd(i+1);
            dataLength = length(indPart);
            w = zeros(1,length(indPart));
            for j=i:nbExtrema-1
                lastExtrema = j+1-(nbExtrema+1)/2;
                indTmp = ((1/dataLength)+(lastExtrema-1):1/dataLength:lastExtrema);
                indTmp = indTmp.*(bound/((nbExtrema-1)/2));
                w = w+(1/(sqrt(2*pi))*exp(-1/2*indTmp.^2)) - (1/(sqrt(2*pi))*exp(-1/2*bound^2));
            end
            weights(indPart) = w;
        end
        stream(1).imf = acumIMF(1,1:end-1).*weights;
        stream(1).weights = weights;
        
        
    end

    
    %Store the residual
    nextWindowTail = extrInd(2)-1;
%     nextWindowTail = extrInd(nbExtrema/2)-1; % Try to move faster the window
    if stream(1).windowTail ~= 1
        residualTail = stream(1).data(stream(1).windowTail+1:nextWindowTail)-stream(1).imf(stream(1).windowTail+1:nextWindowTail);
    else
        residualTail = stream(1).data(1:nextWindowTail)-stream(1).imf(1:nextWindowTail) ;
    end
        
    if size(stream,2)<2    % If we went through all the noise IMF we stop adding noise
        stream(2)=struct('data',[],'imf',[],'windowTail',1,'windowHead',1, 'weights', [], 'emdAlgo', stream(1).emdAlgo,'nbExtrema', stream(1).nbExtrema,'maxIMF',stream(1).maxIMF-1);
    end
    stream(2).data(end+1:end+length(residualTail)) = residualTail;
    
    %Slide the window
    stream(1).windowTail = nextWindowTail;
    stream(1).windowHead = newWindowHead;
    %Remove the last extrema
    extrInd = extrInd(2:end);
    
end

%Recursive call for the next IMF
% 'recursion'
stream = [stream(1) oemd_iter(stream(2:end))];

end
