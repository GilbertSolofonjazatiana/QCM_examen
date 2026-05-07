package servlet;

import dao.EtudiantDAO;
import model.Etudiant;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/InscriptionServlet")
public class InscriptionServlet extends HttpServlet {
    private final EtudiantDAO dao = new EtudiantDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nom    = req.getParameter("nom");
        String prenom = req.getParameter("prenoms");
        String niveau = req.getParameter("niveau");
        String email  = req.getParameter("email");
        String num    = req.getParameter("numEtudiant");

        if (nom==null||nom.isBlank()||prenom==null||prenom.isBlank()||
            niveau==null||niveau.isBlank()||email==null||email.isBlank()||num==null||num.isBlank()) {
            req.setAttribute("error","Veuillez remplir tous les champs.");
            req.getRequestDispatcher("/pages/inscription.jsp").forward(req,resp); return;
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            req.setAttribute("error","Adresse email invalide.");
            req.getRequestDispatcher("/pages/inscription.jsp").forward(req,resp); return;
        }
        try {
            if (dao.emailExiste(email)) {
                req.setAttribute("error","Cet email est déjà utilisé.");
                req.getRequestDispatcher("/pages/inscription.jsp").forward(req,resp); return;
            }
            Etudiant e = new Etudiant(num,nom,prenom,niveau,email,"etudiant");
            dao.inscrire(e);
            resp.sendRedirect(req.getContextPath()+"/index.jsp?msg=inscrit");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error","Erreur : "+e.getMessage());
            req.getRequestDispatcher("/pages/inscription.jsp").forward(req,resp);
        }
    }
}
