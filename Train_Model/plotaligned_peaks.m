%% plot peaks
close all

start_val = 100; % index of starting row
vec = start_val:12:start_val+7*12;
prominence = 250;
for i =1:length(vec)
    try
        plot(time_values.(vec(i)),train_data.(vec(i)))
        [PKS,LOCS,W,P] = findpeaks(train_data.(vec(i)),time_values.(vec(i)),'MinPeakProminence',prominence);
        findpeaks(train_data.(vec(i)),time_values.(vec(i)),'MinPeakProminence',prominence);
    catch
        break;
    end
    legend(time_values.Properties.VariableNames(vec(1:i)));
    hold on
end
legend(time_values.Properties.VariableNames(vec(1:i)));
hold off