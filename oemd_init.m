function stage = oemd_init(emdAlgo)

%TODO set default values


nbRealisation = 0;
%Initialize the noise
if nbRealisation > 1
    for i=1:nbRealisation
        noise{i}=randn(1,noiseLength); %creates the white noise 
    end;
    minNbImf = 1000;
    for i=1:nbRealisation
        noiseEmd{i}=emdc([],noise{i}); %calculates the modes of the white noise
        minNbImf=min(size(noiseEmd{i},1),minNbImf);
    end;
    for j = 1:nbRealisation
            noise{j} = noiseLevel*noise{j};
    end
    for i=1:minNbImf
        for j = 1:nbRealisation
            noiseImf{i,j} = noiseEmd{j}(i,:)/std(noiseEmd{j}(i,:));
            noiseImf{i,j} = noiseLevel*noiseImf{i,j};
        end
    end
    

    %Initialize the structure to store the IMFs and residuals
    stage = struct('data',[],'imf',[],'windowTail',1,'windowHead',1,'noise',{noise(:)}, 'nbRealisation', nbRealisation, 'weights', [], 'emdAlgo', 0);
    for i=1:minNbImf
        stage(i+1) = struct('data',[],'imf',[],'windowTail',1,'windowHead',1,'noise',{noiseImf(i,:)}, 'nbRealisation', nbRealisation, 'weights', [], 'emdAlgo', 0);
    end
    
else
   stage = struct('data',[],'imf',[],'windowTail',1,'windowHead',1, 'weights', [], 'emdAlgo', emdAlgo);
    
end

