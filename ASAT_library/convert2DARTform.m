function convert2DARTform(pathfilename,datenum_zero, time_unit)

[pathstr,name,ext] = fileparts(pathfilename);

Data = dlmread(pathfilename);

check_size=size(Data);

if check_size(2) ~= 2
    msgbox('ERROR: The input file is not a two-column file. The first column should be for time-array and Second column for data. Filipe');
    return;
end
%fclose(fid);
%tss=timeseries(Data(:,2),Data(:,1));
%tss=timeseries(Data(:));
% In the next line insert the date of the Earthquake/event
%date_num=datenum([1969 02 28 02 40 00])+tss.Time/24.;
%date_num=datenum([1941 11 26 00 00 00])+tss.Time/24.;
time_array=Data(:,1);
data_array=Data(:,2);

switch time_unit
    case 'years'
        date_num=datenum_zero+time_array*365.25;
    case 'days'
        date_num=datenum_zero+time_array;%date_num=datenum_zero+time_stamp_step*tss.Time/24./60.;
    case 'hours'
        date_num=datenum_zero+time_array/24.;
    case 'minutes'
        date_num=datenum_zero+time_array/24./60.;
    case 'seconds'
        date_num=datenum_zero+time_array/24./60./60.;
end

 % Para Lagos: 

matriz=[[datevec(date_num)],[repmat(0,length(Data(:,1)),1)],[data_array]];

% current=pwd;
% newFolderName=[current,'/converted2DARTlike/'];
% 
% if ~exist(newFolderName, 'dir')
%   mkdir(newFolderName);
% end
% 
% outputfile=strcat(newFolderName,name,ext);

[ConvertedFileName,ConvertedPathName,FilterIndex] = uiputfile('ASAT_formated_file.txt','Where do you want to save this ASAT formated file?');

dlmwrite([ConvertedPathName,ConvertedFileName],matriz,'delimiter','\t');
end