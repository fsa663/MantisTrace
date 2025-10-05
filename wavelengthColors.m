function [rgb, lineStyle, labels] = wavelengthColors(lambda_nm)
% wavelengthColors Map wavelengths (nm) to RGB colors, styles, and labels.
% INPUT:
%   lambda_nm : vector of wavelengths in nanometers
% OUTPUT:
%   rgb       : Nx3 RGB in [0,1]
%   lineStyle : 1xN cell array of line styles {'-','--',':','-.'}
%   labels    : 1xN cell array like {'486 nm','587.6 nm','850 nm (NIR)'}
%
% Visible (≈380–700 nm): spectral colors.
% UV (<380): purple family, styled.
% NIR/SWIR (>=700): deep reds/browns/greys, styled.

lambda_nm = lambda_nm(:)';                   % row vector
N = numel(lambda_nm);
rgb = zeros(N,3);
lineStyle = repmat({'-'},1,N);
labels = cell(1,N);

% Style cycle for non-visible bands
styleCycle = {'-','--',':','-.'};

for i = 1:N
    L = lambda_nm(i);
    if L >= 380 && L <= 700
        rgb(i,:) = visRGB(L);                % spectral color
        lineStyle{i} = '-';
        labels{i} = sprintf('%.4g nm', L);
    elseif L < 380
        % UV — purple family, styled
        uvIdx = sum(lambda_nm < 380 & (1:numel(lambda_nm)) <= i);
        lineStyle{i} = styleCycle{mod(uvIdx-1,numel(styleCycle))+1};
        rgb(i,:) = [0.6, 0.3, 0.8];          % violet
        labels{i} = sprintf('%.4g nm (UV)', L);
    else
        % IR — tiers: 700–1000 (NIR), 1000–1700 (SWIR), >1700 (LWIR-ish)
        irMask = lambda_nm >= 700;
        irIdx = sum(irMask & (1:numel(lambda_nm)) <= i);
        lineStyle{i} = styleCycle{mod(irIdx-1,numel(styleCycle))+1};
        if L < 1000
            rgb(i,:) = [0.75, 0.1, 0.1];     % deep red (NIR)
            band = 'NIR';
        elseif L < 1700
            rgb(i,:) = [0.55, 0.25, 0.10];   % brown (SWIR)
            band = 'SWIR';
        else
            rgb(i,:) = [0.35, 0.35, 0.35];   % dark gray (longer IR)
            band = 'IR';
        end
        labels{i} = sprintf('%.4g nm (%s)', L, band);
    end
end

end

% --- Helper: approximate spectral RGB for visible wavelengths (380–700 nm)
function rgb = visRGB(L)
% Based on a common approximation (similar to Dan Bruton's mapping).
% Input L in nm; output RGB in [0,1].
if L < 380 || L > 700
    rgb = [0,0,0]; return;
end

if L < 440
    t = (L-380)/(440-380); R = -(t); G = 0; B = 1;
elseif L < 490
    t = (L-440)/(490-440); R = 0; G = t; B = 1;
elseif L < 510
    t = (L-490)/(510-490); R = 0; G = 1; B = 1-t;
elseif L < 580
    t = (L-510)/(580-510); R = t; G = 1; B = 0;
elseif L < 645
    t = (L-580)/(645-580); R = 1; G = 1-t; B = 0;
else
    R = 1; G = 0; B = 0;
end

% Intensity correction near edges of vision
if L < 420
    alpha = 0.3 + 0.7*(L-380)/(420-380);
elseif L > 645
    alpha = 0.3 + 0.7*(700-L)/(700-645);
else
    alpha = 1.0;
end

% Gamma correction
gamma = 0.8;
rgb = [R,G,B] * alpha;
rgb = rgb .^ gamma;
rgb = max(0,min(1,rgb));
end
