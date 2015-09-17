fs=1/(60.*step);
[pxx,f] = pwelch(signal,[],[],[],fs);

% WATCH THIS TUTORIAL: https://www.youtube.com/watch?v=qrU2jsSqWD8
period_scaling_welch=1./f/60.;
cph=f*60.*60.;%1./(period_scaling_welch./60.);
%pxx=fftshift(pxx);
%line((cph),10*log10(pxx),'color',cor_color);

%[pxx,f] = periodogram(ts.Data,hamming(length(ts.Data)),length(ts.Data),fs);


rearrange_welch_periodogram((cph), log10(pxx*10^4./60.),cor_color); % dividing by 60 appear in cpm 

% xlabel('Frequency [cph]');
% ylabel('dB');
% grid on;
%  a = get(gca,'XTickLabel');
%  set(gca, 'XTickLabel', 10.^a);
% 
% labels2 = [1 2 4 8 16 32 64 128];
%  labels = 60./[1 2 4 8 16 32 64 128];
%  set(gca, 'XTick', log10(labels));
  %set(gca, 'XTickLabel', labels);

%h=addTopXAxis('expression', '(60./argu)','xLabStr', 'Period [min]');

 
%  set(gca, 'XTick', log10(labels2));
%  set(gca, 'XTickLabel', labels2);

% ax1 = gca;
% set(ax1,'XColor','b','YColor','b')
% %Next, create another axes at the same location as the first, placing the x-axis on top and the y-axis on the right. Set the axes Color to none to allow the first axes to be visible and color code the x- and y-axis to match the data.
% 
% ax2 = axes('Position',get(ax1,'Position'),...
%            'XAxisLocation','top',...
%            'YAxisLocation','right',...
%            'Color','none',...
%            'XColor','k','YColor','k');
%         
% %Draw the second set of data in the same color as the x- and y-axis.
% 
% hl2 = line(cph,10*log10(pxx),'Color','k','Parent',ax2);
% xlabel('Frequency (cph)');
% 
% xlimits = get(ax1,'XLim');
% ylimits = get(ax1,'YLim');
% xinc = (xlimits(2)-xlimits(1))/5;
% yinc = (ylimits(2)-ylimits(1))/5;
% %Now set the tick mark locations.
% 
% set(ax1,'XTick',[xlimits(1):xinc:xlimits(2)],...
%         'YTick',[ylimits(1):yinc:ylimits(2)])
% 
%
