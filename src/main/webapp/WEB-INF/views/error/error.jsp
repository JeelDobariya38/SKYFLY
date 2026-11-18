<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Notice - SkyFly Airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding: 80px 20px; text-align: center;">
    <div style="font-size: 4rem; color: var(--warning); margin-bottom: 10px;">⚠</div>
    <h1 style="font-size: 2rem; color: var(--primary); margin-bottom: 12px;">
        <c:out value="${errorTitle != null ? errorTitle : 'Request Notice'}" />
    </h1>
    <p style="color: var(--gray-600); max-width: 520px; margin: 0 auto 30px;">
        <c:out value="${errorMessage != null ? errorMessage : 'The operation could not be completed with the provided inputs.'}" />
    </p>
    <div style="display: flex; justify-content: center; gap: 12px;">
        <a href="<c:url value='/' />" class="btn btn-primary">Return to Home</a>
        <a href="javascript:history.back()" class="btn btn-outline-primary">Go Back</a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
