<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@include file="../includes/header.jsp"%>
<jsp:param name="title" value="Erreur"/>

<div style="flex:1;display:flex;align-items:center;justify-content:center;padding:40px">
  <div style="text-align:center;max-width:400px">
    <div style="font-size:56px;margin-bottom:16px">⚠</div>
    <h2 style="font-family:var(--ff-h);font-size:24px;margin-bottom:8px">
      <c:choose>
        <c:when test="${pageContext.errorData.statusCode == 404}">Page introuvable</c:when>
        <c:otherwise>Une erreur est survenue</c:otherwise>
      </c:choose>
    </h2>
    <p class="text-sm" style="margin-bottom:24px;color:var(--text2)">
      <c:choose>
        <c:when test="${pageContext.errorData.statusCode == 404}">
          La page que vous cherchez n'existe pas ou a été déplacée.
        </c:when>
        <c:otherwise>
          Une erreur inattendue s'est produite. Veuillez réessayer.
        </c:otherwise>
      </c:choose>
    </p>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/index.jsp">← Retour à l'accueil</a>
  </div>
</div>

<%@include file="../includes/footer.jsp"%>
