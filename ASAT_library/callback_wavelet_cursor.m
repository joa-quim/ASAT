function output_txt = myfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');

%vector_date=datevec(pos(1));

output_txt = {['T: ',sprintf('%s',datestr(pos(1)))],...
    ['Period: ',num2str(24.*60.*2.^pos(2),4), ' [min]']};
% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end