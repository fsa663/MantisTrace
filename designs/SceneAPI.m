classdef SceneAPI
    % Scene Builder for optical systems
    % Example:
    %   S = SceneAPI();
	  %  S.addSurface('sphericalSurface', ...
    %	'center',[16 0 0],  'axis',[-1 0 0], 'radius',250, 'aperture',125, ...
    %	'indexcenter',1.50, 'indexout',1.00, 'autoStop',true);
    %   S.addSensor('rectangular','size',[10 12],'distance',50);
    %   [E,Sensor] = S.build();


    %   S.addLens('planoConvex','diameter',25,'f',50,'material','BK7');
    %   S.addSpacer(5);
    properties
        Elements   % struct array of surfaces
        Sensor     % sensor struct
        Counter    % element counter
    end

    methods
        function obj = SceneAPI()
            obj.Elements = struct([]);
            obj.Sensor = struct();
            obj.Counter = 0;

			tmpl = struct( ...
			  'type','', 'center',[], 'axis',[], ...
			  'radius',[], 'aperture',[], ...
			  'indexcenter',[], 'indexout',[], 'autoStop',[], ...
			  'asphericParam',[], 'RSignConvention',[], ...
			  'isBoundary',[] );
			obj.Elements = tmpl([]);   % empty array with fixed field set
        end

        %--- Core low-level method ---
        function obj = addSurface(obj, type, varargin)
            % Append a surface with type-specific defaults; unit-agnostic; no normalization.

            t = lower((type));
            switch t
                case {"spherical","sphericalsurface","sphere"}
                    p = inputParser;
                    addParameter(p,'center',[0 0 0]);
                    addParameter(p,'axis',[1 0 0]);
                    addParameter(p,'radius',inf);          % Inf => plane
                    addParameter(p,'aperture',10);         % your meaning (diam/whatever) unchanged
                    addParameter(p,'indexcenter',1.0);
                    addParameter(p,'indexout',1.0);
                    addParameter(p,'autoStop',true);
                    parse(p,varargin{:}); prm = p.Results;

                    s = struct( ...
                        'type','sphericalSurface', ...
                        'center',prm.center, ...
                        'axis',prm.axis, ...
                        'radius',prm.radius, ...
                        'aperture',prm.aperture, ...
                        'indexcenter',prm.indexcenter, ...
                        'indexout',prm.indexout, ...
                        'autoStop',prm.autoStop);

                case {"asphere","aspherical","asphericalsurface"}
                    p = inputParser;
                    addParameter(p,'center',[0 0 0]);
                    addParameter(p,'axis',[1 0 0]);
                    addParameter(p,'radius',inf);          % vertex ROC
                    addParameter(p,'k',0);                 % conic
                    addParameter(p,'a',[]);                % even-order coeffs
                    addParameter(p,'signConv',1);
                    addParameter(p,'aperture',10);
                    addParameter(p,'indexcenter',1.0);
                    addParameter(p,'indexout',1.0);
                    addParameter(p,'autoStop',true);
                    parse(p,varargin{:}); prm = p.Results;

                    s = struct( ...
                        'type','Aspheric', ...
                        'center',prm.center, ...
                        'axis',prm.axis, ...
                        'radius',prm.radius, ...
                        'asphericParam',[prm.k prm.a], ...
                        'RSignConvention',prm.signConv, ...
                        'aperture',prm.aperture, ...
                        'indexcenter',prm.indexcenter, ...
                        'indexout',prm.indexout, ...
                        'autoStop',prm.autoStop);

                case {"circaper","aperture","aperturestop","stop","iris"}
                    p = inputParser;
                    addParameter(p,'center',[0 0 0]);
                    addParameter(p,'axis',[1 0 0]);
                    addParameter(p,'aperture',10);
                    parse(p,varargin{:}); prm = p.Results;

                    s = struct( ...
                        'type','circularAperture', ...
                        'center',prm.center, ...
                        'axis',prm.axis, ...
                        'aperture',prm.aperture);

                  case {"plane"}
                    p = inputParser;
                    addParameter(p,'center',[0 0 0]);
                    addParameter(p,'axis',[1 0 0]);
                    addParameter(p,'isBoundary',false);
                    parse(p,varargin{:}); prm = p.Results;

                    s = struct( ...
                        'type','plane', ...
                        'center',prm.center, ...
                        'axis',prm.axis, ...
                        'isBoundary',prm.isBoundary);

                  case {"disc","circularplanarsurface"}
                    p = inputParser;
                    addParameter(p,'center',[0 0 0]);
                    addParameter(p,'axis',[1 0 0]);
                    addParameter(p,'aperture',10);
					          addParameter(p,'indexcenter',1.0);
					          addParameter(p,'indexout',1.0);
                    parse(p,varargin{:}); prm = p.Results;

                    s = struct( ...
                        'type','circularPlanarSurface', ...
                        'center',prm.center, ...
                        'axis',prm.axis, ...
                        'aperture',prm.aperture, ...
						            'indexcenter',prm.indexcenter, ...
						            'indexout',prm.indexout);

                otherwise
                    error('addSurface: unknown type "%s".', type);
            end

            obj.Counter = obj.Counter + 1;
			% ensure s has all template fields
			tmpl = obj.Elements;    % already has the template field set
			fn = fieldnames(tmpl);  % same as fieldnames of  template
			for ii = 1:numel(fn)
				f = fn{ii};
				if ~isfield(s,f), s.(f) = [];
			end
