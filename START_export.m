% % % % Code created within ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: Calculates number of points for uniformely sampled time
% seriesbased on the series length and wanted step in minutes
%       - RELEASES HISTORY:
%           ver 1.1:
%               - Fixed bug on loading successive workspaces
%           ver 1.2:
%               - Algorithm is prepared to import files where timeseries is
%               in either ascending or descending order.
%           ver 2.0:
%               - Corrected missmatch between plot of Wavelet Spectrum and
%               Global Wavelet Spectrum
%               - Corrected reading of seconds from DART-formated files. On
%               date arrays seconds are the only entry that is not an
%               integer. It's float.
%           ver 2.1:
%               - On GUI, cursor was changed from zoomming to display
%               timeseries values. (See this:
%               http://blogs.mathworks.com/videos/2011/02/25/creating-a-custom-data-cursor/ 
%           ver 2.2:
%               - Additional output files:
%                       - original imported time series
%                       - resampled time series
%                       - de-tided time series
%           ver 2.3: 
%               - Added Tool Bar to print, zoom and drag
%               - Added Data cursors to the Tool Bar. These data cursors 
%               are specially configured to the time domain. 
%               Within the code, the data series are always patched with 
%               Julian date, upon plotting these values are converted into 
%               hours, minutes and seconds for easier viewing. 
%               For wavelets,  periods are indicated and for the data 
%               series the height in metres. In the case of the FFT plots, 
%               whilst frequencies in Hz are displayed, data cursor 
%               converts to the specific period in minutes, 
%               thus saving the need of conversion.
%           ver 2.3.1:
%               - Bug fix for loading PDF manual
%           ver 2.3.2:
%               - Added button for spikes removal
%           ver 3.0:
%               - De-tided and detided & filtered plots are now present and
%                labelled
%           ver 3.1: 
%               - Added the option to customise Wavelet parameters and mother
%               function
%               - Color bar labels are now in white for better contrast
%           ver 4.0:
%               - Complete the outputting of .txt with the timeseries
%               - IOC data can be imported given the 4-letter code of the
%               station in "Station id" and select IOC data (make sure station
%               is in operation for the time-period selected)
%           ver 4.1: 
%               - A wait bar was added.
%           ver 4.1.1: 
%               - Fixed the problem updating the selection table when loading
%               or reloading a workspace
%           ver 4.1.2: 
%               - Fixed the hiperlinks openning on Windows standalone
%               version
%           ver 4.1.3:
%               - Google Earth stations maps integrated for Standalone
%               version only
%           ver 5.0:
%               - First of Not-So-Standalone versions
%               - Added a tool for polynomial fitting quality assessment
%           ver 5.0.1:
%               - Minor bug fixes;
%           ver 5.1:
%               - Added filter design menu
%           ver 5.1.1:
%               - Corrected bug that created complications on loading
%               previous ASAT made workspaces
%           ver 5.1.2:
%               - On loading new plots are done
%               - Performance modifications for the standalone compiled
%               versions
%           ver 5.1.3:
%               - The need for the Image Processing Toolbox was removed,
%               making the tool a roughly 20% faster
%           ver 6.0:
%               - Some output files are changed. 
%               - The Raw Data is no longer displayed but rather the
%               interpolated (if aplicable)
%           ver 7.0:
%               - Added Rabinovich (1997) method for spectral ratios that
%               yields the enhancement of Tsunami periods isolation
%           ver 7.1:
%               - Data is passed between callbacks through the structure
%               handles.data If it exists, there is no longer need to
%               constantly load workspaces
%               - Fixed a problem when saving workspaces
%           ver 8.0:
%               - Instead of the final Wavelet plot, a Wavelet User
%               Interface is now available
%           ver 9.0:
%               - Possibility to not perform interpolation. This is useful 
%               when working with high-resolution data
%               - 
%               
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function varargout = START_export(varargin)

	hObject = figure('Vis','off');
	START_LayoutFcn(hObject);
	handles = guihandles(hObject);

	handles.mother='MORLET';
	handles.datatype_selection='DeFi';
	initialize_gui(hObject, handles, false);

	img4 = imread('./ASAT_files/gui_images/logo.png');
	image(img4,'Parent',handles.axes4);
	set(handles.axes4,'Visible', 'off');
	% dragzoom('on');
	img5=imread('./ASAT_files/gui_images/ipma_logo.jpg');
	image(img5,'Parent',handles.axes5);
	set(handles.axes5,'Visible', 'off');
	img6=imread('./ASAT_files/gui_images/eu_flag.png');
	image(img6,'Parent',handles.axes6);
	set(handles.axes6,'Visible', 'off');
	% Plot Map
	% title('Stations Map')
	img1 = imread('./ASAT_files/gui_images/DARTmap.jpg');
	image(img1,'Parent',handles.axes3);
	set(handles.axes3,'Visible', 'off');

	addpath(genpath('./ASAT_library/'));
	addpath(genpath('./ASAT_library/wave_matlab/'));
	addpath(genpath('./ASAT_files/'));

	%------------ Give a Pro look (3D) to the frame boxes  -------------------------------
	new_frame3D(hObject, NaN, handles.Frame)
	%------------- END Pro look (3D) -----------------------------------------------------

	guidata(hObject, handles);
	set(hObject,'Visible','on');
	if (nargout),	varargout{1} = hObject;		end


function buoy_id_CB(hObject, handles)
	% buoy_id = str2double(get(hObject, 'String'));
	% if isnan(buoy_id)
	%     set(hObject, 'String', 0);
	%     errordlg('Input must be a number','Error');
	% end
	% 
	% % Save the new buoy_id value
	% handles.buoy_id = double2str(buoy_id);
	% guidata(hObject,handles)

% --- Executes on button press in start_export.
function loadDATA_CB(hObject, handles)
% ...
% 	set(START, 'HandleVisibility', 'off');
% 	close all;
% 	set(START, 'HandleVisibility', 'on');
% 	% if (get(handles.spec,'Value')) == 1
% 	%     DARTname=get(handles.dartfile_path,'String');
% 	%     handles.DARTname = DARTname;
% 	%     guidata(hObject, handles)
% 	% end

	h_progresso = waitbar(0,'Initializing ASAT...');

	string_progresso=['Downloading ', handles.datatype,' data.'];
	waitbar(0.1,h_progresso,string_progresso);
	movegui(h_progresso,'northeast')

	switch handles.datatype
		case 'ioc'
			buoy_id = read_buoy_id(hObject, handles);
			handles.DARTname = buoy_id;
			%DARTname=download_data_from_NOAA(handles.datatype,buoy_id);
			if (get(handles.check_truncate,'Value')) == 0
				msgbox('For IOC data a time selection is mandatory. Obrigado!','Warning!');
				return
			end
			GUIdates = readGUIfields(hObject, handles);
			tlower = datenum([GUIdates.yyyy_start GUIdates.mm_start GUIdates.dd_start GUIdates.hh_start GUIdates.mn_start GUIdates.ss_start]);
			tupper = datenum([GUIdates.yyyy_stop GUIdates.mm_stop GUIdates.dd_stop GUIdates.hh_stop GUIdates.mn_stop GUIdates.ss_stop]);
			% - verify dates consistency
			if tupper <= tlower
				msgbox('ERROR: Starting date must be before stopping date. Obrigado!','Warning!');
				return
			else                    
				[ts,dn,a, elev,sthour,date]=readHTMLfromIOC(buoy_id,tlower,tupper);
				guidata(hObject, handles);
				if isempty(a)==1
					msgbox('ERROR: No data for selected period.','Warning!');
					return
				end
			 end
			% - end of verify dates consistency

		case  'historical'
			if (get(handles.check_truncate,'Value')) == 1
				GUIdates = readGUIfields(hObject, handles);
				yyyy_historical = GUIdates.yyyy_start;
				if GUIdates.yyyy_start == GUIdates.yyyy_stop
					yyyy_historical = GUIdates.yyyy_start;
					equalequal=1;
				else
					yyyy_historical1 = GUIdates.yyyy_start;
					yyyy_historical2 = GUIdates.yyyy_stop;
					equalequal=0;
				end
			else
				x = inputdlg('Enter historical year |yyyy|: ',...
					'Selecting Entire Data from Specific Year', [1 50]);
				if (isempty(x)),	return,		end
				yyyy_historical = str2num(x{:}); 
				equalequal = 1;
			end
			buoy_id = read_buoy_id(hObject, handles); % Common to all the cases
			if equalequal == 1 % downloads single file for single year
				disp('Dart name appears here?');
				DARTname=download_data_from_NOAA(handles.datatype,buoy_id,yyyy_historical);
				disp('Yes or no above');
				handles.DARTname = DARTname;
				guidata(hObject, handles)
			else    % downloads two files for both year because yyyy start is different from yyyy stop
				DARTname1=download_data_from_NOAA(handles.datatype,buoy_id,yyyy_historical1);
				handles.DARTname1 = DARTname1;
				guidata(hObject, handles)
				% second file to be downloaded 
				DARTname2=download_data_from_NOAA(handles.datatype,buoy_id,yyyy_historical2);
				handles.DARTname2 = DARTname2;
				guidata(hObject, handles)
			end

		case 'realtime'
			buoy_id = read_buoy_id(hObject, handles);
			DARTname=download_data_from_NOAA(handles.datatype,buoy_id);
			handles.DARTname = DARTname;
			guidata(hObject, handles)
		case 'spec'
			DARTname=get(handles.dartfile_path,'String');
			[pathstr, name] = fileparts(DARTname);
			buoy_id = name;
			handles.DARTname = DARTname;
			guidata(hObject, handles)
	end

	if strcmp(handles.datatype,'ioc')==0
		if (get(handles.check_truncate,'Value')) == 1
			GUIdates = readGUIfields(hObject, handles);
			tlower = datenum([GUIdates.yyyy_start GUIdates.mm_start GUIdates.dd_start GUIdates.hh_start GUIdates.mn_start GUIdates.ss_start]);
			tupper = datenum([GUIdates.yyyy_stop GUIdates.mm_stop GUIdates.dd_stop GUIdates.hh_stop GUIdates.mn_stop GUIdates.ss_stop]);
			if tupper <= tlower
				msgbox('ERROR: Starting date must be before stopping date. Obrigado!','Warning!');
				return
			else
				[ts,dn,a, elev,sthour,date]=ReadDART_truncate(handles.DARTname,tlower,tupper);
				disp('Loading time selected data');
				guidata(hObject, handles)
				if isempty(a)==1
					disp << 'ERROR: No data for selected period.'
				end
			end
		else
			DARTname
			[ts,dn,a, elev,sthour,date]=ReadDART(DARTname);
			disp('Loading entire file data');
		end
	end

	%% Begin: In case date truncate is not checked:

	if (get(handles.check_truncate,'Value')) == 0
		GUIdates = readGUIfields(hObject, handles);

		start_date=datevec(ts.Time(1));
		GUIdates.yyyy_start=start_date(1);
		GUIdates.mm_start=start_date(2);
		GUIdates.dd_start=start_date(3);
		GUIdates.hh_start=start_date(4);
		GUIdates.mn_start=start_date(5);
		GUIdates.ss_start=start_date(6);

		stop_date=datevec(ts.Time(end));
		GUIdates.yyyy_stop=stop_date(1);
		GUIdates.mm_stop=stop_date(2);
		GUIdates.dd_stop=stop_date(3);
		GUIdates.hh_stop=stop_date(4);
		GUIdates.mn_stop=stop_date(5);
		GUIdates.ss_stop=stop_date(6);

		%buoy_id='undef';
		FilePath=DARTname;

		writeGUIfields(GUIdates, handles, buoy_id,FilePath);
	end

	%% End: In case date truncate is not checked:

	string_progresso='Download complete!';
	waitbar(0.6,h_progresso,string_progresso);

	if (get(handles.median_filter,'Value')) == 1
		elev=medfilt1(elev);
		ts.data=medfilt1(ts.data);
	end

	% Get file identifier for the end of workspace file name
	if strcmp(handles.datatype,'ioc') == 0
	kkk=strfind(DARTname, '.txt');
	id=DARTname(kkk-10:kkk-1);
	else
		id=handles.DARTname;
	end
	% Plot Map

	%figure
	%[y,detided_signal,delta]=best_fit(dn,elev);
	%  [polynom,detided_signal,delta_detiding]=plot_signal_and_best_detide(dn,elev);

	string_progresso='Detiding Data';
	waitbar(0.65,h_progresso,string_progresso);


	if (get(handles.interpolation_radiobutton,'Value')) == 1
		%Sampling step definition:
		step = str2double(get(handles.edit19,'string'));
		time=dn(1):step/60/24:dn(end);
		ts1 = resample(ts, time);
	else
		ts1 = ts;  
		time = ts.Time;
		step = mean(diff(time))*60.*24.;
	end
 
	% WAVELET IS HERE
  
	mother = handles.mother;
	param = str2double(get(handles.edit33,'string'));

	string_progresso='Applying filter';
	waitbar(0.7,h_progresso,string_progresso);
  
	pre_analysis_tasks;
        
	% What data should be used: 
	switch handles.datatype_selection
		case 'DeFi'
			sst=ts_defi.Data;
			time=ts_defi.Time;
		case 'Filt'
			sst=ts_filt.Data;
			time=ts_filt.Time;
		case 'Deti'
			sst=ts_deti.Data;
			time=ts_deti.Time;
	end
        
	tsunamiwavelet;
	% Signal and Polynomial Subplot
	axes(handles.axes7) %subplot(2,1,2)
	plot(time,ts1.Data);
	xlabel('Time (hours)');
	hold on
	plot(time, polynom,'red');
	title('Interpolated Data with Best Polynomial');
	set(gca,'XLim',xlim(:));
	set_label_date(ts1.Time);
	ylabel('elev. (m)');
	grid on
	hold off

	string_progresso='Plotting';
	waitbar(0.75,h_progresso,string_progresso);

	% Sampling time for uniform data set
	axes(handles.axes2);
	%[rpro_polynom,rpro_detided_signal,rpro_delta_detiding]=plot_signal_and_best_detide(ts1.time,ts1.data,'plot');
	% Detided Signal Subplot
	title('Signal and fitting');
	%subplot(2,1,1)
	plot(time,detided_signal,time, ts_defi.Data,'g');
	title('Resampled, de-tided and filtered data');
	legend('de-tided', 'de-tided & filtered');
	set(gca,'XLim',xlim(:));
	set_label_date(ts1.time)
	ylabel('detided elev. (m)')
	grid on

	% PLOTTING WAVELET
	%--- Contour plot wavelet power spectrum
	%subplot('position',[0.1 0.37 0.65 0.28])
	axes(handles.axes8)

	levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
	Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
	%contourf(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'
	imagesc(time,log2(period),abs(wave)); %imagesc(time,24.*60.*(period),(power));  %*** uncomment for 'image' plot
	xlabel('Time [hours]');
	ylabel('Period [min]')
	title('Wavelet Power Spectrum')
	set(gca,'XLim',xlim(:))
	set(gca,'YLim',log2([2.8/24./60.,45/24./60.]), ...%[min(period),max(period)]), ...
		'YDir','normal', ... %before 'YDir','reverse', ...
		'YTick',log2(Yticks(:)), ...
		'YTickLabel',60.*24.*Yticks)   % converter ticks em dias para minutos
	grid on
	colorbar('east','Ycolor','white');%colorbar('location','southoutside','position',[pos(1) pos(2)+pos(4) pos(3) 0.03]);%colorbar('southoutside');
	% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
	hold on
	contour(time,(period),sig95,[-99,1],'k');
	hold on
	% cone-of-influence, anything "below" is dubious
	plot(time,(coi),'k')
	set_label_date(ts1.time)
	hold off
	GUI_vertical_cursors;
	%%% END OF PLOTTING WAVELET

	% First get the figure's data-cursor mode, activate it, and set some of its properties
	% cursorMode = datacursormode(gcf);
	% set(cursorMode, 'enable','on', 'UpdateFcn',@myfunction, 'NewDataCursorOnClick',false);

	% SAVING STARTS HERE!
	datetime=clock;
	namedate=[' ',...
		num2str(datetime(1)),'-'... % Returns year as character
		num2str(datetime(2)),'-'... % Returns month as character
		num2str(datetime(3)),' '... % Returns day as char
		num2str(datetime(4)),'.'... % returns hour as char..
		num2str(datetime(5)),'.'... %returns minute as char
		num2str(round(datetime(6)))]; % returns seconds as char


	id = regexprep(id,'/','');
	id = regexprep(id,'\','');
	wrkspace_name=['tsunami_wkspace_',buoy_id,namedate,'.mat'];
	save(wrkspace_name, '-regexp', '^(?!(handles|hObject)$).')

	% Save to Tab delimited file:
	string_progresso='Saving data and creating outputs...';
	waitbar(0.80,h_progresso,string_progresso);


	handles.data=load((wrkspace_name));

	current=pwd;
	newFolderName=[current,'/output_files/'];

	if ~exist(newFolderName, 'dir')
		mkdir(newFolderName);
	end

	matriz_original=[datevec(ts.time),repmat(9,length(ts.Data),1),[ts.Data]];
	outputfile=[newFolderName,buoy_id,'_original',namedate,'.txt'];
	dlmwrite(outputfile,matriz_original,'delimiter','\t');

	matriz_resampled=[datevec(ts1.time),repmat(9,length(ts1.Data),1),ts1.Data];
	outputfile=[newFolderName,buoy_id,'_resampled',namedate,'.txt'];
	dlmwrite(outputfile,matriz_resampled,'delimiter','\t');

	matriz_detided=[[datevec(ts_deti.time)],[repmat(9,length(ts_deti.Data),1)],[ts_deti.Data]];
	outputfile=[newFolderName,buoy_id,'_detided',namedate,'.txt'];
	dlmwrite(outputfile,matriz_detided,'delimiter','\t');

	matriz_filt=[datevec(ts_filt.time),repmat(9,length(ts_filt.Data),1),ts_filt.Data];
	outputfile=[newFolderName,buoy_id,'_filtered',namedate,'.txt'];
	dlmwrite(outputfile,matriz_filt,'delimiter','\t');

	matriz_detided_filtered=[datevec(ts_defi.time),repmat(9,length(ts_defi.Data),1),ts_defi.Data];
	outputfile=[newFolderName,buoy_id,'_detided_filtered',namedate,'.txt'];
	dlmwrite(outputfile,matriz_detided_filtered,'delimiter','\t');


	L1product=[datevec(ts1.time),24*(ts1.time-ts1.time(1)),ts1.Data,ts_filt.Data,ts_deti.Data,ts_defi.Data];
	outputfile=[newFolderName,buoy_id,'_L1results',namedate,'.txt'];
	header={'year ','month ','day ','hour ','minute ','second ','seq. time [hours]','interpolated','filtered','detided','detided&filtered'};
	txt=sprintf('%s\t',header{:});
	txt(end)='';
	dlmwrite(outputfile,txt,'');
	dlmwrite(outputfile,L1product,'-append','delimiter','\t');

	string_progresso = 'Complete! At? j?!';
	waitbar(0.99,h_progresso,string_progresso);
	close(h_progresso);
	%Read more : http://www.ehow.com/how_6818858_convert-mat-xls.html
	guidata(hObject, handles);

	figure('name',['Wavelet Results for "', buoy_id,'"']);
	plot_tsunamiwavelet;
	vertical_cursors;
	deployed_wavelet_user_interface(wave,time,sst,xlim,ts1,period,Yticks,coi,global_ws,global_signif,step,buoy_id);
	%figure;
	%data_subplots(sst,period,ts1,coi,wave,time,xlim,global_ws)

% --------------------------------------------------------------------
function radio_iocdata_CB(hObject, handles)
	if (~get(hObject,'Val')),	set(hObject,'Val',1),	return,		end
	set([handles.radio_historical handles.radio_realtime handles.radio_spec],'Value', 0)
	disp('Getting data from IOC site: http://www.ioc-sealevelmonitoring.org/')        
	handles.datatype='ioc';
	guidata(handles.figure1, handles)

% --------------------------------------------------------------------
function radio_historical_CB(hObject, handles)
	if (~get(hObject,'Val')),	set(hObject,'Val',1),	return,		end
	set([handles.radio_iocdata handles.radio_realtime handles.radio_spec],'Value', 0)
	disp('Getting Historical Data')
	handles.datatype='historical';
	guidata(handles.figure1, handles)

% --------------------------------------------------------------------
function radio_realtime_CB(hObject, handles)
	if (~get(hObject,'Val')),	set(hObject,'Val',1),	return,		end
	set([handles.radio_iocdata handles.radio_historical handles.radio_spec],'Value', 0)
	disp('Getting Real Time Data')
	handles.datatype='realtime';
	guidata(handles.figure1, handles)

% --------------------------------------------------------------------
function radio_spec_CB(hObject, handles)
	if (~get(hObject,'Val')),	set(hObject,'Val',1),	return,		end
	set([handles.radio_iocdata handles.radio_historical handles.radio_realtime],'Value', 0)
	disp('Getting data from specific file: ')
	DARTname = dartfile_path_CB(hObject, handles);
	handles.DARTname = DARTname;
	handles.datatype='spec';
	guidata(handles.figure1, handles)

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
	% If the metricdata field is present and the reset flag is false, it means
	% we are we are just re-initializing a GUI by calling it from the cmd line
	% while it is up. So, bail out as we dont want to reset the data.
	if isfield(handles, 'metricdata') && ~isreset
		return
	end
	guidata(handles.figure1, handles);

function DARTname = dartfile_path_CB(hObject, handles)
	DARTname=get(handles.dartfile_path,'String');


%% Read Buoy Id
function buoy_id = read_buoy_id(hObject, handles)
	buoy_id = get(handles.buoy_id,'string');


%% Write GUI Fields
function writeGUIfields(GUIdates, handles, buoy_id,FilePath)
% ...
	set(handles.edit7,'String',sprintf('%d',GUIdates.yyyy_start));
	set(handles.yyyy_stop,'String',sprintf('%d',GUIdates.yyyy_stop));
	set(handles.mm_stop,'String',sprintf('%d',GUIdates.mm_stop));
	set(handles.mm_start,'String',sprintf('%d',GUIdates.mm_start));
	set(handles.dd_start,'String',sprintf('%d',GUIdates.dd_start));
	set(handles.dd_stop,'String',sprintf('%d',GUIdates.dd_stop));
	set(handles.hh_start,'String',sprintf('%d',GUIdates.hh_start));
	set(handles.hh_stop,'String',sprintf('%d',GUIdates.hh_stop));
	set(handles.mn_stop,'String',sprintf('%d',GUIdates.mn_stop));
	set(handles.mn_start,'String',sprintf('%d',GUIdates.mn_start));
	set(handles.ss_stop,'String',sprintf('%d',GUIdates.ss_stop));
	set(handles.ss_start,'String',sprintf('%d',GUIdates.ss_start));
	set(handles.edit19,'String',sprintf('%d',GUIdates.step));
	set(handles.buoy_id,'String',sprintf(buoy_id));
	set(handles.dartfile_path,'String',sprintf(FilePath));

%% Read GUI Fields
function GUIdates = readGUIfields(hObject, handles)
% ...
	GUIdates.yyyy_start = str2double(get(handles.edit7,'string'));
	GUIdates.yyyy_stop = str2double(get(handles.yyyy_stop,'string'));
	GUIdates.mm_start = str2double(get(handles.mm_start,'string'));
	GUIdates.mm_stop = str2double(get(handles.mm_stop,'string'));
	GUIdates.dd_start = str2double(get(handles.dd_start,'string'));
	GUIdates.dd_stop = str2double(get(handles.dd_stop,'string'));
	GUIdates.hh_start = str2double(get(handles.hh_start,'string'));
	GUIdates.hh_stop = str2double(get(handles.hh_stop,'string'));
	GUIdates.mn_start = str2double(get(handles.mn_start,'string'));
	GUIdates.mn_stop = str2double(get(handles.mn_stop,'string'));
	GUIdates.ss_start = str2double(get(handles.ss_start,'string'));
	GUIdates.ss_stop = str2double(get(handles.ss_stop,'string'));
	GUIdates.step = str2double(get(handles.edit19,'string'));

function edit7_CB(hObject, handles)
	yyyy_start=str2double(get(hObject,'String'));% returns contents of yyyy_start as a double


function mm_start_CB(hObject, handles)
	mm_start=str2double(get(hObject,'String'));% returns contents of yyyy_start as a double

function dd_start_CB(hObject, handles)
	dd_start=str2double(get(hObject,'String')); % returns contents of dd_start as a double


% --- Executes on button press in check_truncate.
function check_truncate_CB(hObject, handles)

% --- Executes on selection change in ocean_name.
function ocean_name_CB(hObject, handles)
% hObject    handle to ocean_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ocean_name contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ocean_name
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch val
case 1 % User selects peaks.
   handles.ocean = 'DARTmap';
   % Plot Map
   axes(handles.axes3)
   img1 = imread('./ASAT_files/gui_images/DARTmap.jpg');
   image(img1);
   set(gca,'xtick',[],'ytick',[]);
   %set(handles.axes3,'toolbar','figure');
   %set(handles.axes3,'menubar','figure');
case 2 % User selects membrane.
   handles.ocean = 'IOCmap';
   % Plot Map
   axes(handles.axes3)
   img2 = imread('./ASAT_files/gui_images/IOCmap.png');
   image(img2);
   set(gca,'xtick',[],'ytick',[]);
   zoom('on');
   
end
% Save the handles structure.
guidata(hObject,handles)


% --- Executes on button press in pushbutton9.
function pushbutton9_CB(hObject, handles)

[FileName,FilePath ]= uigetfile('*.txt');
ExPath = fullfile(FilePath, FileName);
set(handles.dartfile_path,'string',ExPath)
DARTname=get(handles.dartfile_path,'String');
tmp_fid=fopen(DARTname,'r');  % Open file assigning fid

if tmp_fid == -1
    message = sprintf(' The tool could not open this file. \n Good practice in paths are important \n avoid certain characters like: )(^ and accents. \n Ensure you are using a DART-like (ASAT formated) \n input file. \n If you are patient enough go check the manual.');
    msgbox(message);
    set(handles.dartfile_path,'string','Include an apropriate data file.');
    return;
end

tline=fgets(tmp_fid);

[numline, status]=str2num(tline);

if length(numline) ~= 8 || status == 0
    message = sprintf('Error: \n Please provide an ASAT-fomated file as input. \n You can also convert this file in File -> Convert a file into DART like. \n If you dont trust this tool, convert the file using a spreadsheet or maybe an abacus. \n In anycase, our standard is to use input files as it is described \n in the manual. But you didnt read it, right? ');
    msgbox(message);
    set(handles.dartfile_path,'string','Include an apropriate data file.');
    return;
end

% 
% fid=fopen(DARTname,'r');  % Open file assigning fid
% a=fscanf(fid,'%d %d %d %d %d %g %d %g',[8,inf]); 
% a=a';
% fclose(fid);

% --------------------------------------------------------------------
function about_menu_CB(hObject, handles)
%Developped by Filipe Lisboa for ASTARTE project - Assessment, STrategy and Risk Reduction for Tsunamis in Europe. At IPMA - Portuguese Sea and Atmosphere Institute. FP7 framework

% --------------------------------------------------------------------
function author_menu_CB(hObject, handles)
msgbox({'Developped by Filipe Lisboa for ASTARTE project - Assessment, STrategy and Risk Reduction for Tsunamis in Europe. At IPMA - Portuguese Sea and Atmosphere Institute. FP7 framework. ';'';'http://www.lisboa.estamine.net'},'About');
estamine_url='http://www.lisboa.estamine.net';

if ~isdeployed
   web(estamine_url,'-browser');
else
   dos('start http://www.lisboa.estamine.net');
end

% --------------------------------------------------------------------
function user_manual_menu_CB(hObject, handles)
	user_id = './ASAT_files/user_manual.pdf';
	open(user_id);


% --------------------------------------------------------------------
function astarte_info_menu_CB(hObject, handles)
	astarte_url='http://www.astarte-project.eu';

	if ~isdeployed
	   web(astarte_url,'-browser');
	else
	   dos('start http://www.astarte-project.eu');
	end


% --------------------------------------------------------------------
function save_workspace_menu_CB(hObject, handles)
% hObject    handle to save_workspace_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     DARTname=handles.DARTname;
%     kkk=strfind(DARTname, '.txt');
%     id=DARTname(kkk-10:kkk-1);
   % wrkspace_name=['tsunami_wkspace_',id,'.mat'];
   load(handles.data.wrkspace_name);
    [FileName,PathName,FilterIndex] = uiputfile( '*.mat','Enter Name for Tsunami Workspace','o_mar_enrola_na_areia');
    ExPath = fullfile(PathName,FileName);
 save(ExPath);

% --------------------------------------------------------------------
function load_workspace_menu_CB(hObject, handles)
% hObject    handle to load_workspace_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles=guidata(handles.output);
%initialize_gui(hObject, handles);
%guidata(hObject,handles);
%handles = guihandles('START_export.fig');

fig_handles=handles;

[FileName,FilePath ]= uigetfile('*.mat');
ExPath = fullfile(FilePath, FileName);
load(ExPath);
handles.DARTname=ExPath;

%handles.data=load(which(ExPath));

handles = fig_handles; % because loading new workspace also loads new handles

writeGUIfields(GUIdates, handles, buoy_id,FilePath); % Update GUI fields

Patolas=['Loaded from *.mat file: ', FileName];
set(handles.dartfile_path,'string',Patolas)
% Signal and Polynomial Subplot
axes(handles.axes7) %subplot(2,1,2)
plot(time,ts1.Data);
xlabel('Time [hours]');
hold on
plot(time, polynom,'red');
title('Interpolated Data with Best Polynomial');
set(gca,'XLim',xlim(:));
set_label_date(ts1.Time);
ylabel('elev. [m]');
grid on
hold off

%figure
% Sampling time for uniform data set
axes(handles.axes2)

title('Signal and fitting');
%subplot(2,1,1)
plot(time,detided_signal,time, ts_defi.Data,'g');
title('Resampled, de-tided and filtered data');
legend('de-tided', 'de-tided & filtered');
set(gca,'XLim',xlim(:));
set_label_date(ts1.time)
ylabel('detided elev. [m]')
grid on
      

% PLOTTING WAVELET
    %
axes(handles.axes8)
levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
%contourf(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'
imagesc(time,log2(period),abs(wave)); %imagesc(time,24.*60.*(period),(power));  %*** uncomment for 'image' plot
xlabel('Time [hours]');
ylabel('Period [min]')
title('Wavelet Power Spectrum')
set(gca,'XLim',xlim(:))
set(gca,'YLim',log2([2.8/24./60.,45/24./60.]), ...%[min(period),max(period)]), ...
	'YDir','normal', ... %before 'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel',60.*24.*Yticks)   % converter ticks em dias para minutos
grid on
colorbar('east');%colorbar('location','southoutside','position',[pos(1) pos(2)+pos(4) pos(3) 0.03]);%colorbar('southoutside');
% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
hold on
% cone-of-influence, anything "below" is dubious
plot(time,(coi),'k')
set_label_date(ts1.time) 
hold off 
GUI_vertical_cursors;
%% This module is not saving new handles
%guidata(hObject, handles);

%figure
%% Re-do plots
figure('name',['Wavelet Results for "', buoy_id,'"']);
plot_tsunamiwavelet;
vertical_cursors;
deployed_wavelet_user_interface(wave,time,sst,xlim,ts1,period,Yticks,coi,global_ws,global_signif,step,buoy_id);
%figure;
 %data_subplots(sst,period,ts1,coi,wave,time,xlim,global_ws)
 handles.data=load(ExPath);
 guidata(hObject, handles);
%% End of Re-do

 %%% END OF PLOTTING WAVELET

% --------------------------------------------------------------------
function fft_menu_CB(hObject, handles)


% --------------------------------------------------------------------
function convert2DARTform_CB(hObject, handles)
% ...
	[FileName,FilePath] = uigetfile('*.*');
	ExPath = fullfile(FilePath, FileName);

	GUIdates = readGUIfields(hObject, handles);

	prompt = {'Year','Month','Day','Hour','Minutes','Seconds'};
	dlg_title = 'What date corresponds to the time 0 (zero) in this file? ';
	def = {num2str(GUIdates.yyyy_start),num2str(GUIdates.mm_start),num2str(GUIdates.dd_start),num2str(GUIdates.hh_start),num2str(GUIdates.mn_start),num2str(GUIdates.ss_start)};

	options.Resize='on';
	options.WindowStyle='normal';
	options.Interpreter='tex';

	answer = inputdlg(prompt,dlg_title,[1 90],def,options);
	datenum_zero=datenum([str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}),str2double(answer{5}),str2double(answer{6})]);

	% Create pop-up menu
	e = menu('I can not guess everything. What is the time unit on your original file?',...
		'Years','Days','Hours','Minutes','Seconds');

	switch e
		case 1,		time_unit='years';
		case 2,		time_unit='days';
		case 3,		time_unit='hours';
		case 4,		time_unit='minutes';
		case 5,		time_unit='seconds';
	end

	convert2DARTform(ExPath,datenum_zero,time_unit)

