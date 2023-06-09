classdef SocialSession < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        info
        path_maps
        probe_to_area
        
        lfp = []
        audio = []
        timestamps = []
        bouts = []
        
    end
    properties (Constant)
        FILE_TYPES = {'audio', 'lfp', 'multispikes' ,'sniff', 'timestamps', 'video'};
    end
    
    properties (Dependent)
       area_to_probe
    end
    methods
        function obj = SocialSession(tab_in)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
        obj.info = tab_in;
        obj.path_maps = tab_in;
        obj.probe_to_area = tab_in;
        end
        
        % Setters

        function set.info(obj,tab_in)
            %Save information about the session
            %   Detailed explanation goes here
            obj.info = tab_in;
        end

          
        function set.path_maps(obj,tab_in)
        %METHOD1 Summary of this method goes here
        %   Detailed explanation goes here
        
        keys = obj.FILE_TYPES;
        paths = repmat("", size(keys));
        % check exsistence of paths
        num_types = length(keys);
        for n = 1:num_types
            filetype = keys{n};
            file_path = tab_in{1,filetype};
%             disp(file_path)
            if ~(isempty(file_path) || file_path=="")
                if ~isfile(file_path)  
                    error('file %s does not exist', file_path)
                    
                else
                    paths(n) = file_path;
                end
                
            end
        end
        obj.path_maps = containers.Map(keys, paths);
        end
        
        
        function set.probe_to_area(obj,tab_in)
        %Load probe data
        %   Detailed explanation goes here
        arguments
           obj SocialSession
           tab_in table;
        end
        
        
        % load file
        loaded_file = obj.load_file_('timestamps','tab_in', tab_in);
        data = loaded_file.ElectrodeVsRegisteredAreasNum;
        obj.probe_to_area = containers.Map(data(:,1), data(:,2));
        end
        
        function load_lfp_data(obj)
            loaded_file = load_file_(obj, 'lfp');
            lfp_data = loaded_file.filteredDataLowSummary;
            obj.lfp = lfp_data;
        end
        
        function load_audio_data(obj)
            loaded_file = load_file_(obj, 'audio');
            obj.audio = loaded_file;
        end
        % Getters
        
        function ret = get.area_to_probe(obj)
            keys = obj.probe_to_area.keys;
            values = obj.probe_to_area.values;
            
            kType = 'double';
            vType = 'double';
            ret = containers.Map('KeyType',kType,'ValueType',vType);
            
            n_keys = numel(keys);
            for n = 1:n_keys
                k = keys(n);
                k = k{:};
                val = values(n);
                val = [val{:}];
               if ~ret.isKey(k)
                   ret(k) = val;
               else
                   ret(k) = [ret(k),val];
               end
            end
        end
        % Load files
        function loaded_file = load_file_(obj,file_type, options)
            arguments
               obj SocialSession
               file_type string
               options.tab_in table = obj.info;
               options.update_path string = ''; %if the folder name must be replaced %TODO
            end
            tab_in = options.tab_in;
            
            % get path
            try
                path_to_file = tab_in{1,file_type};
                
                % if the file is wav, load it using readaudio
                [~,~,fformat] = fileparts(path_to_file);
                if lower(fformat) == ".wav"
                    loaded_file = audioread(path_to_file);
                elseif lower(fformat) == ".mat"
                    loaded_file = matfile(path_to_file);
                else
                    error('Unknown file format, must be mat or wav')                        
                end
                 
                
            catch ME
                fprintf('Unable to load %s, make sure that it is in the input table\n', file_type);
                error(ME)
            end
            
        end
        
    end
end

