<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar">
  <div class="sb-user">
    <div class="avatar">${sessionScope.nom != null ? sessionScope.nom.substring(0,1) : ''}${sessionScope.prenoms != null ? sessionScope.prenoms.substring(0,1) : ''}</div>
    <div class="sb-name">${sessionScope.prenoms} ${sessionScope.nom}</div>
    <div class="sb-role">${sessionScope.niveau} — Informatique</div>
  </div>
  <nav class="sb-nav">
    <div class="nav-lbl">Menu</div>
    <a class="nav-item ${param.active eq 'accueil' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/etudiant/accueil.jsp">
      <span class="nav-icon">⌂</span>Accueil
    </a>
    <a class="nav-item ${param.active eq 'exam' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/etudiant/exam.jsp">
      <span class="nav-icon">✎</span>Mon examen
    </a>
    <a class="nav-item ${param.active eq 'resultat' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/pages/etudiant/resultat.jsp">
      <span class="nav-icon">★</span>Mon résultat
    </a>
  </nav>
</aside>
