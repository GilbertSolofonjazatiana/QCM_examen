package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL  = "jdbc:postgresql://localhost:5432/qcm_univ";
    private static final String USER = "postgres";
    private static final String PASS = "votre_mot_de_passe";

    static {
        try { Class.forName("org.postgresql.Driver"); }
        catch (ClassNotFoundException e) { throw new RuntimeException("Driver PostgreSQL introuvable", e); }
    }

    public static Connection get() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    private DBConnection() {}
}
