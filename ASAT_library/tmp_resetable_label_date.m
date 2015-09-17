% set label for x date series
% You should edit this function if you need to change the scale in the
% stacked plots (signal + Wavelet)
function tmp_resetable_label_date(dn,step,tick_type)

dt=dn(end)-dn(1);
switch tick_type
    case '15min'
        interval=round(15/step);
        string_type=15;
    case '30min'
        interval=round(30/step);
        string_type=15;
    case '1hour'
        interval=round(60/step);
        string_type=15;
    case '1day'
        interval=round(60.*24./step);
        string_type=1;
end

    labels = datestr(dn(1:interval:end), string_type);
    set(gca, 'XTick', dn(1:interval:end));
    set(gca, 'XTickLabel', labels);
end