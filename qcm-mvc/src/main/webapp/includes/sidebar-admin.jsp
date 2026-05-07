<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar">
  <div class="sb-user">
    <div class="avatar adm">AD</div>
    <div class="sb-name">Administrateur</div>
    <div class="sb-role">Professeur</div>
  </div>
  <nav class="sb-nav">
    <div class="nav-lbl">Tableau de bord</div>
    <a class="nav-item ${param.active eq 'dashboard' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">
      <span class="nav-icon">⌂</span>Accueil
    </a>
    <div class="nav-lbl">Gestion</div>
    <a class="nav-item ${param.active eq 'qcm' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/admin/qcm.jsp">
      <span class="nav-icon">?</span>Questions QCM
    </a>
    <a class="nav-item ${param.active eq 'etudiants' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/admin/etudiants.jsp">
      <span class="nav-icon">◎</span>Étudiants
    </a>
    <a class="nav-item ${param.active eq 'classement' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/admin/classement.jsp">
      <span class="nav-icon">★</span>Classement
    </a>
  </nav>
</aside>
