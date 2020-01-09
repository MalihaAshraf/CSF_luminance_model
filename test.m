%% Using CSF model
% 1. Initialize CSFModelLum class 
%       e.g. csfobj = CSFModelLum(logflag, parabola_mode);
%     logflag:  true or false
%               Contrast sensitivity in log or decimal scale
%       parabola_mode:  3 (default), 4
%                       Indicator if parabola function takes 3 or 4 parameters

csfobj = CSFModelLum(true, 4);

%% Input
% Specifying mean background luminance levels
% lum: 1xn vector of luminance values

lum = [0.1, 10, 1000]; 
csfobj = csfobj.initParams(lum);

%% Color direction and spatial frequencies
% cc:   1, 2, or 3 (Achromatic, Red-Green, Yellow-Violet)
% ff:   1xm vector of spatial frequencies in cycles per visual degrees
% S:    nxm vector of contrast sensitity values for specified color
% direction

cc = 1;
ff = [0.5, 2, 4, 10, 30];
S = csfobj.csf2(cc, ff, lum);
