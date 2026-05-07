<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Sécurité --%>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'etudiant'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<%-- Si examen terminé → résultat --%>
<c:if test="${sessionScope.examen.termine}">
  <c:redirect url="/pages/etudiant/resultat.jsp"/>
</c:if>
<%-- Si pas encore démarré → accueil --%>
<c:if test="${empty sessionScope.questions}">
  <c:redirect url="/pages/etudiant/accueil.jsp"/>
</c:if>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Examen en cours"/>

<%-- Calcul du temps restant côté serveur --%>
<%
  Long startTime = (Long) session.getAttribute("startTime");
  Long duration  = (Long) session.getAttribute("duration");
  long startMs = (startTime != null) ? startTime : System.currentTimeMillis();
  long durMs   = (duration  != null) ? duration  : 20*60*1000L;
%>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-etudiant.jsp">
    <jsp:param name="active" value="exam"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Examen en cours</h2>
      <p>Répondez aux questions avant la fin du chronomètre — Année 2023-2024</p>
    </div>

    <%-- Barre chrono + progression --%>
    <div class="exam-bar">
      <div>
        <div class="text-xs mb8" style="margin-bottom:3px">Temps restant</div>
        <div class="timer" id="timer">20:00</div>
      </div>
      <div style="text-align:right">
        <div class="text-xs" style="margin-bottom:3px">Progression</div>
        <div id="q-prog" style="font-size:14px;font-weight:500">0 / ${fn:length(sessionScope.questions)}</div>
      </div>
    </div>
    <div class="prog-track"><div class="prog-fill" id="prog-fill" style="width:0%"></div></div>

    <%-- Formulaire de réponses --%>
    <form id="exam-form" action="${pageContext.request.contextPath}/SoumettreExamen" method="post">
      <c:forEach var="q" items="${sessionScope.questions}" varStatus="st">
        <div class="q-card" id="qc-${st.index}">
          <div class="q-num">Question ${st.index + 1} / ${fn:length(sessionScope.questions)}</div>
          <div class="q-text">${q.question}</div>
          <c:forEach begin="1" end="4" var="i">
            <label class="opt">
              <input type="radio" name="q${st.index}" value="${i}"
                     onchange="document.getElementById('qc-${st.index}').classList.add('done');updateProgress()">
              ${q.getOption(i)}
            </label>
          </c:forEach>
        </div>
      </c:forEach>

      <div style="margin-top:20px;padding-top:16px;border-top:1px solid var(--border);text-align:center">
        <button type="submit" class="btn btn-primary"
                onclick="return confirmSubmit(${fn:length(sessionScope.questions)})">
          Soumettre l'examen
        </button>
        <p class="text-xs" style="margin-top:10px;color:var(--text3)">
          L'examen sera soumis automatiquement à la fin du temps.
        </p>
      </div>
    </form>
  </main>
</div>

<%@include file="../../includes/footer.jsp"%>
<script>
  initTimer(<%= startMs %>, <%= durMs %>);
  initProgress(${fn:length(sessionScope.questions)});

  // Bloquer la fermeture de page
  window.addEventListener('beforeunload', function(e) {
    e.preventDefault();
    e.returnValue = 'Votre examen est en cours. Si vous quittez la page, votre progression sera perdue.';
  });

  // Supprimer l'alerte si on soumet le formulaire
  document.getElementById('exam-form').addEventListener('submit', function() {
    window.removeEventListener('beforeunload', arguments.callee);
  });

  function updateProgress() {
    const total = ${fn:length(sessionScope.questions)};
    let ans = 0;
    for (let i = 0; i < total; i++) {
      if (document.querySelector(`input[name="q${i}"]:checked`)) ans++;
    }
    document.getElementById('prog-fill').style.width = (ans/total*100)+'%';
    document.getElementById('q-prog').textContent = ans+' / '+total+' répondu'+(ans>1?'s':'');
  }
</script>
