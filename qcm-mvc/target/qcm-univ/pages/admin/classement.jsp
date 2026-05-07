<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'admin'}">
  <c:redirect url="/index.jsp"/>
</c:if>
<%
  String filtreNiv = request.getParameter("niveau");
  dao.EtudiantDAO eDao = new dao.EtudiantDAO();
  try {
    java.util.List<Object[]> classement = eDao.classement(filtreNiv);
    request.setAttribute("classement", classement);
    request.setAttribute("filtreNiv",  filtreNiv);
  } catch(Exception e) { e.printStackTrace(); }
%>
<%@include file="../../includes/header.jsp"%>
<jsp:param name="title" value="Classement"/>

<div class="app-wrap">
  <jsp:include page="../../includes/sidebar-admin.jsp">
    <jsp:param name="active" value="classement"/>
  </jsp:include>

  <main class="main">
    <div class="ph">
      <h2>Classement par mérite</h2>
      <p>Étudiants classés par note décroissante — Année 2023-2024</p>
    </div>

    <div class="filter-bar mb16">
      <span class="fw6 text-sm">${fn:length(classement)} résultat<c:if test="${fn:length(classement) > 1}">s</c:if></span>
      <form method="get">
        <select name="niveau" class="filter-select" onchange="this.form.submit()">
          <option value="">Tous les niveaux</option>
          <c:forEach var="niv" items="${['L1','L2','L3','M1','M2']}">
            <option value="${niv}" ${filtreNiv eq niv ? 'selected' : ''}>${niv}</option>
          </c:forEach>
        </select>
      </form>
    </div>

    <c:choose>
      <c:when test="${empty classement}">
        <div class="empty">
          <div class="empty-icon">🏅</div>
          <div class="empty-title">Aucun résultat disponible</div>
          <div>Aucun étudiant n'a encore soumis d'examen pour ce filtre.</div>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="row" items="${classement}" varStatus="st">
          <%
            Object[] row = (Object[]) pageContext.getAttribute("row");
            int idx = ((jakarta.servlet.jsp.jstl.core.LoopTagStatus) pageContext.getAttribute("st")).getIndex();
            String posClass = idx == 0 ? "gold" : idx == 1 ? "silver" : idx == 2 ? "bronze" : "";
            String medal    = idx == 0 ? "🥇"   : idx == 1 ? "🥈"    : idx == 2 ? "🥉"    : "#" + (idx + 1);
            pageContext.setAttribute("posClass", posClass);
            pageContext.setAttribute("medal",    medal);
            pageContext.setAttribute("numEtu",   row[0]);
            pageContext.setAttribute("nom",      row[1]);
            pageContext.setAttribute("prenoms",  row[2]);
            pageContext.setAttribute("niveau",   row[3]);
            pageContext.setAttribute("email",    row[4]);
            pageContext.setAttribute("note",     row[5]);
          %>
          <div class="rank-item">
            <div class="rank-pos ${posClass}">${medal}</div>
            <div class="rank-info">
              <div class="rank-name">${prenoms} ${nom}</div>
              <div class="rank-meta">${niveau} · ${email}</div>
            </div>
            <div class="rank-note">${note}<span style="font-size:13px;color:var(--text3)">/10</span></div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </main>
</div>

<%@include file="../../includes/footer.jsp"%>
