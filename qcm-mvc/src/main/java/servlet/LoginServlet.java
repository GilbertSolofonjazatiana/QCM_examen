package servlet;

import dao.EtudiantDAO;
import model.Etudiant;
import model.Examen;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final EtudiantDAO dao = new EtudiantDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");
        if (email==null||pass==null||email.isBlank()||pass.isBlank()) {
            req.setAttribute("error","Veuillez remplir tous les champs.");
            req.getRequestDispatcher("/index.jsp").forward(req,resp); return;
        }
        try {
            Etudiant u = dao.login(email,pass);
            if (u==null) {
                req.setAttribute("error","Email ou mot de passe incorrect.");
                req.getRequestDispatcher("/index.jsp").forward(req,resp); return;
            }
            HttpSession sess = req.getSession(true);
            sess.setAttribute("user",u);
            sess.setAttribute("role",u.getRole());
            sess.setAttribute("numEtudiant",u.getNumEtudiant());
            sess.setAttribute("nom",u.getNom());
            sess.setAttribute("prenoms",u.getPrenoms());
            sess.setAttribute("niveau",u.getNiveau());
            sess.setAttribute("email",u.getAdrEmail());

            if ("admin".equals(u.getRole())) {
                resp.sendRedirect(req.getContextPath()+"/pages/admin/dashboard.jsp");
            } else {
                Examen ex = dao.getExamen(u.getNumEtudiant());
                sess.setAttribute("examen",ex);
                sess.setAttribute("statut",ex.getStatut());
                resp.sendRedirect(req.getContextPath()+"/pages/etudiant/accueil.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error","Erreur serveur, réessayez.");
            req.getRequestDispatcher("/index.jsp").forward(req,resp);
        }
    }
}
