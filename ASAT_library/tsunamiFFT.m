% Y = fft(x) returns the discrete Fourier transform (DFT) of vector x, computed with a fast Fourier transform (FFT) algorithm.
% If the input X is a matrix, Y = fft(X) returns the Fourier transform of each column of the matrix.
% If the input X is a multidimensional array, fft operates on the first nonsingleton dimension.
% Y = fft(X,n) returns the n-point DFT. fft(X) is equivalent to fft(X, n) where n is the size of X in the first nonsingleton dimension. If the length of X is less than n, X is padded with trailing zeros to length n. If the length of X is greater than n, the sequence X is truncated. When X is a matrix, the length of the columns are adjusted in the same manner.
% Y = fft(X,[],dim) and Y = fft(X,n,dim) applies the FFT operation across the dimension dim.

% Examples

% A common use of Fourier transforms is to find the frequency components of a signal buried in a noisy time domain signal. Consider data sampled at 1000 Hz. Form a signal containing a 50 Hz sinusoid of amplitude 0.7 and 120 Hz sinusoid of amplitude 1 and corrupt it with some zero-mean random noise:
% 
% Fs = 1000;                    % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector
% % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
% y = x + 2*randn(size(t));     % Sinusoids plus noise
% plot(Fs*t(1:50),y(1:50))
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('time (milliseconds)')

% WATCH THIS TUTORIAL: https://www.youtube.com/watch?v=qrU2jsSqWD8

%It is difficult to identify the frequency components by looking at the original signal. Converting to the frequency domain, the discrete Fourier transform of the noisy signal y is found by taking the fast Fourier transform (FFT):
%signal=ts2.data;%(floor(3*length(rpro_detided_signal)/4):floor(end)); %signal=elev_filtered(100:end);%detided_signal(floor(length(detided_signal)/8):end);
function [Y,FFT_abs,period_freq_min]=tsunamiFFT(signal,step)
percentual_threshold=0.9;

Fs=1./(step*60.); 		% Sampling frequency in Hz
L=length(signal); 	% Length of the signal
NFFT = 2^nextpow2(L); 	% Next power of 2 from length of L
Y = fft(signal,NFFT)/L; % Calculation of the FFT 
f = Fs/2*linspace(0,1,NFFT/2+1); % Creation of the frequency array


% Plot single-sided amplitude spectrum.
% I am Not sure how to get energy spectrum
for i=1:L:NFFT-L
E(i) = sum(Y(1:NFFT/2+1).^2);
end
figure
E=abs(Y(1:NFFT/2+1));
%loglog(f,E) %antes estava: 
FFT_abs=abs(Y(1:NFFT/2+1));
semilogx(f,FFT_abs); 

title('Semilog Single-Sided Amplitude Spectrum')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
grid on

cursorMode = datacursormode(gcf);
cursorMode.removeAllDataCursors();
set(cursorMode, 'enable','on', 'UpdateFcn',@myotherotherfunction, 'NewDataCursorOnClick',false);


figure
loglog(f,FFT_abs);
title('LogLog Single-Sided Amplitude Spectrum')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
grid on

cursorMode = datacursormode(gcf);
cursorMode.removeAllDataCursors();
set(cursorMode, 'enable','on', 'UpdateFcn',@myotherotherfunction, 'NewDataCursorOnClick',false);


index=find(FFT_abs > percentual_threshold*max(FFT_abs));

peak_mag=FFT_abs(index);
peak_freq=f(index);

[mag_sorted,sorted_index]=sort(peak_mag);
peak_freq_sorted=peak_freq(sorted_index);
period_freq_min=1./peak_freq_sorted/60.;  % period from FFT in minutes


h=msgbox(sprintf('Maximum at: %f min.\n',period_freq_min),'Ordered periods for maxima in FFT');

 current=pwd;
newFolderName=[current,'/output_files/'];

if ~exist(newFolderName, 'dir')
  mkdir(newFolderName);
end

 % Seve results into a file
 header={'f(Hz)','ABS','FFTy'};
 txt=sprintf('%s\t %s\t %s\t',header{:});
 txt(end)=' ';
matriz=[f',FFT_abs,Y(1:NFFT/2+1)];
outputfile=[newFolderName,'FFT_results.txt'];
dlmwrite(outputfile,txt,' ');
dlmwrite(outputfile,matriz,'delimiter','\t','-append');

end


function output_txt = myotherotherfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).


pos = get(event_obj,'Position');

freq_value=(pos(1));

output_txt = {['Period: ',num2str(1./freq_value/60.),' min'],...
    ['Value: ',num2str(pos(2),4), ' m']};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str((pos(3)),4)];
end

end

% figure
% plot(E); 

% figure
% Pxx = abs(fft(signal,NFFT)).^2/length(signal)/Fs;
% % Create a single-sided spectrum
% Hpsd = periodogram(Pxx(1:length(Pxx)/2),'Fs',Fs);  
% plot(Hpsd)

%The main reason the amplitudes are not exactly at 0.7 and 1 is because of the noise. Several executions of this code (including recomputation of y) will produce different approximations to 0.7 and 1. The other reason is that you have a finite length signal. Increasing L from 1000 to 10000 in the example above will produce much better approximations on average.