% --------------------------------------------------------------------
function output_txt = myfunction(obj,event_obj)
	pos = get(event_obj,'Position');
	vector_date=datevec(pos(1));
	output_txt = {['hour: ',num2str(vector_date(4))],...
		['min: ',num2str(vector_date(5))],...
		['sec: ',num2str(vector_date(6))],...
		['Period: ',num2str(24.*60.*2.^pos(2),4), ' min']};

	% If there is a Z-coordinate in the position, display it as well
	if length(pos) > 2
		output_txt{end+1} = ['Z: ',num2str((pos(3)),4)];
	end

% --------------------------------------------------------------------
function output_txt = myotherfunction(obj,event_obj)
	pos = get(event_obj,'Position');
	vector_date=datevec(pos(1));
	output_txt = {['hour: ',num2str(vector_date(4))],...
		['min: ',num2str(vector_date(5))],...
		['sec: ',num2str(vector_date(6))],...
		['Value: ',num2str(pos(2),4), ' metros']};

	% If there is a Z-coordinate in the position, display it as well
	if length(pos) > 2
		output_txt{end+1} = ['Z: ',num2str((pos(3)),4)];
	end

% --------------------------------------------------------------------
function uitoggletool4_ClickedCallback(hObject, handles)
% ...
	set(handles.uitoggletool5,'State','Off');
	cursorMode = datacursormode(gcf);
	cursorMode.removeAllDataCursors();
	set(cursorMode, 'enable','on', 'UpdateFcn',@myotherfunction, 'NewDataCursorOnClick',false);

