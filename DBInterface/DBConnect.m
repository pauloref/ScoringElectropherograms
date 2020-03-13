function conn = DBConnect()
%DBCONNECT It connects us to the DB 
%   Contains credentials to enter the DB
server = {'34.65.235.92'};
port = 27017;
dbname = "electropherograms";
conn = mongo(server,port,"admin","UserName","remanalytics","Password","Q!W@E#R$T%");
conn.Database = dbname;
end

