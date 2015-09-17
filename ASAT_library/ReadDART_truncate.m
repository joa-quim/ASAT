% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Read DART files with water columns
% The series will be truncated according to the selected time-period
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

function [ts,dn,a, elev,sthour,date]=ReadDART_truncate(DARTname,tlower,tupper)

fid=fopen(DARTname,'r');  % Open file assigning fid
    if fid == -1 % Ver se o ficheiro abriu correctamente
        msgbox('Error opening file. Are you sure this selection makes sense? Obrigado!')
%        close(h_progresso);
        return  
    end
a=fscanf(fid,'%d %d %d %d %d %g %d %g',[8,inf]); 
a=a';
fclose(fid);



%tlower = datenum([2008  03  18  11  45  00]);
%tupper = datenum([2008  03  18  11  47  00]);
t = datenum([a(:,1) a(:,2) a(:,3) a(:,4) a(:,5) a(:,6)]);

% Sort time series
[t,indx]=sort(t);
a_tmp=a(indx,:);
a=a_tmp;
% End of Sorting


[ai aj]=size(a);
for i=ai:-1:1
    if isnumeric(a(i,8)) == 0
        a(i,:)=[];
    end
end

[ai aj]=size(a);



    for i=ai:-1:1
    if t(i) > tupper
        a(i,:)=[];
    end
    end
    
    [ai aj]=size(a);
    
    for i=ai:-1:1
    if t(i) < tlower
        a(i,:)=[];
    end
    end




[ai aj]=size(a);
for i=ai:-1:1
    if a(i,8)>9500
        a(i,:)=[];
    end
end

[ai aj]=size(a);
sampling_label=a(i,7);
    if isempty(a) == 1
        msgbox('There is no data for this selection. Verify Station Id and/or date selection. Obrigado!')
%        close(h_progresso);
        return
    end
sthour=a(1,4);
date=[int2str(a(1,2)),'/',int2str(a(1,3)),'/',int2str(a(1,1))];

year1=a(ai,1);

tm(1:ai)=0;

for i=1:ai

    jj=ai+1-i;
    year=a(jj,1);
    mnth=a(jj,2);
    days=a(jj,3)-1;
   
    if mnth>1
        for j=1:(mnth-1)
    
            switch j
                case 1
                    aa=31;
                case 2
                    if rem(year,400)==0
                      %  disp('is leap year - code: 1')
                        aa=29;
                    elseif rem(year,100)==0    
                      %  disp('is not a leap year - code: 2')
                        aa=28;
                    elseif rem(year,4)==0 
                      %  disp('is a leap year - code: 3')
                        aa=29;
                    else
                      %  disp('is not a leap year - code: 4')
                        aa=28;
                    end
                case 3
                    aa=31;
                case 4
                    aa=30;
                case 5
                    aa=31;
                case 6
                    aa=30;
                case 7
                    aa=31;
                case 8
                    aa=31;
                case 9
                    aa=30;
                case 10
                    aa=31;
                case 11
                    aa=30;
                otherwise
                    'What ???'
            end
            
            days=days+aa;  % days passed from the start of the year
        end  % for j 
    end  % if
    
    if year ~= year1    % Verificar se o ano ? bissexto 
         if rem(year1,400)==0
                        t0=24.*4.*366;
         elseif rem(year1,100)==0    
                        t0=24.*4.*365;
         elseif rem(year1,4)==0 
                        t0=24.*4.*366; 
         else
                        t0=24.*4.*365;
         end
        
        year1=year;
        tm=tm-t0;
    end

    tm(i)=24.*4.*days+4.*a(jj,4)+a(jj,5)/15.+a(jj,6)/60./15.;

end   % for i
dn=datenum([a(ai:-1:1,1),a(ai:-1:1,2),a(ai:-1:1,3),a(ai:-1:1,4),a(ai:-1:1,5),a(ai:-1:1,6)])'; % date num
elev(1:ai)=a(ai:-1:1,8);   % elevation water column



dn=fliplr(dn); % To put it in correct order [start:stop]
elev=fliplr(elev); % To put it in correct order [start:stop]

ts = timeseries(elev',dn,'Name','RawDataElev');
ts.TimeInfo.Units = 'days';
ts.TimeInfo.Format = 'datenum';
ts.DataInfo.Units = 'm';
return
end