% --------------------------------------------------------------------
function uitoggletool5_ClickedCallback(hObject, handles)
% ...
	set(handles.uitoggletool4,'State','Off');
	cursorMode = datacursormode(gcf);
	cursorMode.removeAllDataCursors();
	set(cursorMode, 'enable','on', 'UpdateFcn',@myfunction, 'NewDataCursorOnClick',false);

% --- Executes on button press in median_filter.
function median_filter_CB(hObject, handles)
% ...
	sentence=['Median Filter is Set.' ...   
		'This filter applies an order 3, one-dimensional median filter to the input data.' ...
		'The function considers the signal to be 0 beyond' ...
		' the endpoints. The output has the same length as the input.' ...
		'For odd n, y(k) is the median of x(k-(n-1)/2:k+(n-1)/2).'...
		'For even n, y(k) is the median of x(k-n/2), x(k-(n/2)+1), ..., x(k+(n/2)-1).'...
		'In this case, medfilt1 sorts the numbers, then takes the average of the n/2 '...
		'and (n/2)+1 elements.'];
    msgbox(sentence);
% Hint: get(hObject,'Value') returns toggle state of median_filter

%display('Median Filter is Set. See: http://www.mathworks.com/help/signal/ref/medfilt1.html')


% --- Executes on selection change in choose_function.
function choose_function_CB(hObject, handles)
	val = get(hObject,'Value');
	% Set current data to the selected data set.
	switch val
	case 1 % User selects peaks.
	   handles.mother = 'MORLET';
	   % Define mother function
	case 2 % User selects membrane.
	   handles.mother = 'DOG';
	   % Define mother function
	case 3 % User selects sinc.
	   handles.mother = 'PAUL';
	   % Define mother function
	end
	% Save the handles structure.
	guidata(hObject,handles)


