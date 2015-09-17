% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Truncate data already present in the workspace according to a
% certain time period. This is different from the preselection of data with
% the GUI LoadDATA.fig it serves as another data selection for the FFT,
% which needs to select a shortes time-span since spectral analysis of
% Tsunami frequencies can be affected if the timeseries is long enough.
% Even in the open ocean the presence of islands and low bathymetry can
% polute the specific-tsunami frequencies. 
% The series will be truncated according to the selected time-period.
%       - INPUT: the array a and two times in date number tlower for the
%       starting time and tupper for the end time
%       - OUTPUT: 
%           dn: A serial date number represents the whole and fractional 
%               number of days from a fixed, preset date (January 0, 0000).
%           tm: time in minutes from the begining of the file (will be decommissioned in the algorithm)
%           elev: water column height
%           sthour: initial hour of the series
%           date: initial date of the series
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


function [ts2]=truncate_ts(ts1,a_yyyy,a_mm,a_dd,a_hh,a_mn,a_ss,b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss)
tlower = datenum([a_yyyy  a_mm  a_dd  a_hh  a_mn  a_ss]);
tupper = datenum([b_yyyy  b_mm  b_dd  b_hh  b_mn  b_ss]);
%t = datenum([a(:,1) a(:,2) a(:,3) a(:,4) a(:,5) a(:,6)]);
elev=ts1.data;
t=ts1.time;


for i=length(t):-1:1
  if t(i)>tupper
        elev(i)=[];
        t(i)=[];
  end
end

for i=length(t):-1:1
  if t(i)<tlower
        elev(i)=[];
        t(i)=[];
  end
end





ts2 = timeseries(elev,t);

end