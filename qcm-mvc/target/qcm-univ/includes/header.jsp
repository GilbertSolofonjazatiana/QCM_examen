<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${param.title} — QCM Univ</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;1,600&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <script>
    // Appliquer le thème avant le rendu pour éviter le flash
    (function(){ if(localStorage.getItem('qcm-dark')==='1') document.documentElement.classList.add('dark-pre'); })();
  </script>
</head>
<body>
<header class="topbar">
  <a class="brand" href="${pageContext.request.contextPath}/index.jsp">QCM Univ <em>· Informatique</em></a>
  <nav class="topbar-right">
    <button class="btn btn-icon" onclick="toggleTheme()" title="Thème clair/sombre">◐</button>
    <c:choose>
      <c:when test="${not empty sessionScope.role}">
        <span class="text-sm" style="color:var(--text2)">${sessionScope.prenoms} ${sessionScope.nom}</span>
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/LogoutServlet">Déconnexion →</a>
      </c:when>
      <c:otherwise>
        <a class="btn btn-ghost"   href="${pageContext.request.contextPath}/index.jsp">Se connecter</a>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/pages/inscription.jsp">S'inscrire</a>
      </c:otherwise>
    </c:choose>
  </nav>
</header>
