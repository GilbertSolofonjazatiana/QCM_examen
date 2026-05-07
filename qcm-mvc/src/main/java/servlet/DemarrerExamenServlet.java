package servlet;

import dao.EtudiantDAO;
import dao.QuestionDAO;
import model.Examen;
import model.Question;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DemarrerExamen")
public class DemarrerExamenServlet extends HttpServlet {
    private final EtudiantDAO eDao = new EtudiantDAO();
    private final QuestionDAO qDao = new QuestionDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sess = req.getSession(false);
        if (sess==null) { resp.sendRedirect(req.getContextPath()+"/index.jsp"); return; }
        String numEtu = (String) sess.getAttribute("numEtudiant");
        String niveau = (String) sess.getAttribute("niveau");
        try {
            Examen ex = eDao.getExamen(numEtu);
            if (ex.isTermine()) { resp.sendRedirect(req.getContextPath()+"/pages/etudiant/resultat.jsp"); return; }
            List<Question> qs = qDao.tirerAleatoire(niveau, 10);
            eDao.demarrerExamen(ex.getNumExamen());
            ex.setStatut("en_cours");
            sess.setAttribute("examen",ex);
            sess.setAttribute("statut","en_cours");
            sess.setAttribute("questions",qs);
            sess.setAttribute("startTime",System.currentTimeMillis());
            sess.setAttribute("duration",20*60*1000L);
            resp.sendRedirect(req.getContextPath()+"/pages/etudiant/exam.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()+"/pages/etudiant/accueil.jsp?err=1");
        }
    }
}
