% set label for x date series
% You should edit this function if you need to change the scale in the
% stacked plots (signal + Wavelet)
function set_label_date(dn)

dt=dn(end)-dn(1);

hours_long=24.*dt;


labels = datestr(dn(1:60:end), 15);
set(gca, 'XTick', dn(1:60:end));
set(gca, 'XTickLabel', labels);
end