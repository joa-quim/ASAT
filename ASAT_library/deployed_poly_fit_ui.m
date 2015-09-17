function deployed_poly_fit_ui(ts,ts1)
    %ts=evalin('base','ts');
    %ts1=evalin('base','ts1');
    % Create a figure and axes
    
    
    f = figure('name','Polynomial Fitting Interface','Visible','on');
    %ax = axes('Units','pixels');
    %surf(peaks)
    
    % Create pop-up menu
    popup = uicontrol('Style', 'popup',...
           'String', {'Resampled','Raw Data'},...
           'Position', [20 340 100 50],...
           'Callback', @setmap);    
    
   % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Explain me',...
        'Position', [20 20 50 20],...
        'Callback', @explainme);       

   % Create slider
    sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',20,'Value',6,...
        'SliderStep',[1/20,1/20],...
        'Position', [400 20 120 20],...
        'Callback', @surfzlim); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[400 45 120 20],...
        'String','Degree of Polynom');
    
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
    
    function [time,data]=setmap(source,callbackdata)
        %val = source.Value;
        %maps = source.String;
        % For R2014a and earlier: 
         val = get(source,'Value');
         maps = get(source,'String'); 
         
         
         if val == 1
             hold off;
             
             time=(ts1.Time-ts1.Time(1))*(24.*60.);
             data=ts1.Data;
             plot(time,data);
             %set_label_data(ts1.Time);
         else
             hold off;
             
             time=(ts.Time-ts.Time(1))*(24.*60.);
             data=ts.Data;
             plot(time,data);
             %Vedit=uicontrol('Style','edit','String',['variable=',num2str(val)]);
             %set_label_data(ts.Time);
         end
        
       % newmap = maps{val};
       % colormap(newmap);
    end

    function surfzlim(source,callbackdata)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        val = get(source,'Value');
        %get(source,'Value')
        degree=round(get(source,'Value'));
        Vedit=uicontrol('Style','edit','String',['degree=',num2str(degree)]);
        [time,data]=setmap(source,callbackdata);
        [polynom,detided_signal,delta_detiding]=detide(time,data, degree);
        
      
        subplot(3,1,1);
        plot(time,data,'b');
        grid on;
        hold on;
        plot(time,polynom,'black');
        hold off;
        subplot(3,1,2);
        plot(time,detided_signal,'green');
        grid on;
        subplot(3,1,3);
        plot(time,delta_detiding,'red');
        grid on;
        hold off;
        Vedit2=uicontrol('Style','edit','Position',[400 65 120 20],'String',['av_delta=',num2str(mean(delta_detiding))]);
    end

    function explainme(source,callbackdata)
        msgbox('Taking off the tide from water column heights is trickier than it seams. Here you can assess the quality of the polynomial fitting. You will be provided with three plots. One for the selected data and polynom, one to see the result of the de-tiding and a third where the differences between signal-polynom are shown. ');
    end
end