classdef MongoBaseRepository
    %MONGOBASEREPOSITORY Summary of this class goes here
    %   Detailed explanation goes here
    
    
        
    properties 
        MongoConnection mongo
        MongoCollection string
    end
    
    methods
        function obj = MongoBaseRepository(server,databaseName,port,collectionName,userName,password)
            %MONGOBASEREPOSITORY Construct an instance of this class
            %   Detailed explanation goes here
            %server should be of the format: 'localhost' or '34.65.235.92'                      
            conn = mongo(server,port,"admin","UserName",userName,"Password",password);
            conn.changeDB(databaseName);
            obj.MongoCollection = collectionName;
            obj.MongoConnection = conn;          
            %obj.MongoConnection.createCollection(collectionName);
        end        
        function noDocsInserted = insert(obj,entity)
            %Insert one or multiple documents in table format
            noDocsInserted = obj.MongoConnection.insert(obj.MongoCollection,entity);
        end
    end
end

