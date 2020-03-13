function n = UpdateMany(table_)
%UPDATEMANY Function updates table with corresponding peak positions
%   Returns number of succesfully updated documents

%Connect to MongoDB
conn = DBConnect();
%Cast into array
tabmatrix = table2array(table_);
n=0;
%Iterate over rows of the table
for row= 1:height(table_)
    
    %Find document in DB based on the filename
    findquery = sprintf('{"filename": /%s/i}',...
        table_.Properties.RowNames{row});
    
    %filter values that are not 0
    peaks = tabmatrix(row,tabmatrix(row,:)~=0);
    
    %Update query
    if isempty(peaks)
        updatequery = sprintf('{$set:{"peak_pos":[0]}}');
        
    else
        % list the positions and separate them by commas
        updateString = sprintf('%d,',peaks);
        updateString = updateString(1:end-1);
        updatequery = sprintf('{$set:{"peak_pos":[%s]}}',updateString);
    end
    
    %Insert update
    val = conn.update('signals',findquery,updatequery);
    if (val==0)
        sprintf('%d',row);
    end
    n=n+val;
end

