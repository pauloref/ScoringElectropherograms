function Fig = plot(Obj,channels, cols)
%Fig=figure;
hold on;

switch nargin
    case 1
        cols=['b' 'r' 'g' 'k'];
        channels=[1 2 3 4];
        
    case 2
        cols=['b' 'r' 'g' 'k'];
        
end

for i = channels
    plot(Obj.Read,Obj.Data(:,i),cols(i));
end
end