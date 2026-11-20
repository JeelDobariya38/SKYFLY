<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Airline Carriers - SkyFly Admin" scope="request" />
<c:set var="isAdminSection" value="true" scope="request" />
<c:set var="activePage" value="admin" scope="request" />
<c:set var="adminActive" value="airlines" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🏢 Fleet & Carriers</span>
                <h1 class="page-title">Airline Carrier Management</h1>
                <p class="page-subtitle">Register partner airline operators, fleet carriers, and service codes.</p>
            </div>
            <div class="admin-page-actions">
                <a href="<c:url value='/admin/airlines/new' />" class="btn btn-primary">
                    <span>+ Add New Airline</span>
                </a>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3><span>🏢</span> Registered Airline Carriers</h3>
                <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
                    <input type="text" id="tableQuickSearch" class="table-search-input" placeholder="🔍 Quick search airlines...">
                    <a href="<c:url value='/admin/airlines/new' />" class="btn btn-primary btn-sm">
                        + Add New Airline
                    </a>
                </div>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Carrier Code</th>
                            <th>Airline Name</th>
                            <th>Fleet / Description</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty airlines}">
                                <c:forEach var="airline" items="${airlines}">
                                    <tr>
                                        <td><strong>#${airline.id}</strong></td>
                                        <td>
                                            <span class="airline-code-badge">
                                                <c:out value="${airline.airlineCode}" />
                                            </span>
                                        </td>
                                        <td><strong><c:out value="${airline.airlineName}" /></strong></td>
                                        <td style="color: var(--gray-600); max-width: 300px;"><c:out value="${airline.description}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${airline.status == 'ACTIVE'}">
                                                    <span class="badge badge-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <a href="<c:url value='/admin/airlines/edit/${airline.id}' />" class="btn btn-outline-primary btn-sm">
                                                    Edit
                                                </a>
                                                <form action="<c:url value='/admin/airlines/delete/${airline.id}' />" method="post" class="delete-confirm-form" style="display: inline;">
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--gray-400); padding: 30px;">
                                        No airline carriers registered yet.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
