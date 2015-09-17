% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Read DART files with water columns
%       - INPUT: a .txt file with the water columns in the following
%       format: #YY  MM DD hh mm ss T   HEIGHT
%       - OUTPUT: 
%           tm: time in minutes from the begining of the file
%           elev: water column height
%           sthour: 
%           date: 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function [y,detided_signal,delta]=plot_signal_and_detide(dn,elev,degree)



[y,detided_signal,delta]=detide(dn,elev,degree);

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