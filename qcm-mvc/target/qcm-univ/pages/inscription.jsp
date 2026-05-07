<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@include file="../includes/header.jsp"%>
<jsp:param name="title" value="Inscription"/>

<div class="auth-wrap">
  <div class="auth-box">
    <h1 class="auth-title">Créer un compte</h1>
    <p class="auth-sub">Remplissez le formulaire pour vous inscrire.</p>

    <c:if test="${not empty requestScope.error}">
      <div class="msg msg-err">${requestScope.error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/InscriptionServlet" method="post">
      <div class="form-row">
        <div class="field" style="margin:0 0 14px">
          <label>Nom de famille</label>
          <input type="text" name="nom" placeholder="RAKOTO" required value="${param.nom}">
        </div>
        <div class="field" style="margin:0 0 14px">
          <label>Prénoms</label>
          <input type="text" name="prenoms" placeholder="Jean Paul" required value="${param.prenoms}">
        </div>
      </div>
      <div class="field">
        <label>Niveau</label>
        <select name="niveau" required>
          <option value="">— Sélectionnez votre niveau —</option>
          <option value="L1" ${param.niveau eq 'L1' ? 'selected' : ''}>L1 — Licence 1</option>
          <option value="L2" ${param.niveau eq 'L2' ? 'selected' : ''}>L2 — Licence 2</option>
          <option value="L3" ${param.niveau eq 'L3' ? 'selected' : ''}>L3 — Licence 3</option>
          <option value="M1" ${param.niveau eq 'M1' ? 'selected' : ''}>M1 — Maîtrise 1</option>
          <option value="M2" ${param.niveau eq 'M2' ? 'selected' : ''}>M2 — Maîtrise 2</option>
        </select>
      </div>
      <div class="field">
        <label>Adresse email universitaire</label>
        <input type="email" name="email" placeholder="prenom.nom@univ.mg" required value="${param.email}">
      </div>
      <div class="field">
        <label>N° étudiant (deviendra votre mot de passe)</label>
        <input type="text" name="numEtudiant" placeholder="Ex : 2024001" required value="${param.numEtudiant}">
      </div>
      <button type="submit" class="btn btn-primary btn-full">Créer mon compte</button>
    </form>
    <p class="auth-footer">Déjà inscrit ? <a href="${pageContext.request.contextPath}/index.jsp">Se connecter</a></p>
  </div>
</div>

<%@include file="../includes/footer.jsp"%>
