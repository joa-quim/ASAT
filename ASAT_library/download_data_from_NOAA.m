% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Access NOAA data from DART buoys via FTP 
%
% Nota (portuguese): esta fun??o pretende automatizar o recurso ao site da
% NOAA para o download dos ficheiros DART (b?ias). Por isso, funciona de
% acordo com
% a pol?tica livre do servidor FTP da NOAA (NGDC mission of NOAA). Caso esta pol?tica mude,
% esta fun??o deixar? de funcionar e dever?o ser acrescidas as respectivas
% credenciais de acesso.
% 
%
%       - INPUT: protocol, either html or ftp
%       - OUTPUT: txt file containing relevant data
%          
% For guidelines: http://www.mathworks.com/help/matlab/ref/ftp-class.html
% 
% for using the mget: http://www.mathworks.com/help/matlab/ref/ftp.mget.html
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function [DARTname]=download_data_from_NOAA(datatype,buoy_id,yyyy_historical)

switch datatype
     case 'realtime'
        % Through HTML protocol
        % EXAMPLE: http://www.ndbc.noaa.gov/data/realtime2/21418.dart
        %buoy_id=num2str(21346);
        buoy_filename=['http://www.ndbc.noaa.gov/data/realtime2/',buoy_id,'.dart'];
        DART_file=['DART_',buoy_id,'.txt'];
        urlwrite(buoy_filename,DART_file);
        remove_header(DART_file);
        display('I have downloaded data from NOAA through HTML containing the column height measurements of DART buoys.')
        if isdeployed
            DARTname=DART_file;
        else
            DARTname=which(DART_file);
        end
    
    case 'historical'
        if isempty(yyyy_historical) == 1
            disp('Please provide historical year.')
        end
        % Through HTML protocol
        % EXAMPLE: http://www.ndbc.noaa.gov/data/historical/dart/
        % buoy_id=num2str(21346);
        disp('Using data from historical year of: ');
        yyyy_historical
        buoy_filename=['http://www.ndbc.noaa.gov/data/historical/dart/',buoy_id,'t',num2str(yyyy_historical),'.txt.gz'];
        DART_file=['DART_',buoy_id,'.txt.gz'];
        
        display('I have downloaded data from NOAA through HTML containing the column height measurements of DART buoys.')
        
        try
            urlwrite(buoy_filename,DART_file);   % URL get .txt.gz file
        catch ME
            msgbox('Data for this buoy is not available on the NOAA site.');
            return;
        end
        gunzip(DART_file);                   % decompress DART file
        DART_file=['DART_',buoy_id,'.txt'];
        remove_header(DART_file);
        if isdeployed
            DARTname=DART_file;
        else
            DARTname=which(DART_file);
        end
        
        %if yyyy_start ~= yyyy_stop
        %buoy_filename2=['http://www.ndbc.noaa.gov/data/historical/dart/',buoy_id,'t',num2str(yyyy_stop),'.dart'];
        %DART_file2=['downloaded/DART_',buoy_id,'.txt'];
        %urlwrite(buoy_filename,DART_file2);
        %system('cat 1.txt 2.txt 3.txt >> MyBigFat.txt') % Merge files from different years
        %end
end
end


%    case 'ftp'
% Through FTP Protocol
%ftp_NOAA = ftp('ftp.ngdc.noaa.gov'); % Object created for FTP access
%dir(ftp_NOAA,'hazards/dart'); % lists all the files present in the dart folder
%cd(ftp_NOAA,'hazards/dart');  % changes to the folder DART 
%filename_to_get='wc9*d.dat.zip';
%mget(ftp_NOAA,filename_to_get);
%display('I have downloaded data from NOAA through FTP containing the column height measurements of DART buoys.')
%unzip(filename_to_get,'unzipped.txt');
%close(ftp_NOAA)
