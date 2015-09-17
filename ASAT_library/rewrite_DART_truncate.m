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

function [a]=rewrite_DART_truncate(DARTname, tlower,tupper)

fid=fopen(DARTname,'r');  % Open file assigning fid
a=fscanf(fid,'%d %d %d %d %d %d %d %g',[8,inf]); 
a=a';
fclose(fid);

%tlower = datenum([2008  03  18  11  45  00]);
%tupper = datenum([2008  03  18  11  47  00]);
t = datenum([a(:,1) a(:,2) a(:,3) a(:,4) a(:,5) a(:,6)]);

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


fidID = fopen('DARTfile_tmp.txt', 'wt') ;   % Open destination file.

[ai aj]=size(a);

for i=ai:-1:1
    fprintf(fidID,'%d %d %d %d %d %d %d %g \n',a') ; % fwrite(fid, a ) ;                         % Save to file.
end

fclose(fidID) ;

end
