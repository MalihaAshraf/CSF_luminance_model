classdef MinkModel
    %MINKMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        function S_parab = modelfn_parab(obj, cc, ff)
            switch cc
                case 1
                    S_parab = (logparab(ff, obj.fmax_ach, obj.gmax_ach, obj.bw_ach, []));
                case 2
                    S_parab = (logparab(ff, obj.fmax_ch2, obj.gmax_ch2, obj.bw_ch2, obj.del_ch2));
                case 3
                    S_parab = (logparab(ff, obj.fmax_ch3, obj.gmax_ch3, obj.bw_ch3, obj.del_ch3));
            end
        end
        
        function S = modelfn(obj, p, out_col, ff)
           obj = obj.getParams('params', p);
           if exist('ff','var') && ~isempty(ff)
               freq = ff;
           else
               freq = obj.freqs;
            end

            switch out_col
                    case 1
                        S = obj.modelfn_parab(out_col, freq);
                    case 2
                        S_ach = 10.^(obj.modelfn_parab(1, freq)); 
                        S_ch = 10.^(obj.modelfn_parab(out_col, freq));
                        S = log10( ( (obj.alpha2.*S_ach).^obj.beta2 + (1.*S_ch).^obj.beta2 ).^(1/obj.beta2) );
%                         C_ach = (-1.*obj.modelfn_parab(1, freq)); 
%                         C_ch = (-1.*obj.modelfn_parab(out_col, freq));
%                         S = -1.*(( ( (log10(obj.alpha2) + C_ach).^-obj.beta2 + (1.*C_ch).^-obj.beta2 ).^(-1/obj.beta2)) );
                    case 2.5
                        S = obj.modelfn_parab(floor(out_col), freq);
                    case 3 
                        S_ach = 10.^(obj.modelfn_parab(1, freq)); 
                        S_ch = 10.^(obj.modelfn_parab(out_col, freq));
                        S = log10( ( (obj.alpha3.*S_ach).^obj.beta3 + (1.*S_ch).^obj.beta3 ).^(1/obj.beta3) );
%                         C_ach = (-1.*obj.modelfn_parab(1, freq)); 
%                         C_ch = (-1.*obj.modelfn_parab(out_col, freq));
%                         S = -1.*(( ( (log10(obj.alpha3) + C_ach).^-obj.beta3 + (1.*C_ch).^-obj.beta3 ).^(-1/obj.beta3)) );
                    case 3.5
                        S = obj.modelfn_parab(floor(out_col), freq);
            end

        end
        
        function obj = loadData(obj, S)
            if size(S,1) == 1
                l = 1;
            else l = obj.lum;
            end
                
            obj.S1 = S(l, :, 1);
            obj.S2 = S(l, :, 2);
            obj.S3 = S(l, :, 3);
        end
       
        function errfit = errfit_model(obj, cc, freq)
            if ~exist('freq', 'var')
                freq  = [];
            end
            S_fit = obj.modelfn(obj.par_fit, cc, freq);
            S_data = obj.(['S', num2str(cc)]);

            errfit = obj.errfit(S_data, S_fit);
        end
        
    end
end

