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
function [y,detided_signal,delta]=detide(dn,elev,degree)
[p,S_error]=polyfit(dn-dn(1),elev,degree);
[y,delta]=polyval(p,dn-dn(1),S_error);
detided_signal=elev-y;
end