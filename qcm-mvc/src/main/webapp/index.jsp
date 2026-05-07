<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Rediriger si déjà connecté --%>
<c:if test="${not empty sessionScope.role}">
  <c:choose>
    <c:when test="${sessionScope.role eq 'admin'}"><c:redirect url="/pages/admin/dashboard.jsp"/></c:when>
    <c:otherwise><c:redirect url="/pages/etudiant/accueil.jsp"/></c:otherwise>
  </c:choose>
</c:if>
<%@include file="includes/header.jsp"%>
<jsp:param name="title" value="Accueil"/>

<main style="display:flex;flex-direction:column;min-height:calc(100vh - 54px)">
  <section class="hero">
    <p class="hero-tag">Université · Licence &amp; Maîtrise Informatique</p>
    <h1>Passez vos examens<br><em>en toute sérénité.</em></h1>
    <p>Plateforme officielle de gestion des examens QCM. Chronomètre intégré, résultats instantanés, classement par mérite.</p>

    <%-- Message de notification --%>
    <c:if test="${param.msg eq 'inscrit'}">
      <div class="msg msg-ok" style="margin-bottom:20px">Compte créé avec succès ! Connectez-vous ci-dessous.</div>
    </c:if>
    <c:if test="${param.msg eq 'deconnecte'}">
      <div class="msg msg-info" style="margin-bottom:20px">Vous avez été déconnecté.</div>
    </c:if>
    <c:if test="${param.msg eq 'session'}">
      <div class="msg msg-warn" style="margin-bottom:20px">Session expirée. Veuillez vous reconnecter.</div>
    </c:if>

    <%-- Formulaire de connexion intégré --%>
    <div style="background:var(--surface);border:1px solid var(--border);border-radius:var(--rl);padding:28px;width:100%;max-width:380px;box-shadow:var(--shm);margin-bottom:40px;text-align:left">
      <div class="auth-title" style="font-size:20px;margin-bottom:4px">Connexion</div>
      <div class="auth-sub">Identifiez-vous pour accéder à votre espace.</div>
      <c:if test="${not empty requestScope.error}">
        <div class="msg msg-err">${requestScope.error}</div>
      </c:if>
      <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <div class="field">
          <label>Adresse email</label>
          <input type="email" name="email" placeholder="prenom.nom@univ.mg" required autocomplete="email">
        </div>
        <div class="field">
          <label>Mot de passe (N° étudiant)</label>
          <input type="password" name="password" placeholder="Ex : 2024001" required autocomplete="current-password">
        </div>
        <button type="submit" class="btn btn-primary btn-full">Se connecter</button>
      </form>
      <p class="auth-footer">Pas encore inscrit ? <a href="${pageContext.request.contextPath}/pages/inscription.jsp">Créer un compte</a></p>
      <div class="demo">
        <strong>Comptes de démonstration</strong>
        👤 Admin : admin@univ.mg / admin123<br>
        🎓 Étudiant (L2) : etudiant@univ.mg / 2024001
      </div>
    </div>

    <div class="features">
      <div class="feat"><div class="feat-icon">⏱</div><div class="feat-title">Chronomètre 20 min</div><div class="feat-desc">Compte à rebours, soumission automatique à la fin</div></div>
      <div class="feat"><div class="feat-icon">🔒</div><div class="feat-title">Examen sécurisé</div><div class="feat-desc">Site bloqué pendant la session d'examen</div></div>
      <div class="feat"><div class="feat-icon">📧</div><div class="feat-title">Résultat par email</div><div class="feat-desc">Note calculée et envoyée immédiatement</div></div>
      <div class="feat"><div class="feat-icon">🏅</div><div class="feat-title">Classement</div><div class="feat-desc">Classement par mérite pour chaque niveau</div></div>
    </div>
  </section>
</main>

<%@include file="includes/footer.jsp"%>
