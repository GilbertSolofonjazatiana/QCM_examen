<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'admin'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<%
  String filtreNiv = request.getParameter("niveau");
  dao.EtudiantDAO eDao = new dao.EtudiantDAO();
  try {
    java.util.List<model.Etudiant> liste = eDao.listerEtudiants(filtreNiv);
    request.setAttribute("etudiants", liste);
    request.setAttribute("filtreNiv", filtreNiv);
  } catch(Exception e) { e.printStackTrace(); }
%>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Étudiants"/>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-admin.jsp">
    <jsp:param name="active" value="etudiants"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Liste des étudiants</h2>
      <p>Tous les étudiants inscrits sur la plateforme</p>
    </div>

    <c:if test="${param.msg eq 'reinit'}"><div class="msg msg-ok mb16">✔ Examen réinitialisé avec succès.</div></c:if>
    <c:if test="${param.err eq '1'}"><div class="msg msg-err mb16">Erreur lors de l'opération.</div></c:if>

    <div class="filter-bar mb16">
      <span class="fw6 text-sm">${fn:length(etudiants)} étudiant<c:if test="${fn:length(etudiants) > 1}">s</c:if></span>
      <form method="get">
        <select name="niveau" class="filter-select" onchange="this.form.submit()">
          <option value="">Tous les niveaux</option>
          <c:forEach var="niv" items="${['L1','L2','L3','M1','M2']}">
            <option value="${niv}" ${filtreNiv eq niv ? 'selected' : ''}>${niv}</option>
          </c:forEach>
        </select>
      </form>
    </div>

    <div class="card" style="padding:0;overflow:hidden">
      <div class="tbl-wrap">
        <table>
          <thead>
            <tr>
              <th>N° Étudiant</th>
              <th>Nom complet</th>
              <th>Niveau</th>
              <th>Email</th>
              <th>Statut examen</th>
              <th>Note</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty etudiants}">
                <tr><td colspan="6" style="text-align:center;padding:28px;color:var(--text3)">Aucun étudiant trouvé.</td></tr>
              </c:when>
              <c:otherwise>
                <%
                  dao.EtudiantDAO eDao2 = new dao.EtudiantDAO();
                  java.util.List<model.Etudiant> etudiants = (java.util.List<model.Etudiant>) request.getAttribute("etudiants");
                %>
                <c:forEach var="e" items="${etudiants}">
                  <%
                    model.Etudiant etu = (model.Etudiant) pageContext.getAttribute("e");
                    model.Examen ex = null;
                    try { ex = eDao2.getExamen(etu.getNumEtudiant()); } catch(Exception ex2){}
                    pageContext.setAttribute("ex", ex);
                  %>
                  <tr>
                    <td class="fw6">${e.numEtudiant}</td>
                    <td>${e.prenoms} ${e.nom}</td>
                    <td><span class="badge b-blue">${e.niveau}</span></td>
                    <td class="text-sm">${e.adrEmail}</td>
                    <td>
                      <c:choose>
                        <c:when test="${ex.termine}"><span class="badge b-green">Terminé</span></c:when>
                        <c:when test="${ex.enCours}"><span class="badge b-amber">En cours</span></c:when>
                        <c:otherwise><span class="badge b-neutral">Non passé</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty ex.note}"><strong>${ex.note}/10</strong></c:when>
                        <c:otherwise><span class="text-xs">—</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:if test="${ex.termine}">
                        <form action="${pageContext.request.contextPath}/AdminEtudiantsServlet" method="post"
                              onsubmit="return confirm('Réinitialiser l\'examen de cet étudiant ?')">
                          <input type="hidden" name="action"       value="reinitialiser">
                          <input type="hidden" name="numEtudiant"  value="${e.numEtudiant}">
                          <button type="submit" class="btn btn-danger btn-sm">Réinitialiser</button>
                        </form>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<%@include file="../../includes/footer.jsp"%>
