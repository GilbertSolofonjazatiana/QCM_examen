<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'etudiant'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<c:if test="${not sessionScope.examen.termine}">
  <c:redirect url="/pages/etudiant/accueil.jsp"/>
</c:if>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Mon résultat"/>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-etudiant.jsp">
    <jsp:param name="active" value="resultat"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Mon résultat</h2>
      <p>Année universitaire ${sessionScope.examen.anneUniv}</p>
    </div>

    <%-- Score principal --%>
    <div class="res-hero">
      <div class="res-score">${sessionScope.examen.note}<span style="font-size:32px;color:var(--text3)">/10</span></div>
      <div class="res-mention">
        <c:choose>
          <c:when test="${sessionScope.examen.note >= 9}"><span style="color:var(--green);font-weight:600">Excellent</span></c:when>
          <c:when test="${sessionScope.examen.note >= 8}"><span style="color:var(--green);font-weight:600">Très Bien</span></c:when>
          <c:when test="${sessionScope.examen.note >= 7}"><span style="color:#2e7d55;font-weight:600">Bien</span></c:when>
          <c:when test="${sessionScope.examen.note >= 5}"><span style="color:var(--amber);font-weight:600">Passable</span></c:when>
          <c:otherwise><span style="color:var(--red);font-weight:600">Insuffisant</span></c:otherwise>
        </c:choose>
      </div>
      <div class="res-year">Année universitaire ${sessionScope.examen.anneUniv}</div>
    </div>

    <div class="card card-body mb16">
      ✔ Votre résultat a été enregistré et transmis à votre enseignant.<br>
      Un email de confirmation a été envoyé à <strong>${sessionScope.email}</strong>.
    </div>

    <%-- Correction détaillée si questions disponibles --%>
    <c:if test="${not empty sessionScope.questions}">
      <div class="card">
        <div class="card-title">Correction détaillée</div>
      </div>
      <c:forEach var="q" items="${sessionScope.questions}" varStatus="st">
        <div class="q-card" style="margin-bottom:10px">
          <div class="q-num">
            Question ${st.index + 1}
            <c:choose>
              <c:when test="${q.reponseDonnee == q.bonneReponse}">
                <span class="badge b-green" style="margin-left:8px">✔ Correcte</span>
              </c:when>
              <c:when test="${q.reponseDonnee == 0}">
                <span class="badge b-amber" style="margin-left:8px">— Sans réponse</span>
              </c:when>
              <c:otherwise>
                <span class="badge b-red" style="margin-left:8px">✗ Incorrecte</span>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="q-text">${q.question}</div>
          <c:forEach begin="1" end="4" var="i">
            <div class="opt ${i == q.bonneReponse ? 'correct' : (i == q.reponseDonnee and q.reponseDonnee != q.bonneReponse) ? 'wrong' : ''}">
              ${q.getOption(i)}
              <c:if test="${i == q.bonneReponse}"><span class="text-xs" style="margin-left:auto">✔ Bonne réponse</span></c:if>
              <c:if test="${i == q.reponseDonnee and q.reponseDonnee != q.bonneReponse}"><span class="text-xs" style="margin-left:auto">Votre réponse</span></c:if>
            </div>
          </c:forEach>
        </div>
      </c:forEach>
    </c:if>
  </main>
</div>

<%@include file="../../includes/footer.jsp"%>
