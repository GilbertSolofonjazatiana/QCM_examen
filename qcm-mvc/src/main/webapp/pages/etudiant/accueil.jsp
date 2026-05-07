<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Sécurité --%>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'etudiant'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<%-- Charger l'examen si absent --%>
<%
  if (session.getAttribute("examen") == null) {
    dao.EtudiantDAO eDao = new dao.EtudiantDAO();
    try {
      model.Examen ex = eDao.getExamen((String)session.getAttribute("numEtudiant"));
      session.setAttribute("examen", ex);
      session.setAttribute("statut", ex.getStatut());
    } catch(Exception e) { e.printStackTrace(); }
  }
%>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Mon espace"/>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-etudiant.jsp">
    <jsp:param name="active" value="accueil"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Bienvenue, ${sessionScope.prenoms} !</h2>
      <p>Votre espace personnel — Année universitaire 2023-2024</p>
    </div>

    <%-- Bannière statut --%>
    <c:choose>
      <c:when test="${sessionScope.examen.termine}">
        <div class="msg msg-ok mb16">
          ✔ Votre examen a été soumis — Note : <strong>${sessionScope.examen.note}/10</strong>
          (${sessionScope.examen.mention}) — Résultat envoyé par email.
        </div>
      </c:when>
      <c:when test="${sessionScope.examen.enCours}">
        <div class="msg msg-warn mb16">
          ⚠ Vous avez un examen en cours. <a href="${pageContext.request.contextPath}/pages/etudiant/exam.jsp" class="fw6">Reprendre l'examen →</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="msg msg-info mb16">
          ℹ Vous n'avez pas encore passé votre examen pour l'année 2023-2024.
        </div>
      </c:otherwise>
    </c:choose>

    <%-- Stats --%>
    <div class="stats">
      <div class="stat">
        <div class="stat-v">2023-2024</div>
        <div class="stat-l">Année en cours</div>
      </div>
      <div class="stat">
        <div class="stat-v">
          <c:choose>
            <c:when test="${not empty sessionScope.examen.note}">${sessionScope.examen.note}/10</c:when>
            <c:otherwise>—</c:otherwise>
          </c:choose>
        </div>
        <div class="stat-l">Votre note</div>
      </div>
      <div class="stat">
        <div class="stat-v">
          <c:choose>
            <c:when test="${sessionScope.examen.termine}">✔</c:when>
            <c:when test="${sessionScope.examen.enCours}">⏳</c:when>
            <c:otherwise>—</c:otherwise>
          </c:choose>
        </div>
        <div class="stat-l">Statut examen</div>
      </div>
      <div class="stat">
        <div class="stat-v">${sessionScope.niveau}</div>
        <div class="stat-l">Votre niveau</div>
      </div>
    </div>

    <%-- Instructions --%>
    <div class="card">
      <div class="card-title">Instructions de l'examen</div>
      <div class="card-body">
        · 10 questions tirées aléatoirement selon votre niveau (${sessionScope.niveau})<br>
        · 20 minutes pour répondre à toutes les questions<br>
        · Le site reste bloqué sur la page examen pendant la session<br>
        · Soumission manuelle ou automatique à la fin du temps<br>
        · Note calculée sur 10, envoyée par email immédiatement<br>
        · L'examen ne peut être passé qu'<strong>une seule fois</strong> par année universitaire
      </div>
    </div>

    <c:if test="${not sessionScope.examen.termine}">
      <div style="text-align:center;margin-top:8px">
        <form action="${pageContext.request.contextPath}/DemarrerExamen" method="post">
          <button type="submit" class="btn btn-primary">
            <c:choose>
              <c:when test="${sessionScope.examen.enCours}">Reprendre l'examen</c:when>
              <c:otherwise>Démarrer l'examen</c:otherwise>
            </c:choose>
          </button>
        </form>
      </div>
    </c:if>
  </main>
</div>

<%@include file="../../includes/footer.jsp"%>
