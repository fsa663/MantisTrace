function mode = checkIndexHomogeneity(E)
% mode = 'numeric' | 'string' | 'none'
% Errors if significant (non-1) indices mix strings and numbers.

hasNum = false; hasStr = false;

for i = 1:numel(E)
    vals = {E(i).indexcenter, E(i).indexout};
    for v = vals
        x = v{1};
        if isSignificant(x)
            if isnumeric(x), hasNum = true; end
            if ischar(x) || isstring(x), hasStr = true; end
        end
    end
end

if hasNum && hasStr
    % Find offenders for a helpful message
    offenders = [];
    for i = 1:numel(E)
        if isSignificant(E(i).indexcenter) && isSignificant(E(i).indexout)
            if (isnumeric(E(i).indexcenter) && (ischar(E(i).indexout)||isstring(E(i).indexout))) || ...
               ((ischar(E(i).indexcenter)||isstring(E(i).indexcenter)) && isnumeric(E(i).indexout))
                offenders(end+1) = i; %#ok<AGROW>
            end
        end
    end
    error('Mixed index modes detected: some significant indices are numeric and some are strings. Offending elements (examples): %s', mat2str(offenders(1:min(end,5))));
end

if hasNum,   mode = 'numeric';
elseif hasStr, mode = 'string';
else         mode = 'none';   % all defaults (==1)
end
end

% --- helpers ---
function tf = isSignificant(x)
% True if x represents an index other than 1 (numeric 1 or string "1" are non-significant)
if isnumeric(x)
    tf = isfinite(x) && (x ~= 1);
elseif ischar(x) || isstring(x)
    s = strtrim(char(x));
    tf = ~(strcmpi(s,'1') || strcmpi(s,'1.0'));
else
    tf = false; % treat empty/missing as non-significant
end
end
