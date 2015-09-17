%It is difficult to identify the frequency components by looking at the original signal. Converting to the frequency domain, the discrete Fourier transform of the noisy signal y is found by taking the fast Fourier transform (FFT):
%signal=ts2.data;%(floor(3*length(rpro_detided_signal)/4):floor(end)); %signal=elev_filtered(100:end);%detided_signal(floor(length(detided_signal)/8):end);
function [ts_tsu,P_tsu,F_tsu,ts_bkg,P_bkg,F_bkg]=spectral_ratios_diff_wrkspaces

info_msg=sprintf(['To better distinguish tsunami signals from non-tsunami \n', ...
     'ones, you can calculate spectral ratios which are the results of dividing \n', ...
     ' tsunami spectra by the background ones. \n', ...
     ' Rabinovich (1997) showed that spectral ratio is a useful tool \n', ...
     ' for identifying tsunami source signals because it normally enhances \n', ...
     ' amplifications at periods belonging to the tsunami source. \n', ...
     ' If you had created two equally sampled workspaces, one with \n',...
     ' the Tsunami signal and another with the background data, you can \n',...
     ' now proceed.']);
    uiwait(msgbox(info_msg, 'Info'));
    
   
    % First workspaces must contain Tsunami Signal
        [FileName,FilePath ]= uigetfile('*.mat','Please Provise a Tsunami signal workspace');
        Tsunami_File = fullfile(FilePath, FileName);
        load(Tsunami_File);
        factor=length(ts.Data)/1671;
        % calculate spectrum for tsunami signal
        ts_tsu=ts1;
        fs_tsu=1./(step*60.); %sampling frequency in Hertz or cps
        [P_tsu, F_tsu] = spectrum(ts1.Data,fix(factor*500),0,hanning(fix(factor*200)),fs_tsu);
        cph_tsu=(F_tsu*60.*60.); % cycles per hour from F which is in Hertz!
    
            % Plot 1
            figure; 
            loglog(cph_tsu,P_tsu(:,1)*10^4./(60.*60.),'red');
            hold on
            xlabel('Frequency [cph]');
            ylabel('Log_{10} Spectra [cm^2 cph^{-1}]');
        
    % Second Workspace must contain Backgroud Signal
        [FileName,FilePath ]= uigetfile('*.mat','Please Provise a Background signal workspace');
        Background_File = fullfile(FilePath, FileName);
        load(Background_File);
        factor=length(ts.Data)/1671;
        % calculate spectrum for Background Signal
        ts_bkg=ts1;
        fs_bkg=1./(step*60.); %sampling frequency in Hertz or cps
        [P_bkg, F_bkg] = spectrum(ts1.Data,fix(factor*500),0,hanning(fix(factor*200)),fs_bkg);
        cph_bkg=(F_bkg*60.*60.); % cycles per hour from F which is in Hertz!
        
        
        grid on
        
        loglog(cph_bkg,P_bkg(:,1)*10^4./(60.*60.),'black');
        legend('Tsunami','Background');
       % hold off
        
%         figure; 
%         rearrange_welch_periodogram(((cph_tsu)), log10(P_tsu(:,1)*10^4./(60.*60.)),'red');
%         hold on;
%         rearrange_welch_periodogram(((cph_bkg)), log10(P_bkg(:,1)*10^4./(60.*60.)),'black');
end