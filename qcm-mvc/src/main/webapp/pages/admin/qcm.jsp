<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'admin'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<%
  String filtreNiv = request.getParameter("niveau");
  dao.QuestionDAO qDao = new dao.QuestionDAO();
  try {
    request.setAttribute("questions", qDao.lister(filtreNiv));
    request.setAttribute("filtreNiv", filtreNiv);
  } catch(Exception e) { e.printStackTrace(); }
%>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Gestion QCM"/>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-admin.jsp">
    <jsp:param name="active" value="qcm"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Gestion des QCM</h2>
      <p>Ajouter, consulter ou supprimer des questions</p>
    </div>

    <%-- Notifications --%>
    <c:if test="${param.msg eq 'ajoute'}"><div class="msg msg-ok mb16">✔ Question ajoutée avec succès.</div></c:if>
    <c:if test="${param.msg eq 'supprime'}"><div class="msg msg-ok mb16">✔ Question supprimée.</div></c:if>
    <c:if test="${param.err eq 'champs'}"><div class="msg msg-err mb16">Veuillez remplir tous les champs.</div></c:if>

    <%-- Formulaire ajout --%>
    <div class="qform">
      <div class="card-title">Ajouter une question</div>
      <form action="${pageContext.request.contextPath}/AdminQcmServlet" method="post">
        <input type="hidden" name="action" value="ajouter">
        <div class="field">
          <label>Intitulé de la question</label>
          <textarea name="question" rows="2" placeholder="Ex : Quelle est la complexité du tri rapide ?" required></textarea>
        </div>
        <div class="fgrid mb12">
          <div class="field" style="margin:0"><label>Réponse 1</label><input type="text" name="reponse1" placeholder="O(n)" required></div>
          <div class="field" style="margin:0"><label>Réponse 2</label><input type="text" name="reponse2" placeholder="O(n log n)" required></div>
        </div>
        <div class="fgrid mb12">
          <div class="field" style="margin:0"><label>Réponse 3</label><input type="text" name="reponse3" placeholder="O(n²)" required></div>
          <div class="field" style="margin:0"><label>Réponse 4</label><input type="text" name="reponse4" placeholder="O(log n)" required></div>
        </div>
        <div class="fgrid">
          <div class="field" style="margin:0">
            <label>Bonne réponse</label>
            <select name="bonneReponse" required>
              <option value="1">Réponse 1</option><option value="2">Réponse 2</option>
              <option value="3">Réponse 3</option><option value="4">Réponse 4</option>
            </select>
          </div>
          <div class="field" style="margin:0">
            <label>Niveau</label>
            <select name="niveau" required>
              <option value="L1">L1</option><option value="L2">L2</option>
              <option value="L3">L3</option><option value="M1">M1</option><option value="M2">M2</option>
            </select>
          </div>
        </div>
        <div style="margin-top:14px"><button type="submit" class="btn btn-primary">Ajouter la question</button></div>
      </form>
    </div>

    <%-- Liste des questions --%>
    <div class="filter-bar">
      <span class="fw6 text-sm">Banque de questions (${fn:length(questions)})</span>
      <form method="get" id="filter-form">
        <select name="niveau" class="filter-select" onchange="this.form.submit()">
          <option value="">Tous les niveaux</option>
          <option value="L1" ${filtreNiv eq 'L1' ? 'selected':''}>L1</option>
          <option value="L2" ${filtreNiv eq 'L2' ? 'selected':''}>L2</option>
          <option value="L3" ${filtreNiv eq 'L3' ? 'selected':''}>L3</option>
          <option value="M1" ${filtreNiv eq 'M1' ? 'selected':''}>M1</option>
          <option value="M2" ${filtreNiv eq 'M2' ? 'selected':''}>M2</option>
        </select>
      </form>
    </div>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

    <div class="card" style="padding:0;overflow:hidden">
      <div class="tbl-wrap">
        <table>
          <thead><tr><th style="width:44px">#</th><th>Question</th><th style="width:72px">Niveau</th><th style="width:120px">Action</th></tr></thead>
          <tbody>
            <c:choose>
              <c:when test="${empty questions}">
                <tr><td colspan="4" class="empty" style="padding:28px">Aucune question trouvée.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="q" items="${questions}">
                  <tr>
                    <td class="text-xs">${q.numQuestion}</td>
                    <td>
                      <div style="max-width:380px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:500" title="${q.question}">${q.question}</div>
                      <div class="text-xs" style="margin-top:2px">✔ ${q.getOption(q.bonneReponse)}</div>
                    </td>
                    <td><span class="badge b-blue">${q.qcmNiveau}</span></td>
                    <td>
                      <form action="${pageContext.request.contextPath}/AdminQcmServlet" method="post"
                            onsubmit="return confirm('Supprimer cette question ?')">
                        <input type="hidden" name="action" value="supprimer">
                        <input type="hidden" name="id" value="${q.numQuestion}">
                        <button type="submit" class="btn btn-danger btn-sm">Supprimer</button>
                      </form>
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
