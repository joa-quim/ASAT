function output_txt = callback_periodogram_cursor(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).


pos = get(event_obj,'Position');

period=((pos(1)));
%period=10^(1./pos(1)/60./10.);

output_txt = {['Period: ',num2str(period),' min'],...
    ['Value: ',num2str(pos(2),4), ' dB']};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str((pos(3)),4)];
end

end