<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="admin-topbar">
    <div class="admin-topbar-title">
        <c:out value="${adminPageTitle != null ? adminPageTitle : 'SkyFly Administrator'}" />
    </div>
    <div class="admin-topbar-user">
        <a href="<c:url value='/' />" class="btn btn-outline-primary btn-sm" target="_blank">
            <span>🌐 View Website</span>
        </a>
        <a href="<c:url value='/servlet/health' />" class="btn btn-sm" style="background: #f1f5f9; color: #0284c7;" target="_blank">
            <span>⚡ Servlet Health</span>
        </a>
        <span style="font-size: 0.9rem; font-weight: 600; color: var(--gray-700);">
            👤 <c:out value="${sessionScope.currentUser.fullName}" /> (Admin)
        </span>
        <a href="<c:url value='/logout' />" class="btn btn-danger btn-sm">Logout</a>
    </div>
</header>
