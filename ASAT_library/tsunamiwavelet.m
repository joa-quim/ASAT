% % % % THIS CODE IS NOT FULL RESPONSABILITY OF THE AUTHOR. IT IS BASED ON A THIRD PARTY AUTHOR.
% Code ADAPTED for ASTARTE project activities
% % % % By Filipe Lisboa @ IPMA, I.P. - Portuguese Sea and Atmosphere
% Institute
% 
% Scope: 
% 
% IMPORTANT: this code was based and uses functions from: 
% WAVETEST Example Matlab script for WAVELET, using NINO3 SST dataset
%
% See "http://paos.colorado.edu/research/wavelets/"
% Written January 1998 by C. Torrence
%
% Modified Oct 1999, changed Global Wavelet Spectrum (GWS) to be sideways,
%   changed all "log" to "log2", changed logarithmic axis on GWS to
%   a normal axis.
%

if ~isdeployed
   addpath(genpath('./ASAT_library/wave_matlab/'));
end
%load 'sst_nino3.dat'   % input SST time series
%sst =  ts_filtered.data; % Go back: Insert here signal of non-standalone things
%sst = detided_signal; %sst_nino3;
%time = ts_filtered.time; %dn; %[0:length(sst)-1]*dt + 1871.0 ;  % construct time arraystep=1.;
%------------------------------------------------------ Computation

