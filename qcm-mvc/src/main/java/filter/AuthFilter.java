package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/pages/*")
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  hReq  = (HttpServletRequest)  req;
        HttpServletResponse hResp = (HttpServletResponse) resp;
        HttpSession         sess  = hReq.getSession(false);
        String ctx = hReq.getContextPath();
        String uri = hReq.getRequestURI();
        String role   = sess!=null?(String)sess.getAttribute("role"):null;
        String statut = sess!=null?(String)sess.getAttribute("statut"):null;

        // Non connecté
        if (sess==null||role==null) { hResp.sendRedirect(ctx+"/index.jsp?msg=session"); return; }

        // Examen en cours → bloquer la navigation
        if ("etudiant".equals(role) && "en_cours".equals(statut)) {
            boolean surExam = uri.contains("/etudiant/exam") || uri.contains("/SoumettreExamen");
            if (!surExam) { hResp.sendRedirect(ctx+"/pages/etudiant/exam.jsp"); return; }
        }

        // Cloisonnement rôles
        if ("etudiant".equals(role) && uri.contains("/admin/")) { hResp.sendRedirect(ctx+"/pages/etudiant/accueil.jsp"); return; }
        if ("admin".equals(role)    && uri.contains("/etudiant/")) { hResp.sendRedirect(ctx+"/pages/admin/dashboard.jsp"); return; }

        chain.doFilter(req,resp);
    }
}
