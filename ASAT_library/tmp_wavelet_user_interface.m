% %------------------------------------------------------ Plotting
% %FIGO=figure;
% %--- Plot time series
% power = log10((abs(wave)).^2);
% s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
% L(1)=plot(time,sst,'black');
% set(gca,'XLim',xlim(:))
% xlabel('Time [hh:mm]')
% ylabel('Elev. Differences [m]')
% title('De-tided & filtered Tsunami Signal')
% set_label_date(ts1.time)
% grid on
% hold off
% 
% s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
% levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
% Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
% %contourf(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'
% 
% L(2)=imagesc(time,log2(period),power); %imagesc(time,24.*60.*(period),(power));  %*** uncomment for 'image' plot
% xlabel('Time [hh:mm]')
% ylabel('Period [min]')
% title('Wavelet Power Spectrum')
% set(gca,'XLim',xlim(:))
% set(gca,'YLim',log2([2.8/24./60.,90/24./60.]), ...%[min(period),max(period)]), ...
% 	'YDir','normal', ... %before 'YDir','reverse', ...
% 	'YTick',log2(Yticks(:)), ...
% 	'YTickLabel',60.*24.*Yticks)   % converter ticks em dias para minutos
% colorbar('east','Ycolor','white');
% % 95% significance contour, levels at -99 (fake) and 1 (95% signif)
% hold on
% %contour(time,log2(period),sig95,[-99,.1],'k');
% %imagesc(time,log2(period),sig95,[-99,1],'k');
% plot(time,log2(coi),'k')
% hold on
% % cone-of-influence, anything "below" is dubious
% set_label_date(ts1.time)
% grid on
% hold off
% 
% %--- Plot global wavelet spectrum
% s(3)=subplot('position',[0.77 0.1 0.2 0.35]);
% L(3)=plot(global_ws,log2(period));
% hold on
% %plot(global_signif,log2(period),'--')
% hold off
% xlabel('Power')
% title('Global Wavelet Spectrum')
% set(gca,'YLim',log2([2.8/24./60.,90/24./60.]), ...
% 	'YDir','normal', ...
% 	'YTick',log2(Yticks(:)), ...
% 	'YTickLabel','')
% set(gca,'XLim',[0,1.25*max(global_ws)])
% 
%  dcm_obj = datacursormode(gcf);
%  set(dcm_obj,'UpdateFcn',@callback_wavelet_cursor)
%  
%  
% 
% % WRITE NOTHING BELOW THIS PART
% 
% if exist('handles','var')==1
%     if isfield(handles,'datatype')==1
%                        
%         if strcmp(handles.datatype,'ioc') == 0
%             [pathstr , name , ext ] = fileparts( DARTname ); 
%         else
%             name=id;
%         end
%     
%             text_annotation=['File info: ',...
%                  strrep(name,'_',' ')];
%  
%             annotation('textbox', [0.8 0.7 0.65 0.2],... % time series at [0.1 0.75 0.65 0.2])
%            'String', text_annotation,...
%            'LineStyle','none');
%     end
%        
% end
% %,...
%             %'HorizontalAlignment','right');
% % end of code


function tmp_wavelet_user_interface

    wave=evalin('base','wave');
    time=evalin('base','time');
    sst=evalin('base','sst');
    xlim=evalin('base','sst');
    ts1=evalin('base','ts1');
    period=evalin('base','period');
    Yticks=evalin('base','Yticks');
    coi=evalin('base','coi');
    global_ws=evalin('base','global_ws');
    global_signif=evalin('base','global_signif');
    
    xlim=evalin('base','xlim');
    step=evalin('base','step');
    % Create a figure and axes
    
    f = figure('name','Wavelet User Interface','Visible','on');
    %ax = axes('Units','pixels');
    %surf(peaks)
    %p = get(gcf, 'Position');
    
     popup_xaxis = uicontrol('Style', 'popup',...
           'String', {'15min','30min','1hour','1day'},...
           'Position', [180 300 168 50],...
           'Callback', @xaxis);  
    % Create pop-up menu
    popup = uicontrol('Style', 'popup',...
           'String', {'Wave Amplitude','Energy Density','Energy Density (log2)','Energy Density (log10)'},...
           'Position', [40 300 168 50],...
           'Callback', @setmap);    
    
   % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Explain me',...
        'Position', [20 20 50 20],...
        'Callback', @explainme);       
					
    
  % Vedit=uicontrol('Style','edit','String',['variable=',num2str(x)]);
    