% normalize by standard deviation (not necessary, but makes it easier
% to compare with plot on Interactive Wavelet page, at
% "http://paos.colorado.edu/research/wavelets/plot/"
variance = std(sst)^2;
%sst = (sst - mean(sst)); %Before:  ;
%sst = (sst - mean(sst))/sqrt(variance);
 
n = length(sst);
dt = step/(24.*60.);%step/24./60.; %before: dt = 1./(step*60.) ;
%xlim1=datevec(dn(1)); %[0:length(sst)-1]*dt + 1871.0 ;  % construct time array
%xlim2=datevec(dn(end)); %[0:length(sst)-1]*dt + 1871.0 ;  % construct time array
xlim = [time(1),time(end)];  % plotting range
%    PAD = if set to 1 (default is 0), pad time series with enough zeroes to get
%         N up to the next higher power of 2. This prevents wraparound
%         from the end of the time series to the beginning, and also
%         speeds up the FFT's used to do the wavelet transform.
%         This will not eliminate all edge effects (see COI below).
%
%    DJ = the spacing between discrete scales. Default is 0.25.
%         A smaller # will give better scale resolution, but be slower to plot.
%
%    S0 = the smallest scale of the wavelet.  Default is 2*DT.
%
%    J1 = the # of scales minus one. Scales range from S0 up to S0*2^(J1*DJ),
%        to give a total of (J1+1) scales. Default is J1 = (LOG2(N DT/S0))/DJ.
%
%    MOTHER = the mother wavelet function.
%             The choices are 'MORLET', 'PAUL', or 'DOG'
%
%    PARAM = the mother wavelet parameter.
%            For 'MORLET' this is k0 (wavenumber), default is 6.
%            For 'PAUL' this is m (order), default is 4.
%            For 'DOG' this is m (m-th derivative), default is 2.
%
%
pad = 1;       % pad the time series with zeroes (recommended)
dj = 15./(60.*24.);%1./60./24;%0.025;    % this will do 4 sub-octaves per octave
               % the spacing between discrete scales. Default is 0.25.
               % A smaller # will give better scale resolution, but be slower to plot.
s0 = 2.5*dt;    % this says start at a scale of dt
j1 = 7/dj; % 7/dj;    % this says do 7 powers-of-two with dj sub-octaves each
lag1 = 0.72;  % lag-1 autocorrelation for red noise background
%mother = 'MORLET';

%param=6;  % Mudar aqui a Wavelet Number da Morlet. beijinhos e abra?os.

% Wavelet transform:
[wave,period,scale,coi] = wavelet(sst,dt,pad,dj,s0,j1,mother,param);
power = (abs(wave)).^2 ;        % compute wavelet power spectrum

% Significance levels: (variance=1 for the normalized SST)
[signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,-1,-1,mother,param);
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;         % where ratio > 1, power is significant

% Global wavelet spectrum & significance levels:
global_ws = (sum(power')/n);   % time-average over all times
dof = n - scale;  % the -scale corrects for padding at edges
global_signif = wave_signif(sst,dt,scale,1,lag1,-1,dof,mother,param);

% Scale-average between El Nino periods of 2--8 years
avg = find((scale >= 2) & (scale < 8));
Cdelta = 0.776;   % this is for the MORLET wavelet
scale_avg = (scale')*(ones(1,n));  % expand scale --> (J+1)x(N) array
scale_avg = power ./ scale_avg;   % [Eqn(24)]
scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,-1,[1./(24.*60.),45./(24.*60.)],mother);

whos

% %------------------------------------------------------ Plotting
% 
% %--- Plot time series
% subplot('position',[0.1 0.75 0.65 0.2])
% plot(time,sst,'g')
% set(gca,'XLim',xlim(:))
% xlabel('Date & Time')
% ylabel('Elev. Differences (m)')
% title('a) De-tided & filtered Tsunami Signal')
% set_label_date(ts1.time)
% grid on
% hold off
% 
% 
% %period=period*24.*60;
% %--- Contour plot wavelet power spectrum
% subplot('position',[0.1 0.37 0.65 0.28])
% levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
% Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
% %contourf(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'
% imagesc(time,log2(period),abs(wave)); %imagesc(time,24.*60.*(period),(power));  %*** uncomment for 'image' plot
% xlabel('Time')
% ylabel('Period (em minutos)')
% title('b) Wavelet Power Spectrum')
% set(gca,'XLim',xlim(:))
% set(gca,'YLim',log2([2.8/24./60.,45/24./60.]), ...%[min(period),max(period)]), ...
% 	'YDir','normal', ... %before 'YDir','reverse', ...
% 	'YTick',log2(Yticks(:)), ...
% 	'YTickLabel',60.*24.*Yticks)   % converter ticks em dias para minutos
% colorbar('east','Ycolor','white');
% % 95% significance contour, levels at -99 (fake) and 1 (95% signif)
% hold on
% %contour(time,log2(period),sig95,[-99,.1],'k');
% %imagesc(time,log2(period),sig95,[-99,1],'k');
% hold on
% % cone-of-influence, anything "below" is dubious
% plot(time,log2(coi),'k')
% set_label_date(ts1.time)
% grid on
% hold off
% 
% %--- Plot global wavelet spectrum
% subplot('position',[0.77 0.37 0.2 0.28])
% plot(global_ws,log2(period))
% hold on
% plot(global_signif,log2(period),'--')
% hold off
% xlabel('Power')
% title('c) Global Wavelet Spectrum')
% set(gca,'YLim',log2([2.8/24./60.,45/24./60.]), ...
% 	'YDir','normal', ...
% 	'YTick',log2(Yticks(:)), ...
% 	'YTickLabel','')
% set(gca,'XLim',[0,1.25*max(global_ws)])
% 
% % %--- Plot 2--8 yr scale-average time series
% % subplot('position',[0.1 0.07 0.65 0.2])
% % plot(time,scale_avg)
% % set(gca,'XLim',xlim(:))
% % xlabel('Time (year)')
% % ylabel('Avg variance (2B defined)')
% % title('d) 2B defined') % title('d) 2-8 yr Scale-average Time Series')
% % hold on
% % plot(xlim,scaleavg_signif+[0,0],'--')
% % set_label_date(dn)
% % hold off
% 
%  dcm_obj = datacursormode(gcf);
%  set(dcm_obj,'UpdateFcn',@callback_wavelet_cursor)
% 
% % WRITE NOTHING BELOW THIS PART
% 
% 
%     if strcmp(handles.datatype,'ioc') == 0
%         [pathstr , name , ext ] = fileparts( DARTname ); 
%     else
%         name=id;
%     end
% annotation('textbox', [0.77 0.75 0.65 0.2],... % time series at [0.1 0.75 0.65 0.2])
%            'String', strrep(name,'_',' '),...
%            'LineStyle','none');%,...
%             %'HorizontalAlignment','right');
% % end of code

