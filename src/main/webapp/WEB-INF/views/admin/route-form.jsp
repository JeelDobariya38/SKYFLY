<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Route' : 'Add Route'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="routes" />
<c:set var="adminPageTitle" value="${isEdit ? 'Edit Flight Route' : 'Create Flight Route'}" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <div style="margin-bottom: 24px;">
            <a href="<c:url value='/admin/routes' />" style="font-weight: 600;">← Back to Routes List</a>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="card" style="max-width: 600px;">
            <form action="<c:url value='/admin/routes/save' />" method="post" id="routeForm">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${routeDto.id}">
                </c:if>

                <div class="form-group" style="margin-bottom: 16px;">
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

                <div class="form-group" style="margin-bottom: 16px;">
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

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="distanceKm">Flight Distance (Kilometers)</label>
                    <input type="number" id="distanceKm" name="distanceKm" class="form-control" 
                           placeholder="e.g. 1148" value="${routeDto.distanceKm}" min="1">
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="status">Route Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE" ${routeDto.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${routeDto.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div style="display: flex; gap: 12px;">
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
