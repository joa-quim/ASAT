function deployed_wavelet_user_interface(wave,time,sst,xlim,ts1,period,Yticks,coi,global_ws,global_signif,step,buoy_id)

   


    % Create a figure and axes
   f = figure('name',['Wavelet User Interface for "', buoy_id,'"'],'Visible','on','units','normalized','outerposition',[0 0 1 1]);
    %ax = axes('Units','pixels');
    %surf(peaks)
    p = get(gcf, 'Position');
    
    
    % Create pop-up menu
    popup_xaxis = uicontrol('Style', 'popup',...
           'String', {'15min','30min','1hour','2hours','6hours','1day','2day'},...
           'Units','normalized',...
           'Position', [.85 .1 .075 .65],...
           'Callback', @xaxis);  
    
    
    popup = uicontrol('Style', 'popup',...
           'String', {'Wave Amplitude','Wave Amplitude (log2)', 'Wave Amplitude (log10)','Energy Density','Energy Density (log2)','Energy Density (log10)'},...
           'Units','normalized',...
           'Position', [.85 .15 .12 .65],...
           'Callback', @setmap);    
    
   % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Explain me',...
        'Units','normalized',...
        'Position', [0.01 0.01 0.09 0.025],...
        'Callback', @explainme);       
    
    
   Vedit=uicontrol('Style','edit',...
       'Units','normalized',...
       'Position',[.02 .95 .2 .04],...
       'String',['Data from: "', buoy_id,'"']);
    
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
         
         global s
         %global L
         switch val
             case 1
                 
             hold off;
             what_wavelet = (abs(wave));  % Tsunami Amplitude
                    s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
                    L(1)=plot(time,sst,'black');
                    set(gca,'XLim',xlim(:))
                    xlabel('Time')
                    ylabel('Elev. Differences [m]')
                    title('De-tided & filtered Tsunami Signal')
                    set_label_date(ts1.time)
                    grid on
                    hold off

                    s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
                    levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
                    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time')
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
                    xlabel('Time')
                    ylabel('Elev. Differences [m]')
                    title('De-tided & filtered Tsunami Signal')
                    set_label_date(ts1.time)
                    grid on
                    hold off

                    s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
                    levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
                    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time')
                    ylabel('Period [min]')
                    title('Wavelet - Amplitude (log2)')
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
                 what_wavelet = log2(abs(wave));
                 s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
                    L(1)=plot(time,sst,'black');
                    set(gca,'XLim',xlim(:))
                    xlabel('Time')
                    ylabel('Elev. Differences [m]')
                    title('De-tided & filtered Tsunami Signal')
                    set_label_date(ts1.time)
                    grid on
                    hold off

                    s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
                    levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
                    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time')
                    ylabel('Period [min]')
                    title('Wavelet - Amplitude (log10)')
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
                 what_wavelet =(abs(wave)).^2;
                 s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
                    L(1)=plot(time,sst,'black');
                    set(gca,'XLim',xlim(:))
                    xlabel('Time')
                    ylabel('Elev. Differences [m]')
                    title('De-tided & filtered Tsunami Signal')
                    set_label_date(ts1.time)
                    grid on
                    hold off

                    s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
                    levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
                    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time')
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
             case 5
                 hold off;
                 what_wavelet =log2((abs(wave)).^2);
                 s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
                    L(1)=plot(time,sst,'black');
                    set(gca,'XLim',xlim(:))
                    xlabel('Time')
                    ylabel('Elev. Differences [m]')
                    title('De-tided & filtered Tsunami Signal')
                    set_label_date(ts1.time)
                    grid on
                    hold off

                    s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
                    levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
                    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time')
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
             case 6
                 hold off;
                 what_wavelet =log10((abs(wave)).^2);
                    s(1)=subplot('position',[0.1 0.56 0.65 0.35]);
                    L(1)=plot(time,sst,'black');
                    set(gca,'XLim',xlim(:))
                    xlabel('Time')
                    ylabel('Elev. Differences [m]')
                    title('De-tided & filtered Tsunami Signal')
                    set_label_date(ts1.time)
                    grid on
                    hold off

                    s(2)=subplot('position',[0.1 0.1 0.65 0.35]);
                    levels = [2.8,5.6,11.3,22.5,45,90]; %before: levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
                    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

                    L(2)=imagesc(time,log2(period),what_wavelet); %imagesc(time,24.*60.*(period),(what_wavelet));  %*** uncomment for 'image' plot
                    xlabel('Time')
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
        msgbox('Depending on how you plot results from the Wavelets analyses different details can be seen. The Heisenberg principle says that one cannot be simultaneously precise in the time and the frequency domain. Theoretically, the time-frequency resolution of the continuous wavelet transform is bounded by the so-called Heisenberg box. A "Heisenberg box" is located in the timefrequency plane: a rectangle with a time width and a frequency height. It represents a timefrequency localization. The area of the Heisenberg box describes the trade-off relationship between time and frequency and is minimized with the choice of the Morlet wavelet, since it is, in its essence, a Gaussian.');
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
            case 4 %'2hours'
                    interval=round(2*60/step);
                    string_type=15;
            case 5 %'6hours'
                    interval=round(6*60/step);
                    string_type=15;
            case 6 %'1day'
                    interval=round(60.*24./step);
                    string_type=1;
            case 7 %'2day'
                    interval=round(2*60.*24./step);
                    string_type=1;
          end

    labels = datestr(dn(1:interval:end), string_type);
    set(s(1), 'XTick', dn(1:interval:end));
    set(s(1), 'XTickLabel', labels);
    set(s(2), 'XTick', dn(1:interval:end));
    set(s(2), 'XTickLabel', labels);
end
end