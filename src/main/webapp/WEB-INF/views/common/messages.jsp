<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success">
        <span>✓ <c:out value="${successMessage}" /></span>
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">
        <span>⚠ <c:out value="${errorMessage}" /></span>
    </div>
</c:if>

<c:if test="${not empty infoMessage}">
    <div class="alert alert-info">
        <span>ℹ <c:out value="${infoMessage}" /></span>
    </div>
</c:if>
