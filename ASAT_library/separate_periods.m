% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Read DART files with water columns
%       - INPUT: a .txt file with the water columns in the following
%       format: #YY  MM DD hh mm ss T   HEIGHT
%       - OUTPUT: 
%           dn: A serial date number represents the whole and fractional 
%               number of days from a fixed, preset date (January 0, 0000).
%           tm: time in minutes from the begining of the file (em desuso)
%           elev: water column height
%           sthour: initial hour of the series
%           date: initial date of the series
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


function [dn_15min, elev_15min, dn_1min, elev_1min, dn_15sec, elev_15sec]=separate_periods(a)


[ai aj]=size(a);

dn_15min=ones(1,ai);
dn_15sec=ones(1,ai);
dn_1min=ones(1,ai);

elev_15min=ones(1,ai);
elev_1min=ones(1,ai);
elev_15sec=ones(1,ai);

for i=ai:-1:1
    switch a(i,7)
        case 1
            dn_15min(i)=datenum([a(i,1),a(i,2),a(i,3),a(i,4),a(i,5),a(i,6)])'; % date num
            elev_15min(i)=a(i,8);   % elevation water column
            %
            dn_1min(i)=[];
            elev_1min(i)=[];
            %
            dn_15sec(i)=[];
            elev_15sec(i)=[];
        case 2
            dn_1min(i)=datenum([a(i,1),a(i,2),a(i,3),a(i,4),a(i,5),a(i,6)])'; % date num
            elev_1min(i)=a(i,8);   % elevation water column 
            %
            dn_15min(i)=[];
            elev_15min(i)=[];
            %
            dn_15sec(i)=[];
            elev_15sec(i)=[];
        case 3
            dn_15sec(i)=datenum([a(i,1),a(i,2),a(i,3),a(i,4),a(i,5),a(i,6)])'; % date num
            elev_15sec(i)=a(i,8);   % elevation water column
            %
            dn_1min(i)=[];
            elev_1min(i)=[];
            %
            dn_15min(i)=[];
            elev_15min(i)=[];
    end
  
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % dn_15min=fliplr(dn_15min); % To put it in correct order [start:stop]
       % elev_15min=fliplr(elev_15min); % To put it in correct order [start:stop]
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % dn_1min=fliplr(dn_1min); % To put it in correct order [start:stop]
       % elev_1min=fliplr(elev_1min); % To put it in correct order [start:stop]
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % dn_15sec=fliplr(dn_15sec); % To put it in correct order [start:stop]
       % elev_15sec=fliplr(elev_15sec); % To put it in correct order [start:stop]

end
