<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Airline Management - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="airlines" />
<c:set var="adminPageTitle" value="Airline Carrier Management" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3>Registered Airline Carriers</h3>
                <div style="display: flex; gap: 12px; align-items: center;">
                    <input type="text" id="tableQuickSearch" class="table-search-input" placeholder="Quick search airlines...">
                    <a href="<c:url value='/admin/airlines/new' />" class="btn btn-primary btn-sm">
                        + Add New Airline
                    </a>
                </div>
            </div>

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
                    <c:forEach var="airline" items="${airlines}">
                        <tr>
                            <td>${airline.id}</td>
                            <td>
                                <span class="airline-code-badge" style="font-size: 0.9rem;">
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
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