% --- Executes on button press in mapspushbutton.
function mapspushbutton_CB(hObject, handles)
%stations_id = './ASAT_files/stations.kml';
%openKML(stations_id);
if ~isdeployed
   display('Only the standalone version will open Google Earth for you. Maps with the many stations are also online.');
else
    if ispc == 1
        dos('start .\ASAT_files\stations.kml');
    end
end

% --- Executes on button press in stationhelp.
function stationhelp_CB(hObject, handles)
	msgbox('Station id is a 4-character code for IOC data or a 5-digit for DART. Lookup their sites for more info.','HELP');
                        
% --------------------------------------------------------------------
function save_frame_CB(hObject, handles)
% ...
f = getframe(gcf);
[im,map] = frame2im(f);

datetime=clock;

namedate=['ASATscreenshot ',...
     num2str(datetime(1)),'-'... % Returns year as character
     num2str(datetime(2)),'-'... % Returns month as character
     num2str(datetime(3)),' '... % Returns day as char
     num2str(datetime(4)),'.'... % returns hour as char..
     num2str(datetime(5)),'.'... %returns minute as char
     num2str(round(datetime(6)))... % returns seconds as char
     '.jpg'];

imwrite(im,namedate);
% time = clock; % Gets the current time as a 6 element vector
% 
% eval(['save whatever_filename_beginning_you_want' ...
% num2char(time(1))... % Returns year as character
% num2char(time(2))... % Returns month as character
% num2char(time(3))... % Returns day as char
% num2char(time(4))... % returns hour as char..
% num2char(time(5))... %returns minute as char
% num2char(time(6))... % returns seconds as char
% 'name_of_the_variable_you_want_to_save']);


