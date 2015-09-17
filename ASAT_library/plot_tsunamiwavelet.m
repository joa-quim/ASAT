%------------------------------------------------------ Plotting
%FIGO=figure;
%--- Plot time series
power =log10((abs(wave)).^2);
s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
L(1)=plot(time,sst,'black');
set(gca,'XLim',xlim(:))
xlabel('Time [hh:mm]')
ylabel('Elev. Differences [m]')
title('De-tided & filtered Tsunami Signal')
set_label_date(ts1.time)
grid on
hold off

s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
%contourf(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'

L(2)=imagesc(time,log2(period),power); %imagesc(time,24.*60.*(period),(power));  %*** uncomment for 'image' plot
xlabel('Time [hh:mm]')
ylabel('Period [min]')
title('Wavelet Power Spectrum')
set(gca,'XLim',xlim(:))
set(gca,'YLim',log2([2.8/24./60.,90/24./60.]), ...%[min(period),max(period)]), ...
	'YDir','normal', ... %before 'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel',60.*24.*Yticks)   % converter ticks em dias para minutos
colorbar('east','Ycolor','white');
% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
hold on
%contour(time,log2(period),sig95,[-99,.1],'k');
%imagesc(time,log2(period),sig95,[-99,1],'k');
plot(time,log2(coi),'k')
hold on
% cone-of-influence, anything "below" is dubious
set_label_date(ts1.time)
grid on
hold off

%--- Plot global wavelet spectrum
s(3)=subplot('position',[0.77 0.1 0.2 0.35]);
L(3)=plot(global_ws,log2(period));
hold on
%plot(global_signif,log2(period),'--')
hold off
xlabel('Power')
title('Global Wavelet Spectrum')
set(gca,'YLim',log2([2.8/24./60.,90/24./60.]), ...
	'YDir','normal', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel','')
set(gca,'XLim',[0,1.25*max(global_ws)])

 dcm_obj = datacursormode(gcf);
 set(dcm_obj,'UpdateFcn',@callback_wavelet_cursor)
 
 

% WRITE NOTHING BELOW THIS PART

if exist('handles','var')==1
    if isfield(handles,'datatype')==1
                       
        if strcmp(handles.datatype,'ioc') == 0
            [pathstr , name , ext ] = fileparts( DARTname ); 
        else
            name=id;
        end
    
            text_annotation=['File info: ',...
                 strrep(name,'_',' ')];
 
            annotation('textbox', [0.8 0.7 0.65 0.2],... % time series at [0.1 0.75 0.65 0.2])
           'String', text_annotation,...
           'LineStyle','none');
    end
       
end
%,...
            %'HorizontalAlignment','right');
% end of code