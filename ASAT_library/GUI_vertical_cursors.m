function GUI_vertical_cursors
set(gcf, ...
   'WindowButtonDownFcn', @clickFcn, ...
   'WindowButtonUpFcn', @unclickFcn);
% Set up cursor text
allLines = findobj(gcf, 'type', 'line');
hText = nan(1, length(allLines));
hTextWave = nan(1, length(allLines));

for id = 1:length(allLines)
   hText(id) = text(NaN, NaN, '', ...
      'Parent', get(allLines(id), 'Parent'), ...
      'BackgroundColor', 'yellow', ...
      'Color', get(allLines(id), 'Color'));
end

hTextWave = text(NaN, NaN, '', ...
      'Parent', get(allLines(id), 'Parent'), ...
      'BackgroundColor', 'yellow', ...
      'Color', get(allLines(id), 'Color'));

% Set up cursor lines
allAxes = findobj(gcf, 'Type', 'axes');
hCur = nan(1, length(allAxes));
for id = 1:length(allAxes)
   hCur(id) = line([NaN NaN], ylim(allAxes(id)), ...
      'Color', 'red', 'Parent', allAxes(id));
end

  % Identity table
  % allAxes(1) - Global Wavelet Spectrum
  % allAxes(3) - Wavelet Spectrum
  

     function clickFcn(varargin)
        % Initiate cursor if clicked anywhere but the figure
        if strcmpi(get(gco, 'type'), 'figure')
           set(hCur, 'XData', [NaN NaN]);                % <-- EDIT
           set(hText, 'Position', [NaN NaN]);            % <-- EDIT
          
        else
           set(gcf, 'WindowButtonMotionFcn', @dragFcn)
           dragFcn()
        end
     end
     function dragFcn(varargin)
        % Get mouse location
        pt = get(gca, 'CurrentPoint');
        % Update cursor line position
        set(hCur, 'XData', [pt(1), pt(1)]);
        
        % allLines(8) is polynomial
        % allLines(9) is the time series ts1 (original interpolated data)
        % Update cursor text
        %for idx = 1:length(allLines)
            % Subplot 1
           xdata = get(allLines(9), 'XData');
           ydata = get(allLines(9), 'YData');   
           
           detided_xdata = get(allLines(6), 'XData'); % the detided Signal
           dedited_ydata = get(allLines(6), 'YData'); % the detided Signal
          % allLines(2)
           if pt(1) >= xdata(1) && pt(1) <= xdata(end)
              y = interp1(xdata, ydata, pt(1));
              detided_y = interp1(detided_xdata, dedited_ydata, pt(1));
              
              set(hText(1), 'Position', [pt(1)+0.01, 8], ...
                 'String', {['Time: ',sprintf('%s',datestr(pt(1)))];...
                 ['elev: ',sprintf('%3.3g',y),' [m]'];...
                 ['de-tided: ',sprintf('%3.3g',detided_y),' [m]']});
            
           else
             % set(hText(1), 'Position', [NaN NaN]);
           end
            % Subplot 2
           xdata = get(allLines(2), 'XData');
           y_tmp=pt(3);
           ydata = 24.*60.*2.^pt(3)%get(allLines(2), 'YData');
          
            %set(allLines(2), 'Pointer', 'fullcrosshair')
           if pt(1) >= xdata(1) && pt(1) <= xdata(end)
              y = ydata; %interp1(xdata, ydata, pt(1));
              
              set(hTextWave, 'Position', [pt(1), y_tmp+0.3], ...
                 'String', {['T: ',sprintf('%s',datestr(pt(1)))];...
                ['P: ',sprintf('%3.3g',y), ' [min]']});
           else
              set(hTextWave, 'Position', [NaN NaN]);
           end
            % Subplot 3  - Este ? o plot de cima 
           xdata = get(allLines(6), 'XData'); % the detided Signal
           ydata = get(allLines(6), 'YData'); % the detided Signal
           if pt(1) >= xdata(1) && pt(1) <= xdata(end)
              y = interp1(xdata, ydata, pt(1));
              %pt(1)
%               if exist('mark') ~= 0
%               clear mark;
%               end
              set(hText(3), 'Position', [pt(1), 3], ...
                 'String', {['Y: ',sprintf('%3.3g',y), ' [m]']});
%             hold on
%             mark=plot(pt(1),y,'*k');
%             hold off
           else
              set(hText(3), 'Position', [NaN NaN]);
           end
        %end
     end
     function unclickFcn(varargin)
        set(gcf, 'WindowButtonMotionFcn', '');
     end
end