%      global x
% x=get(sld,'Value');
% set(Vedit,'String',['variable=',num2str(x)]);
%     

   
    % Make figure visble after adding all components
%    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');
    
    function setmap(source,callbackdata)
        %val = source.Value;
        %maps = source.String;
        % For R2014a and earlier: 
         val = get(source,'Value');
         maps = get(source,'String'); 
         
         global s;
         
         switch val
             case 1
             hold off;
             what_wavelet = (abs(wave));  % Tsunami Amplitude
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

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time [hh:mm]')
                    ylabel('Period [min]')
                    title('Wavelet - Amplitude')
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
                    %set_label_data(ts1.Time);
             case 2
                 hold off;
                 what_wavelet =(abs(wave)).^2;
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

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time [hh:mm]')
                    ylabel('Period [min]')
                    title('Wavelet - Energy Density')
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
                    %set_label_data(ts1.Time);
             case 3
                 hold off;
                 what_wavelet =log2((abs(wave)).^2);
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

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time [hh:mm]')
                    ylabel('Period [min]')
                    title('Wavelet - Energy Density log2')
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
                    %set_label_data(ts1.Time);
             case 4
                 hold off;
                 what_wavelet =log10((abs(wave)).^2);
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

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time [hh:mm]')
                    ylabel('Period [min]')
                    title('Wavelet - Energy Density log10')
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
                    %set_label_data(ts1.Time);
         end
         
         vertical_cursors;
         
         % newmap = maps{val};
         % colormap(newmap);
    end

%     function surfzlim(source,callbackdata)
%         %val = 51 - source.Value;
%         % For R2014a and earlier:
%         val = get(source,'Value');
%         %get(source,'Value')
%         degree=round(get(source,'Value'));
%         Vedit=uicontrol('Style','edit','String',['degree=',num2str(degree)]);
%         [time,data]=setmap(source,callbackdata);
%         [polynom,detided_signal,delta_detiding]=detide(time,data, degree);
%         
%       
%         subplot(3,1,1);
%         plot(time,data,'b');
%         grid on;
%         hold on;
%         plot(time,polynom,'black');
%         hold off;
%         subplot(3,1,2);
%         plot(time,detided_signal,'green');
%         grid on;
%         subplot(3,1,3);
%         plot(time,delta_detiding,'red');
%         grid on;
%         hold off;
%         Vedit2=uicontrol('Style','edit','Position',[400 65 120 20],'String',['av_delta=',num2str(mean(delta_detiding))]);
%     end

    function explainme(source,callbackdata)
        msgbox('Depending on how you plot results from the Wavelets analyses different details can be seen. ');
    end

function xaxis(source,callbackdata)
    % For R2014a and earlier: 
         val = get(source,'Value');
        dn=ts1.time;
        
        global s;
        %global L;
         
         switch val
            case 1 %'15min'
                    interval=round(15/step);
                    string_type=15;
            case 2 %'30min'
                    interval=round(30/step);
                    string_type=15;
            case 3 %'1hour'
                    interval=round(60/step);
                    string_type=15;
            case 4 %'1day'
                    interval=round(60.*24./step);
                    string_type=1;
          end

    labels = datestr(dn(1:interval:end), string_type);
    set(s(1), 'XTick', dn(1:interval:end));
    set(s(1), 'XTickLabel', labels);
    set(s(2), 'XTick', dn(1:interval:end));
    set(s(2), 'XTickLabel', labels);
end
end