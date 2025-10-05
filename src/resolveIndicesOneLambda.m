function E_num = resolveIndicesOneLambda(E, lambda_um)
% resolveIndicesOneLambda  Convert string indices to numeric at one wavelength.
% - E: struct array with fields indexcenter, indexout (each numeric or string)
% - lambda_um: scalar wavelength in micrometers
% Returns E_num with numeric indexcenter/indexout everywhere.

E_num = E;  % copy

for i = 1:numel(E)
    % center side
    E_num(i).indexcenter = resolveOne(E(i).indexcenter, lambda_um);
    % outer side
    E_num(i).indexout    = resolveOne(E(i).indexout,    lambda_um);
end

end

% --- helpers ---
function n = resolveOne(val, lambda_um)
    if isnumeric(val)
        n = val;
        return;
    end
    if ischar(val) || isstring(val)
        key = strtrim(lower(char(val)));
        % trivial pass-throughs
        if strcmp(key,'1') || strcmp(key,'1.0') || strcmp(key,'air')
            n = 1.0;
            return;
        end
        % material lookup (expects getIndex(material, lambda_um))
        n = getIndex(key, lambda_um);
        return;
    end
    error('resolveIndicesOneLambda:UnsupportedType', ...
          'Index value must be numeric or string (got %s).', class(val));
end