end

            obj.Elements(obj.Counter) = s;
        end

        %% --- Higher-level API ---
        function obj = addLens(obj, shape, varargin)
            % Add a lens by type (planoConvex, biConvex, etc.)
            p = inputParser;
            addParameter(p,'diameter',25);
            addParameter(p,'f',50);
            addParameter(p,'material','BK7');
            addParameter(p,'thickness',2.0);
            addParameter(p,'axis',[1 0 0]);
            addParameter(p,'center',[0 0 0]);
            parse(p,varargin{:});
            prm = p.Results;

            n = getIndex(prm.material); % helper function
            d = prm.diameter;
            f = prm.f;
            t = prm.thickness;

            % Very naive radius estimate (replace with proper Lensmaker later)
            R = f*(n-1);

            switch lower(shape)
                case 'planoconvex'
                    obj = obj.addSurface('sphericalSurface','center',prm.center,'axis',-prm.axis,...
                                         'radius',R,'aperture',d,'n_in',1,'n_out',n);
                    obj = obj.addSurface('plane','center',prm.center+[t 0 0],'axis',prm.axis,...
                                         'radius',inf,'aperture',d,'n_in',n,'n_out',1);
                case 'biconvex'
                    obj = obj.addSurface('sphericalSurface','center',prm.center,'axis',-prm.axis,...
                                         'radius',R,'aperture',d,'n_in',1,'n_out',n);
                    obj = obj.addSurface('sphericalSurface','center',prm.center+[t 0 0],'axis',prm.axis,...
                                         'radius',R,'aperture',d,'n_in',n,'n_out',1);
                otherwise
                    error('Lens shape not implemented yet: %s', shape);
            end
        end

        %{
        function obj = addSpacer(obj, thickness)
            % Advance along +x axis (air gap)
            lastCenter = obj.Elements(end).center;
            obj.Elements(end).center = lastCenter + [thickness 0 0];
        end
        %}
        function obj = addSensor(obj, type, varargin)
            p = inputParser;
            addParameter(p,'size',[10 10]);
            addParameter(p,'distance',50);
            parse(p,varargin{:});
            prm = p.Results;

            last = obj.Elements(end);
            axis = last.axis;
            center = last.center + prm.distance*axis;

            switch lower(type)
                case {"rectangular","rectangle","rect"}
                    Sensor.Type = 'rectangular';
                    Sensor.SensLength1=prm.size(1);
                    Sensor.SensLength2=prm.size(2);
                case {"circular","circle"}
                     Sensor.Type = 'circular';
                    Sensor.radius=prm.size(1)/2;
            end
            Sensor.center = center;
            Sensor.axis = axis;
            Sensor.lastdistance=prm.distance;
            obj.Sensor = Sensor;
        end

        %% --- Export ---
        function [E,Sensor] = build(obj)
            E0 = obj.Elements;

			%pad with 6 empty surfaces, which will be populated later (stupid, i know!.. to match old structure)
			[~,k] = size(E0);
			E(6+1:6+k)=E0;

            Sensor = obj.Sensor;
        end
    end
end

%% --- Helper (very minimal material lib) ---
function n = getIndex(material)
    switch lower(material)
        case 'bk7',          n = 1.5168;
        case 'fusedsilica',  n = 1.4585;
        otherwise,           n = 1.5; % fallback
    end
end

