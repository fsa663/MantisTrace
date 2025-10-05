function D = materialsData()
% Minimal set of optical glasses (Sellmeier, λ in µm)

% --- Crowns (low dispersion, high Abbe) ---
D.bk7.sellmeier = [1.03961212, 0.231792344, 1.01046945, 0.00600069867, 0.0200179144, 103.560653 ];
D.fusedsilica.sellmeier = [ 0.6961663, 0.4079426, 0.8974794, 0.00467914826, 0.0135120631, 97.9340025 ];
D.sf2.sellmeier = [ 1.47343127, 0.163681849, 1.36920899, 0.008318, 0.011609, 95.0 ];  % Schott SF2

% --- Flints (high dispersion, low Abbe) ---
D.sf11.sellmeier = [ 1.73759695, 0.313747346, 1.89878101, 0.013188707, 0.0623068142, 155.23629 ];
D.laK10.sellmeier = [ 1.64641849, 0.28652087, 1.33098044, 0.0103211072, 0.0362509248, 113.246968 ]; % Schott LaK10
D.f2.sellmeier = [ 1.34533359, 0.209073176, 0.937357162, 0.00997743871, 0.0470450767, 111.886764 ]; % Schott F2

% --- Exotic / specialty ---
D.sf5.sellmeier = [ 1.52481889, 0.187085527, 1.42729015, 0.0127534559, 0.01864608, 116.60768 ]; % dense flint
D.caF2.sellmeier = [ 0.5675888, 0.4710914, 3.8484723, 0.050263605, 0.1003909, 34.649040 ];  % Calcium Fluoride (UV–IR)
end
