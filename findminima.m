function minima = findminima(x)
%FINDMINIMA  Find location of local minima
%  From David Sampson
%  See also FINDMAXIMA

minima = findmaxima(-x);
