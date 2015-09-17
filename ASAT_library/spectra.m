% This function is crutial for making periodograms
% Periodograms should be made on the original or resamples timeseries ts or
% ts1 respectively in order to do not manipulate overall results and
% calculation of total tsunami energy
factor=length(signal)/1671; % this factor takes into the account the reference from Heidarzadeh: 
if factor < 1
    factor = 1;
end

% The main advantage of the Welch?s method over the standard periodogram
% method is that it reduces noise in the estimated power spectra (OPPENHEIM
% and SCHAFER 1975). Here, we apply the Welch algorithm in the Matlab 
% program for our spectral analysis (MATHWORKS 2012). The average length of
% the tsunami signal used for spectral analysis is about 1,690 data points 
% which means a time length of around 28 h. The hamming window method was 
% used in this study for spectral analysis, whose length was 500 data 
% points, i.e., a time length of about 8 h. The windows were overlapped 
% using 200 data points (i.e., a time length of 3.33 h).
%%%%
% FROM: 
%%%%
% Waveform and Spectral Analyses of the 2011 Japan Tsunami Records on Tide
% Gauge and DART Stations Across the Pacific Ocean
% MOHAMMAD HEIDARZADEH1,2 and KENJI SATAKE2
fs=1./(step*60.); %sampling frequency in Hertz or cps

[P, F] = spectrum(signal,fix(factor*500),0,hanning(fix(factor*200)),fs);

cph=(F*60.*60.); % cycles per hour from F which is in Hertz!
loglog(cph,P(:,1)*10^4./(60.*60.),'black');
xlabel('Frequency [cph]');
ylabel('Log_{10} Spectra [cm^2 cph^{-1}]');
grid on
rearrange_welch_periodogram(((cph)), log10(P(:,1)*10^4./(60.*60.)),cor_color);

% Verified against: http://www.ngdc.noaa.gov/hazard/data/DART/20110311_honshu/jpg/dart32411_20110310to20110314_Specs.jpg
