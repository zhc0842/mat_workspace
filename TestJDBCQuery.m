function [] = TestJDBCQuery()

end

function [] = TestJDBCInsert()
    conn = database('DB','user','pwd','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://127.0.0.1:1433;databaseName=DB');
    if isconnection(conn) == 1 ,%������1����Ϊ���ӳɹ�
        exdata = {'San Diego', 88;'Smith Jhon',99};%����һ�����飬���Կ��ǲ���֮ǰһֱ���õ����ݣ���ǰ����һ��flag
        colnames = {'City', 'Avg_Temp'};
        fastinsert(conn, 'Temperatures', colnames, exdata);
    end
    close(conn);
end