package dao;

import config.DBConnection;
import model.Question;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public List<Question> tirerAleatoire(String niveau, int n) throws SQLException {
        String niveaux = switch(niveau) {
            case "L1" -> "('L1')";
            case "L2" -> "('L1','L2')";
            case "L3" -> "('L1','L2','L3')";
            case "M1" -> "('L1','L2','L3','M1')";
            case "M2" -> "('L1','L2','L3','M1','M2')";
            default   -> "('L1')";
        };
        String sql="SELECT * FROM QCM WHERE qcm_niveau IN "+niveaux+" ORDER BY RANDOM() LIMIT ?";
        List<Question> list=new ArrayList<>();
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            ps.setInt(1,n); ResultSet rs=ps.executeQuery(); while(rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<Question> lister(String niveau) throws SQLException {
        String sql="SELECT * FROM QCM"+(niveau!=null&&!niveau.isBlank()?" WHERE qcm_niveau=?":"")+" ORDER BY qcm_niveau,num_question";
        List<Question> list=new ArrayList<>();
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            if (niveau!=null&&!niveau.isBlank()) ps.setString(1,niveau);
            ResultSet rs=ps.executeQuery(); while(rs.next()) list.add(map(rs));
        }
        return list;
    }

    public void ajouter(Question q) throws SQLException {
        String sql="INSERT INTO QCM(question,reponse1,reponse2,reponse3,reponse4,bonne_reponse,qcm_niveau) VALUES(?,?,?,?,?,?,?)";
        try (Connection cn=DBConnection.get(); PreparedStatement ps=cn.prepareStatement(sql)) {
            ps.setString(1,q.getQuestion()); ps.setString(2,q.getReponse1());
            ps.setString(3,q.getReponse2()); ps.setString(4,q.getReponse3());
            ps.setString(5,q.getReponse4()); ps.setInt(6,q.getBonneReponse());
            ps.setString(7,q.getQcmNiveau()); ps.executeUpdate();
        }
    }

    public void supprimer(int id) throws SQLException {
        try (Connection cn=DBConnection.get();
             PreparedStatement ps=cn.prepareStatement("DELETE FROM QCM WHERE num_question=?")) {
            ps.setInt(1,id); ps.executeUpdate();
        }
    }

    public int compter() throws SQLException {
        try (Connection cn=DBConnection.get(); Statement st=cn.createStatement();
             ResultSet rs=st.executeQuery("SELECT COUNT(*) FROM QCM")) {
            return rs.next()?rs.getInt(1):0;
        }
    }

    private Question map(ResultSet rs) throws SQLException {
        Question q=new Question();
        q.setNumQuestion(rs.getInt("num_question")); q.setQuestion(rs.getString("question"));
        q.setReponse1(rs.getString("reponse1"));     q.setReponse2(rs.getString("reponse2"));
        q.setReponse3(rs.getString("reponse3"));     q.setReponse4(rs.getString("reponse4"));
        q.setBonneReponse(rs.getInt("bonne_reponse"));q.setQcmNiveau(rs.getString("qcm_niveau"));
        return q;
    }
}
