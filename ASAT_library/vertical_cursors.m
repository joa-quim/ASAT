function vertical_cursors
set(gcf, ...
   'WindowButtonDownFcn', @clickFcn, ...
   'WindowButtonUpFcn', @unclickFcn);
% Set up cursor text
allLines = findobj(gcf, 'type', 'line');
hText = nan(1, length(allLines));


for id = 1:length(allLines)
   hText(id) = text(NaN, NaN, '', ...
      'Parent', get(allLines(id), 'Parent'), ...
      'BackgroundColor', 'yellow', ...
      'Color', get(allLines(id), 'Color'));
end
% Set up cursor lines
allAxes = findobj(gcf, 'Type', 'axes');
hCur = nan(1, length(allAxes));
for id = 1:length(allAxes)
   hCur(id) = line([NaN NaN], ylim(allAxes(id)), ...
      'Color', 'red', 'Parent', allAxes(id));
end

hhCur = line(xlim(allAxes(1)), [NaN NaN], ...
      'Color', 'red', 'Parent', allAxes(1));
hhCur_wavelet = line(xlim(allAxes(3)), [NaN NaN], ...
      'Color', 'red', 'Parent', allAxes(3));
  
  % Identity table
  % allAxes(1) - Global Wavelet Spectrum
  % allAxes(3) - Wavelet Spectrum
  

     function clickFcn(varargin)
        % Initiate cursor if clicked anywhere but the figure
        if strcmpi(get(gco, 'type'), 'figure')
           set(hCur, 'XData', [NaN NaN]);                % <-- EDIT
           set(hText, 'Position', [NaN NaN]);            % <-- EDIT
           set(hhCur, 'YData', [NaN NaN]);            % <-- EDIT
           set(hhCur_wavelet, 'YData', [NaN NaN]);            % <-- EDIT
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
        set(hhCur, 'YData', [pt(3), pt(3)]);
        set(hhCur_wavelet, 'YData', [pt(3), pt(3)]);
        
        
        % Update cursor text
        %for idx = 1:length(allLines)
            % Subplot 1
           xdata = get(allLines(1), 'XData');
           ydata = get(allLines(1), 'YData');          
           if pt(3) >= ydata(1) && pt(3) <= ydata(end)
              x = interp1(ydata, xdata, pt(3));
              
              set(hText(1), 'Position', [x+0.000005, pt(3)+0.2], ...
                 'String', {['T: ',sprintf('%3.3g',x)]});
            
           else
             % set(hText(1), 'Position', [NaN NaN]);
           end
            % Subplot 2
           xdata = get(allLines(2), 'XData');
           y_tmp=pt(3);
           ydata = 24.*60.*2.^pt(3);%get(allLines(2), 'YData');
          
            %set(allLines(2), 'Pointer', 'fullcrosshair')
           if pt(1) >= xdata(1) && pt(1) <= xdata(end)
              y = ydata; %interp1(xdata, ydata, pt(1));
              
              set(hText(2), 'Position', [pt(1)+0.002, y_tmp+0.3], ...
                 'String', {['T: ',sprintf('%s',datestr(pt(1)))];...
                ['P: ',sprintf('%3.3g',y), ' [min]']});
           else
              set(hText(2), 'Position', [NaN NaN]);
           end
            % Subplot 3  - Este ? o plot de cima 
           xdata = get(allLines(3), 'XData');
           ydata = get(allLines(3), 'YData');
           if pt(1) >= xdata(1) && pt(1) <= xdata(end)
              y = interp1(xdata, ydata, pt(1));
%               if exist('mark') ~= 0
%               clear mark;
%               end
              set(hText(3), 'Position', [pt(1)+0.002, y], ...
                 'String', {['T: ',sprintf('%s',datestr(pt(1)))];...
                ['Y: ',sprintf('%3.3g',y), ' [m]']});
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