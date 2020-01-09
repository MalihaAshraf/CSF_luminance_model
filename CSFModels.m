classdef CSFModels
    %CSFMODELS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        function obj = getParams(obj, mode, pars)
            
            if exist( 'pars', 'var' ) && ~isempty(pars)
                for kk=1:length(obj.to_optimize)
                    if obj.logflag
                        obj.(obj.to_optimize{kk}) = 10.^pars(kk);
                    else
                        obj.(obj.to_optimize{kk}) = pars(kk);
                    end
                end
            end
            
            switch mode
                case 'X0'
                    % returns log10 values of params to optimize
                    obj.opt_param_array = zeros( length(obj.to_optimize), 1 );
                    for kk=1:length(obj.to_optimize)
                        obj.opt_param_array(kk) = obj.(obj.to_optimize{kk});            
                    end
                    if obj.logflag
                        obj.opt_param_array = log10(obj.opt_param_array);
                    end
                case 'params'
                    % Do nothing return optimization params as powers of 10
                otherwise 
                    error( 'Unknown mode' );
            end
        end
        
        function obj = updateParams(obj, pars)
            if ~exist('pars', 'var')
                pars = obj.par_fit;
            end
            
            for kk=1:length(obj.to_optimize)
                    if obj.logflag
                        obj.(obj.to_optimize{kk}) = 10.^pars(kk);
                    else
                        obj.(obj.to_optimize{kk}) = pars(kk);
                    end
            end
        end
        
        function err = errfit(obj, S_data, S_fit)
           err = sqrt(nansum((S_data - S_fit).^2)); 
        end
    end
end

