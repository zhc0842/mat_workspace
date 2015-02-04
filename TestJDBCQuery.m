function [] = TestJDBCQuery()

end

function [] = TestJDBCInsert()
    conn = database('DB','user','pwd','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://127.0.0.1:1433;databaseName=DB');
    if isconnection(conn) == 1 ,%若返回1则认为连接成功
        exdata = {'San Diego', 88;'Smith Jhon',99};%插入一个数组，可以考虑插入之前一直可用的数据，提前设置一个flag
        colnames = {'City', 'Avg_Temp'};
        fastinsert(conn, 'Temperatures', colnames, exdata);
    end
    close(conn);
end