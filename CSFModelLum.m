classdef CSFModelLum < CSFModels & MinkModel
    %MINKMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modelfn_ach, errfn_ach % model and error funcs for achromatic channel
        modelfn_ch, errfn_ch % model and error funcs for chromatic channel
        
        S1, S2, S3 % sensitivity data for the three colour channels
%         S_data % sensitivity data to optimize
        %col % channel to optimize; C1, C2, or C3
        
        % fitting parameters  
        opt_param_array % values of parameters to optimize
        gmax_ach, fmax_ach, bw_ach % Achromatic parabola parameters only  
        gmax_ch2, fmax_ch2, bw_ch2 % Chromatic parabola parameters; C2
        gmax_ch3, fmax_ch3, bw_ch3 % Chromatic parabola parameters; C3
        alpha2, beta2 % Minkowski summation param; C2 
        alpha3, beta3 % Minkowski summation param; C3
        del_ch2, del_ch3 % truncation parameters for C2 and C3
        s_max, k
        
        logflag, parabflag
        lb, ub
        par_fit, errval;
    end
    
    methods
        function obj = CSFModelLum( logflag, logparab_mode)
            %MINKMODEL Construct an instance of this class
            %   Detailed explanation goes here
%             obj.col = color_dir;

            obj.logflag = logflag;  
            if exist('logparab_mode', 'var')
                obj.parabflag = logparab_mode;
            else
                obj.parabflag = 3;
            end
        end
        
        function obj = initParams(obj, lum)
           
           load ('params/param_models.mat');
           if ~exist('lum', 'var')
               llum = log10(obj.lums(obj.lum));
           else
               llum = log10(lum);
           end
           
           obj.gmax_ach = 10.^feval(gmax_ach, llum);
           obj.gmax_ch2 = 10.^feval(gmax_ch2, llum);
           obj.gmax_ch3 = 10.^feval(gmax_ch3, llum);
           
           obj.fmax_ach = feval(fmax_ach, llum);
           obj.fmax_ch2 = feval(fmax_ch2, llum);
           obj.fmax_ch3 = feval(fmax_ch3, llum);
           
           obj.bw_ach = feval(bw_ach, llum);
           obj.bw_ch2 = feval(bw_ch2, llum);
           obj.bw_ch3 = feval(bw_ch3, llum);
           
           if obj.parabflag == 4
               obj.del_ch2 = 1;
               obj.del_ch3 = 1;
           else
               obj.del_ch2 = [];
               obj.del_ch3 = [];
           end
           
           obj.alpha2 = 1./feval(alpha2, llum);
           obj.alpha3 = 1./feval(alpha3, llum);
           
           obj.beta2 = 3.5;
           obj.beta3 = 3.5;
           
        end
        
        function S = csf(obj, col, freq, lum, area)
            obj = obj.initParams(lum);
            if exist('area', 'var') && ~isempty(area)
                reflumobj = CSFModelLum(true, obj.parabflag);
                reflumobj = reflumobj.initParams(20);
                offset = obj.modelfn([], col, freq) - reflumobj.modelfn([], col, freq);
                load ('param_models.mat');
                obj.s_max = feval(eval(['smax_ch', num2str(col)]), (freq))';
                obj.k = feval(eval(['k_ch', num2str(col)]), (freq))';
                areaf = area.*(freq.^2);
                S = mm_equation([obj.s_max; obj.k],... 
                    areaf) + offset;
            else
               S = obj.modelfn([], col, freq); 
            end
        end
        
        function S = csf2(obj, col, freq, lum, area)
            obj = obj.initParams(lum);
            if exist('area', 'var') && ~isempty(area)
                reflumobj = CSFModelLum(true, obj.parabflag);
                reflumobj = reflumobj.initParams(20);
                load('params/pars_fit_area');
                S_a = csf_freq_size( freq, area, col, pars_fit{col} );
                offset = obj.modelfn([], col, freq) - reflumobj.modelfn([], col, freq);
                
                S = log10(S_a) + offset;
%                 S = log10(csf_freq_size(10.^S_max, freq, area, col)) ;
            else
               S = obj.modelfn([], col, freq); 
            end
        end
    end
end

