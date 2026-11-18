<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Page Not Found (404) - SkyFly Airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding: 80px 20px; text-align: center;">
    <div style="font-size: 5rem; font-weight: 800; color: var(--secondary); margin-bottom: 10px;">404</div>
    <h1 style="font-size: 2rem; color: var(--primary); margin-bottom: 12px;">Flight Path Not Found</h1>
    <p style="color: var(--gray-500); max-width: 500px; margin: 0 auto 30px;">
        <c:out value="${errorMessage != null ? errorMessage : 'The requested page or flight resource does not exist or has been relocated.'}" />
    </p>
    <div style="display: flex; justify-content: center; gap: 12px;">
        <a href="<c:url value='/' />" class="btn btn-primary">Return to Home</a>
        <a href="<c:url value='/flights/search' />" class="btn btn-outline-primary">Search Flights</a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
