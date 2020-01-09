function S = logparab(f, fmax, gmax, bw, trun)

% LOGPARAB       log-parabola as an analytic form for describing CSF.
%
%   f:    1xm vector of frequencies
%   fmax: nx1 vector of peak frequencies 
%   gmax: nx1 vector of peak sensitivities
%   bw: nx1 vector of bandwidth
%
%   Return: 
%       S   Predicted sensitivities in log10 units.

% f should be a row vector
if ~isempty(trun)
    parab4 = true;
else
    parab4 = false;
    trun = NaN;
end

if size(f,2) < size(f,1)
    f = f';
end

% fmax,gmax, and bw should be column vectors
if size(fmax,1) < size(fmax,2)
    fmax = fmax';
end
if size(gmax,1) < size(gmax,2)
    gmax = gmax';
elseif isscalar(gmax)
    gmax = gmax*ones(size(fmax));
end


if size(bw,1) < size(bw,2)
    bw = bw';
elseif isscalar(bw)
    bw = bw*ones(size(fmax));
end
if size(trun,1) < size(trun,2)
    trun = trun';
elseif isscalar(trun)
    trun= trun*ones(size(fmax));
end

nfreq = numel(f);
nlum  = numel(fmax);

if ~isscalar(f)
    fmax = repmat(fmax,[1,nfreq]);
    gmax = repmat(gmax,[1,nfreq]);
    bw   = repmat(bw,[1,nfreq]);
    trun = repmat(trun,[1,nfreq]);
end

if ~isscalar(fmax)
    f = repmat(f, [nlum,1]);
end

b = log10(2.*bw);
k = log10(2);

S = (log10(f)-log10(fmax)) ./ (.5.*b);
S = log10(gmax)-k .* (S.^2);

if parab4
    S((f <= fmax) & (S <= (log10(gmax) - log10(trun))))... 
	= log10(gmax(1)) - log10(trun(1));
end

return
end