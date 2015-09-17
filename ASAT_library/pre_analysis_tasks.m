
% Sampling time for uniform data set
%step = 1.; % minute

%[ts1.time,ts1.data]=uniform_data_set(step,a);

%time=dn(1):step/60/24:dn(end);
%ts = timeseries(elev',dn);
%ts1 = resample(ts, time);

figure('name',['Original data in "',buoy_id,'"']);
plot(ts.Time,ts.Data);
hold on
set_label_date(ts1.time);
plot(ts1.time,ts1.data,'r');
legend('Original Timeseries','Interpolated Timeseries');
grid on

%%%%%%%%%%%%%%%%%%%% 
%% De-tiding
if strcmp(get(handles.auto_mode, 'Checked'),'on');
	[polynom,detided_signal,delta_detiding]=plot_signal_and_best_detide(ts1.time,ts1.data,'plot');
else
	[polynom,detided_signal,delta_detiding]=detide(ts1.time,ts1.data,handles.poly_degree);
	msgbox(['I used polynomial degree ', num2str(handles.poly_degree), 'for this fitting.']);
end

%size_detided_signal=
length1=length(time);
length2=length(detided_signal);
    if length1 == length2
         ts_deti= timeseries(detided_signal,time);
    else
        msgbox('ERROR: Data contains records with different rate acquisitions. Consider performing an interpolation/resampling!')
        return;
    end
%% End of De-tiding

figure('name',['Detided Signal for "',buoy_id,'"']);
%plot(dn,detided_signal);
%hold on
set_label_date(ts1.time);
plot(ts1.time,detided_signal,'r');


%%%%%%%%%%%%%%%%%%%% 
%% FILTERING DEVE SER USADO UNICAMENTE COM O uniform_data_set
%%%%%%%%%%%%%%%%%%%%
% step=1. %minute (see above)
% 
%   dn_final=ts1.time(1):step/(24.*60.):ts1.time(end);
%  
% %
%     elev_final=interp1(ts1.time,ts1.data,dn_final,'linear');
% figure 
% plot(dn_final,elev_final,'.');

if isdeployed
    
    nyquist_frequency=(1./(step*60.))/2.;
    cutoff_in_Hz=0.0003; % 0.0002 Hz ? 1.5 horas

        Wn=cutoff_in_Hz/nyquist_frequency; %normalized cutoff frequency
        [bb,aa] = butter(1,Wn,'high');
    
    elev_defi = filter(bb,aa,ts_deti.Data); % Hd filter is in .mat file
    elev_filt = filter(bb,aa,ts1.Data);
else

%     %---------------------------[ Start of buffer ]----------------------------
%     % Butterworth Bandpass filter designed using FDESIGN.BANDPASS.
% 
%     % All frequency values are in Hz.
%         Fs = 0.016666666667;  % Sampling Frequency
% 
%         Fstop1 = 0.00018315018315;  % First Stopband Frequency
%         Fpass1 = 0.0001872659176;   % First Passband Frequency
%         Fpass2 = 0.0055555555556;   % Second Passband Frequency
%         Fstop2 = 0.0083333333333;   % Second Stopband Frequency
%         Astop1 = 10;                % First Stopband Attenuation (dB)
%         Apass  = 0.0010858719444;   % Passband Ripple (dB)
%         Astop2 = 10;                % Second Stopband Attenuation (dB)
%         match  = 'passband';        % Band to match exactly
% 
%     % Construct an FDESIGN object and call its BUTTER method.
%         h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
%                      Astop2, Fs);
%         Hd = design(h, 'butter', 'MatchExactly', match);
%     %---------------------------[  End of buffer  ]----------------------------
    load('./ASAT_files/FILTER.mat');        
    elev_defi = filter(Hd,ts_deti.Data); % Hd filter is NOT in .mat file
    elev_filt = filter(Hd,ts1.Data);
end

plot(ts1.time,elev_defi,'g');
legend('de-tided original data','de-tided dta', 'de-tided & filtered data');
grid on

ts_defi = timeseries(elev_defi,ts1.time,'Name','De-tided and Filtered data with Band-pass filter');
ts_filt = timeseries(elev_filt,ts1.time,'Name','Filtered data with Band-pass filter');
ts.TimeInfo.Units = 'days';
ts.TimeInfo.Format = 'datenum';
ts.DataInfo.Units = 'm';
%figure 
%fvtool(bb,aa)