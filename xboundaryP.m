
%__________________________________________________________________     %
% Multi-objective Generalized Normal Distribution Optimization (MOGNDO) %
%          A Novel Algorithm for Multi-objective Problems               %
%                                                                       %
%                                                                       %
%                  Developed in MATLAB R2023a (MacOs)                   %
%                                                                       %
%                      Author and programmer                            %
%                ---------------------------------                      %
%                Nima Khodadadi (ʘ‿ʘ)   University of Miami             %
%                         SeyedAli Mirjalili                            %
%                             e-Mail                                    %
%                ---------------------------------                      %
%                      Nima.khodadadi@miami.edu                         %
%                                                                       %
%                                                                       %
%                            Homepage                                   %
%                ---------------------------------                      %
%                    https://nimakhodadadi.com                          %
%                                                                       %
%                                                                       %
%                                                                       %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %



function range = xboundaryP(name)

 
    
    switch name
      
        case {'P8'}% SRN
            range = zeros(2,2);
            range(1,1)  = -20;
            range(2,1)  = -20;
            range(1,2)  = 20; 
            range(2,2)  = 20; 
       
    end
end