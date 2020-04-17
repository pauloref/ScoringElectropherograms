x = 1:size(signal_array,2);
x = 1499 + x;
for i = 1:size(signal_array,1)
   signal = signal_array(i,:);
   ipeak(x,signal);
end