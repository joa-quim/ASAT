% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Remove the Header (first two lines of input file) if it exists
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function remove_header(DART_file)
 fid = fopen(DART_file, 'r') ;              % Open source file.
 line1=fgetl(fid) ;                                  % Read/discard line.
 line2=fgetl(fid) ;                                  % Read/discard line.

 test=str2num(line1);
 
if isempty(test)==1
 buffer = fread(fid, Inf) ;                    % Read rest of the file.
 fclose(fid);
 fid = fopen(DART_file, 'w')  ;   % Open destination file.
 fwrite(fid, buffer) ;                         % Save to file.
end
 fclose(fid) ;
end