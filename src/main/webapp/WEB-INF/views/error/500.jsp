<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Server Error (500) - SkyFly Airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding: 80px 20px; text-align: center;">
    <div style="font-size: 5rem; font-weight: 800; color: var(--danger); margin-bottom: 10px;">500</div>
    <h1 style="font-size: 2rem; color: var(--primary); margin-bottom: 12px;">Technical Turbulence Encountered</h1>
    <p style="color: var(--gray-500); max-width: 520px; margin: 0 auto 30px;">
        <c:out value="${errorMessage != null ? errorMessage : 'An unexpected error occurred while processing your request. Please try again later.'}" />
    </p>
    <div style="display: flex; justify-content: center; gap: 12px;">
        <a href="<c:url value='/' />" class="btn btn-primary">Return to Home</a>
        <a href="javascript:location.reload()" class="btn btn-outline-primary">Reload Page</a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
