<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Airport Management - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="airports" />
<c:set var="adminPageTitle" value="Airport Directory Management" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3>Registered Airports</h3>
                <div style="display: flex; gap: 12px; align-items: center;">
                    <input type="text" id="tableQuickSearch" class="table-search-input" placeholder="Quick search airports...">
                    <a href="<c:url value='/admin/airports/new' />" class="btn btn-primary btn-sm">
                        + Add New Airport
                    </a>
                </div>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>IATA Code</th>
                        <th>Airport Name</th>
                        <th>City</th>
                        <th>Country</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="airport" items="${airports}">
                        <tr>
                            <td>${airport.id}</td>
                            <td>
                                <strong style="color: var(--secondary); font-size: 1.05rem;">
                                    <c:out value="${airport.airportCode}" />
                                </strong>
                            </td>
                            <td><strong><c:out value="${airport.airportName}" /></strong></td>
                            <td><c:out value="${airport.city}" /></td>
                            <td><c:out value="${airport.country}" /></td>
                            <td>
                                <div class="action-btns">
                                    <a href="<c:url value='/admin/airports/edit/${airport.id}' />" class="btn btn-outline-primary btn-sm">
                                        Edit
                                    </a>
                                    <form action="<c:url value='/admin/airports/delete/${airport.id}' />" method="post" class="delete-confirm-form" style="display: inline;">
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
