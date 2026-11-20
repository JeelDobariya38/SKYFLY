<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Route Management - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="activePage" value="admin" />
<c:set var="adminActive" value="routes" />
<c:set var="adminPageTitle" value="Flight Route Management" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🗺 Route Network</span>
                <h1 class="page-title">Flight Route Management</h1>
                <p class="page-subtitle">Manage flight connections, origin/destination airport sectors, and route distances.</p>
            </div>
            <div class="admin-page-actions">
                <a href="<c:url value='/admin/routes/new' />" class="btn btn-primary">
                    <span>+ Create New Route</span>
                </a>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3><span>🗺</span> Aviation Routes</h3>
                <div class="table-header-tools">
                    <input type="text" id="tableQuickSearch" class="table-search-input" placeholder="🔍 Quick search routes...">
                    <a href="<c:url value='/admin/routes/new' />" class="btn btn-primary btn-sm">
                        + Create New Route
                    </a>
                </div>
            </div>

            <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Origin Airport</th>
                        <th>Destination Airport</th>
                        <th>Distance (KM)</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="route" items="${routes}">
                        <tr>
                            <td>${route.id}</td>
                            <td>
                                <strong><c:out value="${route.sourceAirport.city}" /></strong>
                                (<span style="color: var(--secondary);"><c:out value="${route.sourceAirport.airportCode}" /></span>)
                                <div style="font-size: 0.8rem; color: var(--gray-400);"><c:out value="${route.sourceAirport.airportName}" /></div>
                            </td>
                            <td>
                                <strong><c:out value="${route.destinationAirport.city}" /></strong>
                                (<span style="color: var(--secondary);"><c:out value="${route.destinationAirport.airportCode}" /></span>)
                                <div style="font-size: 0.8rem; color: var(--gray-400);"><c:out value="${route.destinationAirport.airportName}" /></div>
                            </td>
                            <td>
                                <c:out value="${route.distanceKm != null ? route.distanceKm : 'N/A'}" /> km
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${route.status == 'ACTIVE'}">
                                        <span class="badge badge-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="<c:url value='/admin/routes/edit/${route.id}' />" class="btn btn-outline-primary btn-sm">
                                        Edit
                                    </a>
                                    <form action="<c:url value='/admin/routes/delete/${route.id}' />" method="post" class="delete-confirm-form" style="display: inline;">
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
