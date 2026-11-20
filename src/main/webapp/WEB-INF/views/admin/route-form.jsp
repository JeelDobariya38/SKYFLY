<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Route' : 'Add Route'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="activePage" value="admin" />
<c:set var="adminActive" value="routes" />
<c:set var="adminPageTitle" value="${isEdit ? 'Edit Flight Route' : 'Create Flight Route'}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-back-row">
            <a href="<c:url value='/admin/routes' />" class="admin-back-btn">
                <span>&larr;</span> Back to Routes List
            </a>
        </div>

        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🗺 Route Planner</span>
                <h1 class="page-title">${isEdit ? 'Edit Flight Route' : 'Create Flight Route'}</h1>
                <p class="page-subtitle">Configure origin, destination, and aerial mileage distance for flight operations.</p>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="admin-form-card">
            <div class="admin-form-header">
                <div class="admin-form-icon">🗺</div>
                <div>
                    <h2>Route Details</h2>
                    <p>Choose the origin and destination airports for this sector.</p>
                </div>
            </div>

            <form action="<c:url value='/admin/routes/save' />" method="post" id="routeForm">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${routeDto.id}">
                </c:if>

                <div class="form-group">
                    <label class="form-label" for="sourceAirportId">Origin (Source Airport)</label>
                    <select id="sourceAirportId" name="sourceAirportId" class="form-control" required>
                        <option value="">Select Origin Airport</option>
                        <c:forEach var="airport" items="${airports}">
                            <option value="${airport.id}" ${routeDto.sourceAirportId == airport.id ? 'selected' : ''}>
                                <c:out value="${airport.city} (${airport.airportCode}) - ${airport.airportName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="destinationAirportId">Destination Airport</label>
                    <select id="destinationAirportId" name="destinationAirportId" class="form-control" required>
                        <option value="">Select Destination Airport</option>
                        <c:forEach var="airport" items="${airports}">
                            <option value="${airport.id}" ${routeDto.destinationAirportId == airport.id ? 'selected' : ''}>
                                <c:out value="${airport.city} (${airport.airportCode}) - ${airport.airportName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="distanceKm">Flight Distance (Kilometers)</label>
                    <input type="number" id="distanceKm" name="distanceKm" class="form-control" 
                           placeholder="e.g. 1148" value="${routeDto.distanceKm}" min="1">
                </div>

                <div class="form-group">
                    <label class="form-label" for="status">Route Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE" ${routeDto.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${routeDto.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <c:out value="${isEdit ? 'Update Route' : 'Create Route'}" />
                    </button>
                    <a href="<c:url value='/admin/routes' />" class="btn btn-outline-primary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
document.getElementById('routeForm').addEventListener('submit', function(e) {
    var src = document.getElementById('sourceAirportId').value;
    var dst = document.getElementById('destinationAirportId').value;
    if (src && dst && src === dst) {
        e.preventDefault();
        alert('Validation Error: Source and Destination airports cannot be identical.');
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
