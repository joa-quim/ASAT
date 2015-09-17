% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: To provide the best fitting with non-Chebyshev polinomials. DAta
% is fitted with least squares method (CONFIRM). 
%       - INPUT:  
%               dn: date number vector 
%               elev: water column height
%               
%      
%       - OUTPUT: 
%           y_best_fit: the fitted polinomial evaluated for the time series
%           best_fit_detided: the input signal without the tide.
%           the errors for the polinomial fitting. 
%           best_fit_delta: COMPLETE HERE AND COMPLETE IN plot_signal_and_best_detide!!!
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


function [y_best_fit,best_fit_detided,best_fit_delta]=best_fit(dn,elev)

degree=5;
delta=1;
broken_loop=0; 

lastwarn('');

while delta>0.011  % error is generally within 1.1%

[y_best_fit,best_fit_detided,best_fit_delta]=detide(dn,elev,degree);
delta=mean(best_fit_delta);

[last,last_id]=lastwarn;

if isempty(last)==0 && strcmp(last_id(8:14),'polyfit') ==1 %#ok<STCMP> % This is to avoid the absence of convergence 
    broken_loop=1;
    break
end

degree=degree+1;

end


if broken_loop==1   % This is to avoid the absence of convergence 
    disp('The loop was broken the polynomial used is of degree: ');
   [y_best_fit,best_fit_detided,best_fit_delta]=detide(dn,elev,degree-1);
end


disp('The best polynomial fitted to this data was of degree: ');
disp(degree-broken_loop);

end