% --- Executes on button press in pushbutton16.
function pushbutton16_CB(hObject, handles)
	ioc_list_url='http://www.ioc-sealevelmonitoring.org/list.php';

	if ~isdeployed
	   web(ioc_list_url,'-browser');
	else
	   dos('start http://www.ioc-sealevelmonitoring.org/list.php');
	end


% --------------------------------------------------------------------
function detiding_menu_CB(hObject, handles)

% --------------------------------------------------------------------
function set_poly_CB(hObject, handles)


% --------------------------------------------------------------------
function auto_mode_CB(hObject, handles)
% hObject    handle to auto_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Auto mode will recursevely calculate all the polynomials until a fitting threshold defined by the ASTARTE team is stisfied. Alternatively, you can manualy set a polynomial degree.');
end
delete(handles.poly_degree);
guidata(hObject,handles);

% --------------------------------------------------------------------
function eval_fit_CB(hObject, handles)
% hObject    handle to eval_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'data') == 1
    buoy_id=handles.data.buoy_id;
    GUIdates=handles.data.GUIdates;
    ts=handles.data.ts;
    dn=handles.data.dn;
    a=handles.data.a;
    elev=handles.data.elev;
    sthour=handles.data.sthour;
    date=handles.data.date;
    DARTname=handles.data.DARTname;
    step=handles.data.step;
    time=handles.data.time;
    ts1=handles.data.ts1;
    mother=handles.data.mother;
    param=handles.data.param;
    polynom=handles.data.polynom;
    xlim=handles.data.xlim;
    detided_signal=handles.data.detided_signal;
    ts_defi=handles.data.ts_defi;
    levels=handles.data.levels;
    period=handles.data.period;
    Yticks=handles.data.Yticks;
    wave=handles.data.wave;
    sig95=handles.data.sig95;
    coi=handles.data.coi;
    % datetime=handles.data.datetime;
    wrkspace_name=handles.data.wrkspace_name;
    sst=handles.data.sst;
    global_ws=handles.data.global_ws;
    delta_detiding=handles.data.delta_detiding;
    % Hd=handles.data.Hd;
    sst=handles.data.sst;
    variance=handles.data.variance;
    n=handles.data.n;
    dt=handles.data.dt;
    pad=handles.data.pad;
    dj=handles.data.dj;
    s0=handles.data.s0;
    j1=handles.data.j1;
    lag1=handles.data.lag1;
    scale=handles.data.scale;
    power=handles.data.power;
    signif=handles.data.signif;
    fft_theor=handles.data.fft_theor;
    dof=handles.data.dof;
    global_signif=handles.data.global_signif;
    avg=handles.data.avg;
    scale_avg=handles.data.scale_avg;
    Cdelta=handles.data.Cdelta;
    scaleavg_signif=handles.data.scaleavg_signif; 
    ExPath=(wrkspace_name);
else
    uiwait(msgbox('There is no data to do this. Do you wish to use a workspace you already have?'));
    [FileName,FilePath ]= uigetfile('*.mat', 'Load a ASAT workspace file (.mat)');
    ExPath = fullfile(FilePath, FileName);
    load(ExPath);
end

if isdeployed
    %    [FileName,FilePath ]= uigetfile('*.mat');
    %ExPath = fullfile(FilePath, FileName);
    %load(ExPath);
    deployed_poly_fit_ui(ts,ts1);
end

poly_fit_ui;


% --------------------------------------------------------------------
function degree5_CB(hObject, handles)
% hObject    handle to degree5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    %set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 5;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree6_CB(hObject, handles)
% hObject    handle to degree6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    %set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 6;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree7_CB(hObject, handles)
% hObject    handle to degree7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    %set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 7;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree8_CB(hObject, handles)
% hObject    handle to degree8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    %set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 8;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree9_CB(hObject, handles)
% hObject    handle to degree9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    %set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 9;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree10_CB(hObject, handles)
% hObject    handle to degree10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    %set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 10;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree11_CB(hObject, handles)
% hObject    handle to degree11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    %set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 11;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree12_CB(hObject, handles)
% hObject    handle to degree12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    %set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 12;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree13_CB(hObject, handles)
% hObject    handle to degree13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    %set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 13;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree14_CB(hObject, handles)
% hObject    handle to degree14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    %set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 14;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree15_CB(hObject, handles)
% hObject    handle to degree15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    %set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 15;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree16_CB(hObject, handles)
% hObject    handle to degree16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    %set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 16;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree17_CB(hObject, handles)
% hObject    handle to degree17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)if strcmp(get(gcbo, 'Checked'),'off')
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    %set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 17;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function degree18_CB(hObject, handles)
% hObject    handle to degree18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    %set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 18;
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function degree19_CB(hObject, handles)
% hObject    handle to degree19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    %set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 19;
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function degree20_CB(hObject, handles)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    %set(handles.degree20, 'Checked', 'off');
    set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 20;
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function degree21_CB(hObject, handles)
% hObject    handle to degree21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'off')
    set(gcbo, 'Checked', 'on');
    set(handles.set_poly, 'Checked', 'on');
    set(handles.auto_mode, 'Checked', 'off');
    set(handles.degree5, 'Checked', 'off');
    set(handles.degree6, 'Checked', 'off');
    set(handles.degree7, 'Checked', 'off');
    set(handles.degree8, 'Checked', 'off');
    set(handles.degree9, 'Checked', 'off');
    set(handles.degree10, 'Checked', 'off');
    set(handles.degree11, 'Checked', 'off');
    set(handles.degree12, 'Checked', 'off');
    set(handles.degree13, 'Checked', 'off');
    set(handles.degree14, 'Checked', 'off');
    set(handles.degree15, 'Checked', 'off');
    set(handles.degree16, 'Checked', 'off');
    set(handles.degree17, 'Checked', 'off');
    set(handles.degree18, 'Checked', 'off');
    set(handles.degree19, 'Checked', 'off');
    set(handles.degree20, 'Checked', 'off');
    %set(handles.degree21, 'Checked', 'off');
    msgbox('Automatic fitting is disabled.');
    handles.poly_degree = 21;
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function filter_design_CB(hObject, handles)


