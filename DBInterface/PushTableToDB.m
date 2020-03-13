function conn = PushTableToDB(table_)
%% Function that allows us to push a csv table into mongoDB
% 
%server = "dbtb01";


count = conn.insert('signals',table_);
fprintf("Success connecting. A total of %d documents were added to the database\n",count);
end