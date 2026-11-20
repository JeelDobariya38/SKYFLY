<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Airport Management - SkyFly Admin" scope="request" />
<c:set var="isAdminSection" value="true" scope="request" />
<c:set var="activePage" value="admin" scope="request" />
<c:set var="adminActive" value="airports" scope="request" />
<c:set var="adminPageTitle" value="Airport Directory Management" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🛫 Airport Network</span>
                <h1 class="page-title">Airport Directory Management</h1>
                <p class="page-subtitle">Manage IATA airports, international terminals, and operational locations.</p>
            </div>
            <div class="admin-page-actions">
                <a href="<c:url value='/admin/airports/new' />" class="btn btn-primary">
                    <span>+ Add New Airport</span>
                </a>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3><span>🛫</span> Registered Airports</h3>
                <div class="table-header-tools">
                    <input type="text" id="tableQuickSearch" class="table-search-input" placeholder="🔍 Quick search airports...">
                    <a href="<c:url value='/admin/airports/new' />" class="btn btn-primary btn-sm">
                        + Add New Airport
                    </a>
                </div>
            </div>

            <div class="table-responsive">
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
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
