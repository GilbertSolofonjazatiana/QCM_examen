package servlet;

import dao.EtudiantDAO;
import model.Examen;
import model.Question;
import util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/SoumettreExamen")
public class SoumettreExamenServlet extends HttpServlet {
    private final EtudiantDAO dao = new EtudiantDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sess = req.getSession(false);
        if (sess==null) { resp.sendRedirect(req.getContextPath()+"/index.jsp"); return; }

        String numEtu  = (String) sess.getAttribute("numEtudiant");
        String prenoms = (String) sess.getAttribute("prenoms");
        String nom     = (String) sess.getAttribute("nom");
        String email   = (String) sess.getAttribute("email");
        String niveau  = (String) sess.getAttribute("niveau");
        Examen ex      = (Examen) sess.getAttribute("examen");
        @SuppressWarnings("unchecked")
        List<Question> qs = (List<Question>) sess.getAttribute("questions");

        if (qs==null||ex==null||ex.isTermine()) {
            resp.sendRedirect(req.getContextPath()+"/pages/etudiant/accueil.jsp"); return;
        }
        int correct = 0;
        for (int i=0; i<qs.size(); i++) {
            String p = req.getParameter("q"+i);
            if (p!=null) {
                int rep = Integer.parseInt(p);
                qs.get(i).setReponseDonnee(rep);
                if (rep==qs.get(i).getBonneReponse()) correct++;
            }
        }
        double note = correct;
        try {
            dao.soumettreResultat(ex.getNumExamen(), note);
            ex.setStatut("termine"); ex.setNote(BigDecimal.valueOf(note));
            sess.setAttribute("examen",ex); sess.setAttribute("statut","termine");
            sess.setAttribute("questions",qs); sess.setAttribute("noteFinale",note);
            sess.removeAttribute("startTime");
            final String fullName = prenoms+" "+nom;
            new Thread(()->EmailUtil.envoyerResultat(email,fullName,niveau,note,"2023-2024")).start();
            resp.sendRedirect(req.getContextPath()+"/pages/etudiant/resultat.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()+"/pages/etudiant/accueil.jsp?err=2");
        }
    }
}