% --------------------------------------------------------------------
function see_filter_CB(hObject, handles)
% hObject    handle to see_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[FileName,FilePath ]= uigetfile('*.mat');
%ExPath = fullfile(FilePath, FileName);
%load(ExPath);

%#function dfilt
if ~isdeployed
    load('./ASAT_files/FILTER.mat');
    fvtool(Hd);
else
    myicon = imread('./ASAT_files/filter.png');
    msgbox('For the non-standalone version only.',myicon);
end


% --------------------------------------------------------------------
function do_a_FFT_CB(hObject, handles)
% hObject    handle to do_a_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'data') == 1
    buoy_id=handles.data.buoy_id;
    GUIdates=handles.data.GUIdates;
    ts=handles.data.ts;
    dn=handles.data.dn;
    a=handles.data.a;
    elev=handles.data.elev;
    sthour=handles.data.sthour;
    date=handles.data.date;
    DARTname=handles.data.DARTname;
    step=handles.data.step;
    time=handles.data.time;
    ts1=handles.data.ts1;
    mother=handles.data.mother;
    param=handles.data.param;
    polynom=handles.data.polynom;
    xlim=handles.data.xlim;
    detided_signal=handles.data.detided_signal;
    ts_defi=handles.data.ts_defi;
    levels=handles.data.levels;
    period=handles.data.period;
    Yticks=handles.data.Yticks;
    wave=handles.data.wave;
    sig95=handles.data.sig95;
    coi=handles.data.coi;
    %datetime=handles.data.datetime;
    wrkspace_name=handles.data.wrkspace_name;
    sst=handles.data.sst;
    global_ws=handles.data.global_ws;
    delta_detiding=handles.data.delta_detiding;
    Hd=handles.data.Hd;
    sst=handles.data.sst;
    variance=handles.data.variance;
    n=handles.data.n;
    dt=handles.data.dt;
    pad=handles.data.pad;
    dj=handles.data.dj;
    s0=handles.data.s0;
    j1=handles.data.j1;
    lag1=handles.data.lag1;
    scale=handles.data.scale;
    power=handles.data.power;
    signif=handles.data.signif;
    fft_theor=handles.data.fft_theor;
    dof=handles.data.dof;
    global_signif=handles.data.global_signif;
    avg=handles.data.avg;
    scale_avg=handles.data.scale_avg;
    Cdelta=handles.data.Cdelta;
    scaleavg_signif=handles.data.scaleavg_signif; 
   
    ExPath=(wrkspace_name);
   
else
    uiwait(msgbox('There is no data to do this. Do you wish to use a workspace you already have?'));
    [FileName,FilePath ]= uigetfile('*.mat', 'Load a ASAT workspace file (.mat)');
    ExPath = fullfile(FilePath, FileName);
    load(ExPath);
end

datacursormode off;

GUIdates = readGUIfields(hObject, handles);

prompt = {'Year','Month','Day','Hour','Minutes','Seconds', 'Length of Tsunami Signal (in hours)'};
dlg_title = 'Select Tsunami Signal';
num_lines = 1;
def = {num2str(GUIdates.yyyy_start),num2str(GUIdates.mm_start),num2str(GUIdates.dd_start),num2str(GUIdates.hh_start),num2str(GUIdates.mn_start),num2str(GUIdates.ss_start),'2.5'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

jd_stop=datenum([str2num(answer{1}),str2num(answer{2}),str2num(answer{3}),str2num(answer{4}),str2num(answer{5}),str2num(answer{6})])+str2num(answer{7})/24.;
[b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss]=datevec(jd_stop);


        switch handles.datatype_selection
            case 'DeFi'
                [ts_fourier]=truncate_ts(ts_defi,str2num(answer{1}),str2num(answer{2}),str2num(answer{3}),str2num(answer{4}),str2num(answer{5}),str2num(answer{6}),b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss);
            case 'Filt'
                [ts_fourier]=truncate_ts(ts_filt,str2num(answer{1}),str2num(answer{2}),str2num(answer{3}),str2num(answer{4}),str2num(answer{5}),str2num(answer{6}),b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss);
            case 'Deti'
                [ts_fourier]=truncate_ts(ts_deti,str2num(answer{1}),str2num(answer{2}),str2num(answer{3}),str2num(answer{4}),str2num(answer{5}),str2num(answer{6}),b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss);
        end


signal=ts_fourier.data;
[Y,FFT_abs,period_freq_min]=tsunamiFFT(signal,step);

period_freq_min

save(ExPath);

% --------------------------------------------------------------------
function welch_periodogram_CB(hObject, handles)
% ...
if isfield(handles,'data') == 1
    buoy_id=handles.data.buoy_id;
    GUIdates=handles.data.GUIdates;
    ts=handles.data.ts;
    dn=handles.data.dn;
    a=handles.data.a;
    elev=handles.data.elev;
    sthour=handles.data.sthour;
    date=handles.data.date;
    DARTname=handles.data.DARTname;
    step=handles.data.step;
    time=handles.data.time;
    ts1=handles.data.ts1;
    mother=handles.data.mother;
    param=handles.data.param;
    polynom=handles.data.polynom;
    xlim=handles.data.xlim;
    detided_signal=handles.data.detided_signal;
    ts_defi=handles.data.ts_defi;
    levels=handles.data.levels;
    period=handles.data.period;
    Yticks=handles.data.Yticks;
    wave=handles.data.wave;
    sig95=handles.data.sig95;
    coi=handles.data.coi;
%    datetime=handles.data.datetime;
    wrkspace_name=handles.data.wrkspace_name;
    sst=handles.data.sst;
    global_ws=handles.data.global_ws;
    delta_detiding=handles.data.delta_detiding;
    %Hd=handles.data.Hd;
    sst=handles.data.sst;
    variance=handles.data.variance;
    n=handles.data.n;
    dt=handles.data.dt;
    pad=handles.data.pad;
    dj=handles.data.dj;
    s0=handles.data.s0;
    j1=handles.data.j1;
    lag1=handles.data.lag1;
    scale=handles.data.scale;
    power=handles.data.power;
    signif=handles.data.signif;
    fft_theor=handles.data.fft_theor;
    dof=handles.data.dof;
    global_signif=handles.data.global_signif;
    avg=handles.data.avg;
    scale_avg=handles.data.scale_avg;
    Cdelta=handles.data.Cdelta;
    scaleavg_signif=handles.data.scaleavg_signif; 
    ExPath=(wrkspace_name);
else
    uiwait(msgbox('There is no data to do this. Do you wish to use a workspace you already have?'));
    [FileName,FilePath ]= uigetfile('*.mat', 'Load a ASAT workspace file (.mat)');
    ExPath = fullfile(FilePath, FileName);
    load(ExPath);
end

GUIdates = readGUIfields(hObject, handles);

prompt = {'Year','Month','Day','Hour','Minutes','Seconds', 'Length of Tsunami Signal (in hours)'};
dlg_title = 'Select Tsunami Signal';
num_lines = 1;
def = {num2str(GUIdates.yyyy_start),num2str(GUIdates.mm_start),num2str(GUIdates.dd_start),num2str(GUIdates.hh_start),num2str(GUIdates.mn_start),num2str(GUIdates.ss_start),'2.5'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

jd_stop=datenum([str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}),str2double(answer{5}),str2double(answer{6})])+str2double(answer{7})/24.;
[b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss]=datevec(jd_stop);

        switch handles.datatype_selection
            case 'DeFi'
                [ts_fourier]=truncate_ts(ts_defi,str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}),str2double(answer{5}),str2double(answer{6}),b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss);
            case 'Filt'
                [ts_fourier]=truncate_ts(ts_filt,str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}),str2double(answer{5}),str2double(answer{6}),b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss);
            case 'Deti'
                [ts_fourier]=truncate_ts(ts_deti,str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}),str2double(answer{5}),str2double(answer{6}),b_yyyy,b_mm,b_dd,b_hh,b_mn,b_ss);
        end

signal=ts_fourier.data;
cor_color='b';

figure('name',['spectrum for ', handles.datatype_selection, ' timeseries']);
spectra;


% --- Executes on button press in interpolation_radiobutton.
function interpolation_radiobutton_CB(hObject, handles)
% ...
sentence2=['If interpolation is not set problems may arise: ' ...   
        'Data from DART normally contains different samplings.' ...
        'This can cause ASAT to crash. ' ...
        ' But non-interpolation is useful if you are certain' ...
        ' that data is constant-rate. '...
        ' In this way, not performing interpolation gives you the '...
        ' original data. '...
        ' We basically advise to use this for tide gauge data only. '];
	msgbox(sentence2);


