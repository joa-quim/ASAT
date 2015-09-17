% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Do the same as best detide. i.e., find the best possible
% non-Chebishev polynomial fit and optionally plot the results. It is best
% to always provide a string either 'plot' or 'noplot'
%       - INPUT:  
%               dn: date number vector 
%               elev: water column height
%               varargin: optionally provide a string 'plot' to plot the
%               result from the best fit
%      
%       - OUTPUT: 
%           y: the fitted polinomial evaluated for the time series
%           detided_signal: the input signal without the tide.
%           the errors for the polinomial fitting. 
%           delta: COMPLETE HERE!!!
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function [y,detided_signal,delta]=plot_signal_and_best_detide(dn,elev,varargin)



[y,detided_signal,delta]=best_fit(dn,elev);

if exist('varargin{1}','var')==1 && strcmp(varargin{1},'plot')==1
    
figure

% Detided Signal Subplot
title('Detided Signal');
subplot(2,1,1)
plot(dn,detided_signal);
set_label_date(dn)
ylabel('detided elev. (m)')
xlabel('Time (hours)')
grid on
% Signal and Polynomial Subplot
subplot(2,1,2)
plot(dn,elev);
hold on
title('Signal and fitting');
plot(dn, y,'red');
set_label_date(dn);
ylabel('elev. (m)');
xlabel('Time (hours)');
grid on

end

end