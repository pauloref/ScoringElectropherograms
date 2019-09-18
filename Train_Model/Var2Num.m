function time_vec = Var2Num(var_names)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
time_vec = split(string(var_names),'_');
time_vec = time_vec (1,:,2);
time_vec = str2double(time_vec);

end

