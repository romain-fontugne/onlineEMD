function [w] = normalWeight(sd, dataLength, lastExtrema)

w = 1/(sd*sqrt(2*pi))*exp(-1/2*(((1/dataLength)+(lastExtrema-1):1/dataLength:lastExtrema)/sd).^2);
