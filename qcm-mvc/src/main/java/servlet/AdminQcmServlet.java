package servlet;

import dao.QuestionDAO;
import model.Question;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminQcmServlet")
public class AdminQcmServlet extends HttpServlet {
    private final QuestionDAO dao = new QuestionDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String ctx    = req.getContextPath();
        try {
            if ("ajouter".equals(action)) {
                Question q = new Question();
                q.setQuestion(req.getParameter("question"));
                q.setReponse1(req.getParameter("reponse1")); q.setReponse2(req.getParameter("reponse2"));
                q.setReponse3(req.getParameter("reponse3")); q.setReponse4(req.getParameter("reponse4"));
                q.setBonneReponse(Integer.parseInt(req.getParameter("bonneReponse")));
                q.setQcmNiveau(req.getParameter("niveau"));
                if (q.getQuestion()==null||q.getQuestion().isBlank()||
                    q.getReponse1()==null||q.getReponse1().isBlank()) {
                    resp.sendRedirect(ctx+"/pages/admin/qcm.jsp?err=champs"); return;
                }
                dao.ajouter(q);
                resp.sendRedirect(ctx+"/pages/admin/qcm.jsp?msg=ajoute");
            } else if ("supprimer".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.supprimer(id);
                resp.sendRedirect(ctx+"/pages/admin/qcm.jsp?msg=supprime");
            } else {
                resp.sendRedirect(ctx+"/pages/admin/qcm.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(ctx+"/pages/admin/qcm.jsp?err=1");
        }
    }
}
