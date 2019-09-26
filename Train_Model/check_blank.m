function blank_flag = check_blank(LOCS)
%CHECK_BLANK This function takes as an input a vector signal
%electropherogram. Outputs whether it is a blank or not based on the
%distance between peaks
%   Detailed explanation goes here
blank_flag = false;
if length(LOCS)>30
    blank_flag= true;
end
end