% --- Executes on selection change in datatype_selection_popupmenu.
function datatype_selection_popupmenu_CB(hObject, handles)
% ...
	val = get(hObject,'Value');
	% Set current data to the selected data set.
	switch val
		case 1 % User selects peaks.
			handles.datatype_selection = 'DeFi';
			% Define mother function
		case 2 % User selects membrane.
			handles.datatype_selection = 'Filt';
			msgbox('Directly filtering data without previously removing tide might result in a great Gibbs phenomenon of overshooting. Specially in the beggining of the timeseries. Use this option if your data contains tide-less records. Thanks.')
			% Define mother function
		case 3 % User selects sinc.
			handles.datatype_selection = 'Deti';
			% Define mother function
	end
	% Save the handles structure.
	guidata(hObject,handles)


% --- Executes on selection change in popupmenu5.
function popupmenu5_CB(hObject, handles)


% --------------------------------------------------------------------
function tsu_bkg_diff_wrks_CB(hObject, handles)
% ...
	[ts_tsu,P_tsu,F_tsu,ts_bkg,P_bkg,F_bkg]=spectral_ratios_diff_wrkspaces;

	datetime=clock;
	namedate=[' ',...
		 num2str(datetime(1)),'-'... % Returns year as character
		 num2str(datetime(2)),'-'... % Returns month as character
		 num2str(datetime(3)),' '... % Returns day as char
		 num2str(datetime(4)),'.'... % returns hour as char..
		 num2str(datetime(5)),'.'... %returns minute as char
		 num2str(round(datetime(6)))]; % returns seconds as char
	string=['tsu_bkg_spectra',namedate,'.mat'];
	save(string);

% --------------------------------------------------------------------
function tsu_bkg_same_wrks_CB(hObject, handles)
	msgbox('Available in next version');


function START_LayoutFcn(h1)
load START_export.mat

set(h1, 'Position',[10 10 1179 797],...
'PaperUnits','centimeters',...
'Visible','on',...
'Color',[0.831372549019608 0.815686274509804 0.784313725490196],...
'MenuBar','none',...
'Name','START',...
'NumberTitle','off',...
'HandleVisibility','callback',...
'Tag','figure1');

axes('Parent',h1, 'Units','pixels', 'Position',[550 312 611 185],...
'PlotBoxAspectRatio',[1 0.30278232405892 0.30278232405892],...
'Tag','axes2');

axes('Parent',h1, 'Units','pixels', 'Position',[920 1 63 47],...
'Tag','axes4',...
'Visible','off');

axes('Parent',h1, 'Units','pixels', 'Position',[1078 1 101 47],...
'Tag','axes5',...
'Visible','off');

axes('Parent',h1, 'Units','pixels', 'Position',[991 1 79 47],...
'Tag','axes6',...
'Visible','off');

axes('Parent',h1, 'Units','pixels', 'Position',[550 570 611 187],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraTarget',[0.5 0.5 0.5],...
'CameraViewAngle',6.60861036031192,...
'PlotBoxAspectRatio',[1 0.306055646481178 0.306055646481178],...
'Tag','axes7');

axes('Parent',h1, 'Units','pixels', 'Position',[550 88 613 176],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraTarget',[0.5 0.5 0.5],...
'CameraViewAngle',6.60861036031192,...
'PlotBoxAspectRatio',[1 0.287112561174551 0.287112561174551],...
'Tag','axes8');

h70 = uimenu('Parent',h1, 'Label','File', 'Tag','Untitled_2');
uimenu('Parent',h70, 'Call',@START_uiCB, 'Label','Save Tsunami Workspace As...', 'Tag','save_workspace_menu');
uimenu('Parent',h70, 'Call',@START_uiCB, 'Label','Load Tsunami Workspace', 'Tag','load_workspace_menu');
uimenu('Parent',h70, 'Call',@START_uiCB, 'Label','Convert a file into DART-like', 'Tag','convert2DARTform');
uimenu('Parent',h70, 'Call',@START_uiCB, 'Label','Save Frame', 'Tag','save_frame');

h75 = uimenu('Parent',h1, 'Call',@START_uiCB, 'Label','De-tiding', 'Tag','detiding_menu');
uimenu('Parent',h75, 'Call',@START_uiCB, 'Label','Auto Mode', 'Checked','on', 'Tag','auto_mode');

h77 = uimenu('Parent',h75, 'Call',@START_uiCB, 'Label','Set Polynom Degree', 'Tag','set_poly');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 5', 'Tag','degree5');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 6', 'Tag','degree6');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 7', 'Tag','degree7');
uimenu('Parent',h77, 'Call',@START_uiCB,'Label','Degree 8', 'Tag','degree8');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 9', 'Tag','degree9');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 10', 'Tag','degree10');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 11', 'Tag','degree11');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 12', 'Tag','degree12');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 13', 'Tag','degree13');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 14', 'Tag','degree14');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 15', 'Tag','degree15');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 16', 'Tag','degree16');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 17', 'Tag','degree17');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 18', 'Tag','degree18');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 19', 'Tag','degree19');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 20', 'Tag','degree20');
uimenu('Parent',h77, 'Call',@START_uiCB, 'Label','Degree 21', 'Tag','degree21');

uimenu('Parent',h75, 'Call',@START_uiCB, 'Label','Evaluate fitting (for loaded workspaces) ', 'Tag','eval_fit');

h96 = uimenu('Parent',h1, 'Call',@START_uiCB, 'Label','Filter Design', 'Tag','filter_design');
uimenu('Parent',h96, 'Call',@START_uiCB, 'Label','See filter', 'Tag','see_filter');

h99 = uitoolbar('Parent',h1,'Tag','uitoolbar1');

uitoggletool('Parent',h99,...
'CData',mat{2},...
'ClickedCallback','%default',...
'Separator','on',...
'TooltipString','Zoom In',...
'Tag','uitoggletool1');

uitoggletool('Parent',h99,...
'CData',mat{3},...
'ClickedCallback','%default',...
'Separator','on',...
'TooltipString','Zoom Out',...
'Tag','uitoggletool2');

uitoggletool('Parent',h99,...
'CData',mat{4},...
'ClickedCallback','%default',...
'Separator','on',...
'TooltipString','Arrast o',...
'Tag','uitoggletool3');

uitoggletool('Parent',h99,...
'CData',mat{5},...
'ClickedCallback',@(hObject,eventdata)START_export('uitoggletool4_ClickedCallback',hObject,guidata(hObject)),...
'Separator','on',...
'TooltipString','Data Cursor',...
'Tag','uitoggletool4');

uitoggletool('Parent',h99,...
'CData',mat{6},...
'ClickedCallback',@(hObject,eventdata)START_export('uitoggletool5_ClickedCallback',hObject,guidata(hObject)),...
'Separator','on',...
'TooltipString','Wavelet Data Cursor',...
'Tag','uitoggletool5');

uipushtool('Parent',h99,...
'CData',mat{7},...
'ClickedCallback','%default',...
'Separator','on',...
'TooltipString','Print Figure',...
'BusyAction','cancel',...
'Interruptible','off',...
'Tag','uipushtool2');

h116 = uimenu('Parent',h1, 'Call',@START_uiCB, 'Label','Fourier Analysis', 'Tag','fft_menu');
uimenu('Parent',h116, 'Call',@START_uiCB, 'Label','Perform FFT','Tag','do_a_FFT');
h118 = uimenu('Parent',h116, 'Label','Tsunami vs Background spectra', 'Tag','spectral_division');
uimenu('Parent',h118, 'Call',@START_uiCB, 'Label','Tsunami and Background are in different workspaces','Tag','tsu_bkg_diff_wrks');
uimenu('Parent',h118, 'Call',@START_uiCB, 'Label','tsunami and background same workspace', 'Tag','tsu_bkg_same_wrks');
uimenu('Parent',h116, 'Call',@START_uiCB, 'Label','Welch Periodogram', 'Tag','welch_periodogram');

h122 = uimenu('Parent',h1, 'Call',@START_uiCB, 'Label','About', 'Tag','about_menu');
uimenu('Parent',h122, 'Call',@START_uiCB, 'Label','Author', 'Tag','author_menu')
uimenu('Parent',h122, 'Call',@START_uiCB, 'Label','User Manual', 'Tag','user_manual_menu');
uimenu('Parent',h122, 'Call',@START_uiCB, 'Label','ASTARTE info', 'Tag','astarte_info_menu');

X0 = 20;	Y0 = 431;
uicontrol('Parent',h1, 'Pos',[X0 Y0 480 356], 'Style','frame', 'Tag','Frame');
%uicontrol('Parent',h1, 'Position',[X0+1 Y0+1 478 354], 'Style','text')

axes('Parent',h1, 'Units','pixels', 'Position',[X0+13 Y0+50 452 286],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraTarget',[0.5 0.5 0.5],...
'CameraViewAngle',6.60861036031192,...
'PlotBoxAspectRatio',[1 0.632743362831858 0.632743362831858],...
'Tag','axes3');

uicontrol('Parent',h1, 'Position',[X0+15 Y0+14 143 29],...
'String',{'DART buoys map'; 'IOC stations map' },...
'Style','popupmenu',...
'Value',1,...
'BackgroundColor',[1 1 1],...
'Call',@START_uiCB,...
'Tag','ocean_name');

