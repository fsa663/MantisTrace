function n = getIndex(material, lambda_um)
% n = getIndex('BK7', lambda_um)
% lambda_um: scalar or vector, in micrometers (µm)
D = materialsData();
%m = lower(material);
key = lower(strtrim(material));
key = regexprep(key,'[^a-z0-9]','');  % drop hyphens, spaces, etc.
switch key
    case {'bk7','nbk7'}
        key='bk7';
    case {'fusedsilica','silica','quartz'}
		key='fusedsilica';
    case {'lak10','nlak10'}
		key='laK10';
    case {'f2','nf2'}
        key='f2';
    case {'sf2','nsf2'}
        key='sf2';
    case {'sf5','nsf5'}
        key='sf5';
    case {'sf11','nsf11'}
        key='sf11';
    case {'caf2','calciumfluoride','cafluoride'}
        key='caF2';
    otherwise
        error('getIndex:UnknownMaterial', ...
        'Unknown material "%s". Allowed keys: BK7,F2,SF2,SF5,SF11,LaK10,FusedSilica,CaF2',material);
end

c = D.(key).sellmeier;                   % [B1 B2 B3 C1 C2 C3], C in µm^2
L2 = (lambda_um).^2;
n2 = 1 + c(1).*L2./(L2 - c(4)) + c(2).*L2./(L2 - c(5)) + c(3).*L2./(L2 - c(6));
n  = sqrt(n2);
end
