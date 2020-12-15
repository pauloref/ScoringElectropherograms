function conn = PushTableToDB(table_)
%% Function that allows us to push a csv table into mongoDB
% 
%server = "dbtb01";

server = {'34.65.235.92'};
port = 27017;
dbname = "electropherograms";
conn = mongo(server,port,"admin","UserName","remanalytics","Password","Q!W@E#R$T%");
conn.Database = dbname;
count = conn.insert('signals',table_);
fprintf("Success connecting. A total of %d documents were added to the database\n",count);
end