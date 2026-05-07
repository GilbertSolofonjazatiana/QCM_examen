<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'admin'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<%
  dao.EtudiantDAO eDao = new dao.EtudiantDAO();
  dao.QuestionDAO qDao = new dao.QuestionDAO();
  try {
    request.setAttribute("nbEtudiants", eDao.countEtudiants());
    request.setAttribute("nbQuestions", qDao.compter());
    request.setAttribute("nbExamens",   eDao.countExamensTermines());
    double moy = eDao.moyenneGenerale();
    request.setAttribute("moyenne", moy > 0 ? String.format("%.1f", moy) : "—");
  } catch(Exception e) { e.printStackTrace(); }
%>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Dashboard Admin"/>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-admin.jsp">
    <jsp:param name="active" value="dashboard"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Tableau de bord</h2>
      <p>Vue d'ensemble de la plateforme — Année 2023-2024</p>
    </div>

    <div class="stats">
      <div class="stat"><div class="stat-v">${nbEtudiants}</div><div class="stat-l">Étudiants inscrits</div></div>
      <div class="stat"><div class="stat-v">${nbQuestions}</div><div class="stat-l">Questions QCM</div></div>
      <div class="stat"><div class="stat-v">${nbExamens}</div><div class="stat-l">Examens soumis</div></div>
      <div class="stat"><div class="stat-v">${moyenne}</div><div class="stat-l">Moyenne générale</div></div>
    </div>

    <div class="card">
      <div class="card-title">Accès rapide</div>
      <div style="display:flex;gap:10px;flex-wrap:wrap">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/pages/admin/qcm.jsp">Gérer les QCM</a>
        <a class="btn btn-ghost"   href="${pageContext.request.contextPath}/pages/admin/etudiants.jsp">Voir les étudiants</a>
        <a class="btn btn-ghost"   href="${pageContext.request.contextPath}/pages/admin/classement.jsp">Classement</a>
      </div>
    </div>

    <div class="card">
      <div class="card-title">Niveaux disponibles</div>
      <div style="display:flex;gap:8px;flex-wrap:wrap">
        <c:forEach var="niv" items="${['L1','L2','L3','M1','M2']}">
          <span class="badge b-blue">${niv}</span>
        </c:forEach>
      </div>
    </div>
  </main>
</div>

<%@include file="../../includes/footer.jsp"%>