uicontrol('Parent',h1, 'Position',[X0+157 Y0+16 83 29],...
'String','See Map',...
'Call',@START_uiCB,...
'Tag','mapspushbutton');

uicontrol('Parent',h1, 'Position',[X0+238 Y0+16 88 29],...
'String','IOC stations list',...
'Call',@START_uiCB,...
'Tag','pushbutton16');

X0 = 20;	Y0 = 158;
uicontrol('Parent',h1, 'Pos',[X0 Y0 480 266], 'Style','frame', 'Tag','Frame');
uicontrol('Parent',h1, 'Position',[X0+1 Y0+1 478 264], 'Style','text')

uicontrol('Parent',h1, 'Position',[X0+11 Y0+177 215 21],...
'String','DART Historical (last year and before)',...
'Style','radiobutton',...
'Value',1,...
'Call',@START_uiCB,...
'Tag','radio_historical');

uicontrol('Parent',h1, 'Position',[X0+8 Y0+29 435 21],...
'String','/Users/filipebernardolisboa/',...
'Style','edit',...
'BackgroundColor',[0 0 0],...
'Call',@START_uiCB,...
'ForegroundColor',[0 1 0],...
'Tag','dartfile_path',...
'FontSize',12);

uicontrol('Parent',h1, 'Position',[X0+9 Y0+63 156 21],...
'String','From Specific Folder:',...
'Style','radiobutton',...
'Call',@START_uiCB,...
'Tag','radio_spec');

uicontrol('Parent',h1, 'Position',[X0+290 Y0+187 33 25.4980694980695],...
'String','2014',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Call',@START_uiCB,...
'Tag','edit7');

uicontrol('Parent',h1, 'Position',[X0+321 Y0+187 21 25.4980694980695],...
'String','04',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Call',@START_uiCB,...
'Tag','mm_start');

uicontrol('Parent',h1, 'Position',[X0+326 Y0+234 101 17.6525096525097],...
'String','Start Date and Time',...
'Style','text',...
'Tag','text17');

uicontrol('Parent',h1, 'Position',[X0+328 Y0+155 101 17.6525096525097],...
'String','Stop Date and Time',...
'Style','text',...
'Tag','text18');

uicontrol('Parent',h1, 'Position',[X0+340 Y0+187 21 25.4980694980695],...
'String','01',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Call',@START_uiCB,...
'Tag','dd_start');

uicontrol('Parent',h1, 'Position',[X0+384 Y0+187 21 25.4980694980695],...
'String','23',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','hh_start');

uicontrol('Parent',h1, 'Position',[X0+405 Y0+186 21 25.4980694980695],...
'String','00',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','mn_start');

uicontrol('Parent',h1, 'Position',[X0+425 Y0+186 21 25.4980694980695],...
'String','00',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','ss_start');

uicontrol('Parent',h1, 'Position',[X0+294 Y0+109 33 25.4980694980695],...
'String','2014',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','yyyy_stop');

uicontrol('Parent',h1, 'Position',[X0+289 Y0+218 80 15.6911196911197],...
'String','yyyy mm dd',...
'Style','text',...
'Tag','yyyy');

uicontrol('Parent',h1, 'Position',[X0+327 Y0+109 21 25.4980694980695],...
'String','04',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','mm_stop');

uicontrol('Parent',h1, 'Position',[X0+386 Y0+109 22 25.4980694980695],...
'String','04',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','hh_stop');

uicontrol('Parent',h1, 'Position',[X0+407 Y0+109 22 25.4980694980695],...
'String','59',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','mn_stop');

uicontrol('Parent',h1, 'Position',[X0+426 Y0+109 22 25.4980694980695],...
'String','03',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','ss_stop');

uicontrol('Parent',h1, 'Position',[X0+254 Y0+85 207 24],...
'String','Truncate Data using these periods',...
'Style','checkbox',...
'Call',@START_uiCB,...
'Tag','check_truncate');

uicontrol('Parent',h1, 'Position',[X0+348 Y0+109 21 25.4980694980695],...
'String','02',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','dd_stop');

uicontrol('Parent',h1, 'Position',[X0+140 Y0+60 65 23.090909090909],...
'String','Browse',...
'Call',@START_uiCB,...
'Tag','pushbutton9');

uicontrol('Parent',h1, 'Position',[X0+293 Y0+137 80 15.6911196911197],...
'String','yyyy mm dd',...
'Style','text',...
'Tag','text32');

uicontrol('Parent',h1, 'Position',[X0+372 Y0+215 80 16],...
'String','hh mn ss',...
'Style','text',...
'Tag','text33');

uicontrol('Parent',h1, 'Position',[X0+376 Y0+137 80 16],...
'String','hh mn ss',...
'Style','text',...
'Tag','text34');

uicontrol('Parent',h1, 'Position',[X0+10 Y0+153 180 21],...
'String','DART Real Time (current year)',...
'Style','radiobutton',...
'Call',@START_uiCB,...
'Tag','radio_realtime');

uicontrol('Parent',h1, 'Position',[X0+10.54 Y0+204 143 20.32],...
'String','IOC data',...
'Style','radiobutton',...
'Call',@START_uiCB,...
'Tag','radio_iocdata');

uicontrol('Parent',h1, 'Position',[X0+216 Y0+231 64 20.5945945945946],...
'String','Station id:',...
'Call',@START_uiCB,...
'Tag','stationhelp');

uicontrol('Parent',h1, 'Position',[X0+214 Y0+203 66 23.5366795366795],...
'HorizontalAlignment','right',...
'String','32412',...
'Style','edit',...
'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
'Call',@START_uiCB,...
'Tag','buoy_id',...
'FontSize',13);

X0 = 20;	Y0 = 93;
uicontrol('Parent',h1, 'Pos',[X0 Y0 480 59], 'Style','frame', 'Tag','Frame');
uicontrol('Parent',h1, 'Position',[X0+1 Y0+1 478 57], 'Style','text')

uicontrol('Parent',h1,'Position',[X0+400 Y0+6 32 23],...
'String','1',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','edit19');

uicontrol('Parent',h1, 'Position',[X0+280 Y0+12 119 14],...
'String','Interpolation step (min):',...
'Style','text',...
'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
'Tag','text35');

uicontrol('Parent',h1, 'Position',[X0+280 Y0+29 162 24],...
'String','Do an interpolation',...
'Style','radiobutton',...
'Value',1,...
'Call',@START_uiCB,...
'Tag','interpolation_radiobutton');

uicontrol('Parent',h1, 'Position',[X0+112 Y0+14 145 28],...
'String',{'Detided + Filtered'; 'Filtered'; 'Detided' },...
'Style','popupmenu',...
'Value',1,...
'BackgroundColor',[1 1 1],...
'Call',@START_uiCB,...
'Tag','datatype_selection_popupmenu');

uicontrol('Parent',h1, 'Position',[X0+12 Y0+14 95 29],...
'String','Data being used for analysis:',...
'Style','text',...
'Tag','text50');

X0 = 20;	Y0 = 13;
uicontrol('Parent',h1, 'Pos',[X0 Y0 480 75], 'Style','frame', 'Tag','Frame');
uicontrol('Parent',h1, 'Position',[X0+1 Y0+1 478 73], 'Style','text')

uicontrol('Parent',h1, 'Position',[X0+173 Y0+48 200 23],...
'String','Apply Median Filter (for spiky data)',...
'Style','radiobutton',...
'Call',@START_uiCB,...
'Tag','median_filter');

uicontrol('Parent',h1, 'Position',[X0+5 Y0+5 97 25],...
'String',{'Morlet'; 'Dog'; 'Paul' },...
'Style','popupmenu',...
'Value',1,...
'BackgroundColor',[1 1 1],...
'Call',@START_uiCB,...
'Tag','choose_function');

uicontrol('Parent',h1, 'Position',[X0+2 Y0+35 133 14],...
'String','Wavelet Mother Function',...
'Style','text',...
'Tag','text42')

uicontrol('Parent',h1, 'Position',[X0+105 Y0+14 101 13],...
'String','Wavelet Parameter:',...
'Style','text',...
'Tag','text43')

uicontrol('Parent',h1, 'Position',[X0+203 Y0+8 26 23],...
'String','6',...
'Style','edit',...
'BackgroundColor',[1 1 1],...
'Tag','edit33')

uicontrol('Parent',h1, 'Position',[X0+355 Y0+13 114 39],...
'String','Standalone Analysis',...
'Call',@START_uiCB,...
'Tag','loadDATA')

uicontrol('Parent',h1, 'Position',[558 1 358 18],...
'String','Developped by Filipe Lisboa for ASTARTE project, all rights reserved.',...
'Style','text',...
'Tag','text15')

function START_uiCB(hObject, eventdata)
% This function is executed by the callback and than the handles is allways updated.
	feval([get(hObject,'Tag') '_CB'],hObject, guidata(hObject));