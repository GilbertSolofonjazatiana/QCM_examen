package dao;

import config.DBConnection;
import model.Etudiant;
import model.Examen;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EtudiantDAO {

    public Etudiant login(String email, String pass) throws SQLException {
        String sql = """
            SELECT e.num_etudiant,e.nom,e.prenoms,e.niveau,e.adr_email,l.role
            FROM ETUDIANT e JOIN LOGIN l ON l.num_etudiant=e.num_etudiant
            WHERE LOWER(e.adr_email)=LOWER(?) AND l.mot_de_passe=?
            """;
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            ps.setString(1,email.trim()); ps.setString(2,pass.trim());
            ResultSet rs=ps.executeQuery();
            return rs.next() ? mapEtu(rs) : null;
        }
    }

    public boolean emailExiste(String email) throws SQLException {
        try (Connection cn=DBConnection.get();
             PreparedStatement ps=cn.prepareStatement("SELECT 1 FROM ETUDIANT WHERE LOWER(adr_email)=LOWER(?)")) {
            ps.setString(1,email); return ps.executeQuery().next();
        }
    }

    public void inscrire(Etudiant e) throws SQLException {
        try (Connection cn=DBConnection.get()) {
            cn.setAutoCommit(false);
            try {
                try (PreparedStatement ps=cn.prepareStatement(
                        "INSERT INTO ETUDIANT(num_etudiant,nom,prenoms,niveau,adr_email) VALUES(?,?,?,?,?)")) {
                    ps.setString(1,e.getNumEtudiant()); ps.setString(2,e.getNom().toUpperCase());
                    ps.setString(3,e.getPrenoms());     ps.setString(4,e.getNiveau());
                    ps.setString(5,e.getAdrEmail().toLowerCase()); ps.executeUpdate();
                }
                try (PreparedStatement ps=cn.prepareStatement(
                        "INSERT INTO LOGIN(num_etudiant,mot_de_passe,role) VALUES(?,'etudiant')")) {
                    // mot de passe = num_etudiant
                }
                // Correction : INSERT correct
                try (PreparedStatement ps=cn.prepareStatement(
                        "INSERT INTO LOGIN(num_etudiant,mot_de_passe,role) VALUES(?,?,'etudiant')")) {
                    ps.setString(1,e.getNumEtudiant()); ps.setString(2,e.getNumEtudiant()); ps.executeUpdate();
                }
                try (PreparedStatement ps=cn.prepareStatement(
                        "INSERT INTO EXAMEN(num_etudiant,anne_univ,statut) VALUES(?,'2023-2024','non_passe')")) {
                    ps.setString(1,e.getNumEtudiant()); ps.executeUpdate();
                }
                cn.commit();
            } catch (SQLException ex) { cn.rollback(); throw ex; }
        }
    }

    public Examen getExamen(String numEtu) throws SQLException {
        String sql="SELECT * FROM EXAMEN WHERE num_etudiant=? AND anne_univ='2023-2024' ORDER BY num_examen DESC LIMIT 1";
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            ps.setString(1,numEtu); ResultSet rs=ps.executeQuery();
            if (rs.next()) return mapExamen(rs);
        }
        // Créer si absent
        try (Connection cn=DBConnection.get();
             PreparedStatement ps=cn.prepareStatement(
                "INSERT INTO EXAMEN(num_etudiant,anne_univ,statut) VALUES(?,'2023-2024','non_passe')")) {
            ps.setString(1,numEtu); ps.executeUpdate();
        }
        return getExamen(numEtu);
    }

    public void demarrerExamen(int numExamen) throws SQLException {
        exec("UPDATE EXAMEN SET statut='en_cours' WHERE num_examen=?", numExamen);
    }

    public void soumettreResultat(int numExamen, double note) throws SQLException {
        try (Connection cn=DBConnection.get();
             PreparedStatement ps=cn.prepareStatement(
                "UPDATE EXAMEN SET note=?,statut='termine' WHERE num_examen=?")) {
            ps.setBigDecimal(1,BigDecimal.valueOf(note)); ps.setInt(2,numExamen); ps.executeUpdate();
        }
    }

    public List<Etudiant> listerEtudiants(String niveau) throws SQLException {
        String sql="SELECT e.num_etudiant,e.nom,e.prenoms,e.niveau,e.adr_email,l.role FROM ETUDIANT e JOIN LOGIN l ON l.num_etudiant=e.num_etudiant WHERE l.role='etudiant'"
                  +(niveau!=null&&!niveau.isBlank()?" AND e.niveau=?":"")+" ORDER BY e.niveau,e.nom";
        List<Etudiant> list=new ArrayList<>();
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            if (niveau!=null&&!niveau.isBlank()) ps.setString(1,niveau);
            ResultSet rs=ps.executeQuery(); while(rs.next()) list.add(mapEtu(rs));
        }
        return list;
    }

    public List<Object[]> classement(String niveau) throws SQLException {
        String sql="SELECT e.num_etudiant,e.nom,e.prenoms,e.niveau,e.adr_email,ex.note FROM ETUDIANT e JOIN EXAMEN ex ON ex.num_etudiant=e.num_etudiant JOIN LOGIN l ON l.num_etudiant=e.num_etudiant WHERE l.role='etudiant' AND ex.statut='termine' AND ex.note IS NOT NULL"
                  +(niveau!=null&&!niveau.isBlank()?" AND e.niveau=?":"")+" ORDER BY ex.note DESC";
        List<Object[]> list=new ArrayList<>();
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            if (niveau!=null&&!niveau.isBlank()) ps.setString(1,niveau);
            ResultSet rs=ps.executeQuery();
            while(rs.next()) list.add(new Object[]{rs.getString("num_etudiant"),rs.getString("nom"),rs.getString("prenoms"),rs.getString("niveau"),rs.getString("adr_email"),rs.getBigDecimal("note")});
        }
        return list;
    }

    public int countEtudiants() throws SQLException {
        try (Connection cn=DBConnection.get(); Statement st=cn.createStatement();
             ResultSet rs=st.executeQuery("SELECT COUNT(*) FROM LOGIN WHERE role='etudiant'")) {
            return rs.next()?rs.getInt(1):0;
        }
    }

    public int countExamensTermines() throws SQLException {
        try (Connection cn=DBConnection.get(); Statement st=cn.createStatement();
             ResultSet rs=st.executeQuery("SELECT COUNT(*) FROM EXAMEN WHERE statut='termine'")) {
            return rs.next()?rs.getInt(1):0;
        }
    }

    public double moyenneGenerale() throws SQLException {
        try (Connection cn=DBConnection.get(); Statement st=cn.createStatement();
             ResultSet rs=st.executeQuery("SELECT COALESCE(AVG(note),0) FROM EXAMEN WHERE statut='termine'")) {
            return rs.next()?rs.getDouble(1):0;
        }
    }

    /** Réinitialise l'examen d'un étudiant (admin only) */
    public void reinitialiserExamen(String numEtu) throws SQLException {
        String sql = "UPDATE EXAMEN SET statut='non_passe', note=NULL WHERE num_etudiant=? AND anne_univ='2023-2024'";
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            ps.setString(1, numEtu); ps.executeUpdate();
        }
    }

    private Etudiant mapEtu(ResultSet rs) throws SQLException {
        return new Etudiant(rs.getString("num_etudiant"),rs.getString("nom"),rs.getString("prenoms"),
                            rs.getString("niveau"),rs.getString("adr_email"),rs.getString("role"));
    }
    private Examen mapExamen(ResultSet rs) throws SQLException {
        Examen ex=new Examen(); ex.setNumExamen(rs.getInt("num_examen"));
        ex.setNumEtudiant(rs.getString("num_etudiant")); ex.setAnneUniv(rs.getString("anne_univ"));
        ex.setNote(rs.getBigDecimal("note")); ex.setStatut(rs.getString("statut")); return ex;
    }
    private void exec(String sql, int id) throws SQLException {
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            ps.setInt(1,id); ps.executeUpdate();
        }
    }
}
