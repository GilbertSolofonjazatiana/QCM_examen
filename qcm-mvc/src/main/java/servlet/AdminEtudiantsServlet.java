package servlet;

import dao.EtudiantDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet optionnelle — centralise les actions admin sur les étudiants.
 * Pour l'instant : réinitialiser le statut examen d'un étudiant.
 */
@WebServlet("/AdminEtudiantsServlet")
public class AdminEtudiantsServlet extends HttpServlet {

    private final EtudiantDAO dao = new EtudiantDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action    = req.getParameter("action");
        String ctx       = req.getContextPath();
        String numEtu    = req.getParameter("numEtudiant");

        try {
            if ("reinitialiser".equals(action) && numEtu != null && !numEtu.isBlank()) {
                dao.reinitialiserExamen(numEtu);
                resp.sendRedirect(ctx + "/pages/admin/etudiants.jsp?msg=reinit");
            } else {
                resp.sendRedirect(ctx + "/pages/admin/etudiants.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(ctx + "/pages/admin/etudiants.jsp?err=1");
        }
    }
}
