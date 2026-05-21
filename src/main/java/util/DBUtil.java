package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
        		"jdbc:mysql://localhost:3306/miniopgg?serverTimezone=Asia/Seoul&characterEncoding=UTF-8",
        		"root",
        		"123456"
        );
    }
}