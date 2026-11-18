<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Flight' : 'Schedule Flight'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="flights" />
<c:set var="adminPageTitle" value="${isEdit ? 'Update Flight Schedule' : 'Schedule New Flight'}" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <div style="margin-bottom: 24px;">
            <a href="<c:url value='/admin/flights' />" style="font-weight: 600;">← Back to Flights List</a>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="card" style="max-width: 700px;">
            <form action="<c:url value='/admin/flights/save' />" method="post" id="flightScheduleForm">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${flightDto.id}">
                </c:if>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                    <div class="form-group">
                        <label class="form-label" for="flightNumber">Flight Number</label>
                        <input type="text" id="flightNumber" name="flightNumber" class="form-control" 
                               placeholder="e.g. AI-202" value="${flightDto.flightNumber}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="airlineId">Operating Airline</label>
                        <select id="airlineId" name="airlineId" class="form-control" required>
                            <option value="">Select Airline</option>
                            <c:forEach var="airline" items="${airlines}">
                                <option value="${airline.id}" ${flightDto.airlineId == airline.id ? 'selected' : ''}>
                                    <c:out value="${airline.airlineName} (${airline.airlineCode})" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="routeId">Flight Route</label>
                    <select id="routeId" name="routeId" class="form-control" required>
                        <option value="">Select Flight Route</option>
                        <c:forEach var="route" items="${routes}">
                            <option value="${route.id}" ${flightDto.routeId == route.id ? 'selected' : ''}>
                                <c:out value="${route.sourceAirport.city} (${route.sourceAirport.airportCode}) → ${route.destinationAirport.city} (${route.destinationAirport.airportCode})" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                    <div class="form-group">
                        <label class="form-label" for="departureTime">Departure Date & Time</label>
                        <input type="datetime-local" id="departureTime" name="departureTime" class="form-control" 
                               value="${flightDto.departureTime}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="arrivalTime">Arrival Date & Time</label>
                        <input type="datetime-local" id="arrivalTime" name="arrivalTime" class="form-control" 
                               value="${flightDto.arrivalTime}" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                    <div class="form-group">
                        <label class="form-label" for="totalSeats">Total Capacity</label>
                        <input type="number" id="totalSeats" name="totalSeats" class="form-control" 
                               placeholder="180" value="${flightDto.totalSeats != null ? flightDto.totalSeats : 180}" min="1" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="ticketPrice">Ticket Price (INR)</label>
                        <input type="number" step="0.01" id="ticketPrice" name="ticketPrice" class="form-control" 
                               placeholder="4500.00" value="${flightDto.ticketPrice}" min="1" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="status">Flight Status</label>
                        <select id="status" name="status" class="form-control">
                            <option value="SCHEDULED" ${flightDto.status == 'SCHEDULED' ? 'selected' : ''}>Scheduled</option>
                            <option value="DELAYED" ${flightDto.status == 'DELAYED' ? 'selected' : ''}>Delayed</option>
                            <option value="COMPLETED" ${flightDto.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="CANCELLED" ${flightDto.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                </div>

                <div style="display: flex; gap: 12px;">
                    <button type="submit" class="btn btn-primary">
                        <c:out value="${isEdit ? 'Update Flight' : 'Schedule Flight'}" />
                    </button>
                    <a href="<c:url value='/admin/flights' />" class="btn btn-outline-primary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
document.getElementById('flightScheduleForm').addEventListener('submit', function(e) {
    var dep = document.getElementById('departureTime').value;
    var arr = document.getElementById('arrivalTime').value;
    if (dep && arr && new Date(arr) <= new Date(dep)) {
        e.preventDefault();
        alert('Validation Error: Arrival time must be strictly after departure time.');
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
