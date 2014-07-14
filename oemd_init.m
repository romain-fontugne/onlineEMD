function stage = oemd_init(maxIMF,nbExtrema,emdAlgo)

%TODO set default values

% emdAlgo permits to select the EMD algorithm used to extract the fastest
% oscilation:
%  0 means Rilling stopping criteria (C code)
%  1 means fixed number of siftings (10 Siftings) (C code)
%  2 means confidence limit stopping criteria, S=4 (Matlab code)


stage = struct('data',[],'imf',[],'windowTail',1,'windowHead',1, 'weights', [], 'emdAlgo', emdAlgo,'nbExtrema', nbExtrema,'maxIMF',maxIMF);

end

