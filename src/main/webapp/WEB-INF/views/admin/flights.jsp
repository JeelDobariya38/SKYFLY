<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Flight Management - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="activePage" value="admin" />
<c:set var="adminActive" value="flights" />
<c:set var="adminPageTitle" value="Flight Schedules & Inventory" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">✈ Flight Operations</span>
                <h1 class="page-title">Flight Schedules & Inventory</h1>
                <p class="page-subtitle">Control scheduled flights, seat capacity, pricing, and operational departure/arrival times.</p>
            </div>
            <div class="admin-page-actions">
                <a href="<c:url value='/admin/flights/new' />" class="btn btn-primary">
                    <span>+ Schedule New Flight</span>
                </a>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3><span>✈</span> Flight Schedules</h3>
                <div class="table-header-tools">
                    <input type="text" id="tableQuickSearch" class="table-search-input" placeholder="🔍 Quick search flights...">
                    <a href="<c:url value='/admin/flights/new' />" class="btn btn-primary btn-sm">
                        + Schedule New Flight
                    </a>
                </div>
            </div>

            <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Flight No</th>
                        <th>Airline</th>
                        <th>Route</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Seat Availability</th>
                        <th>Ticket Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="flight" items="${flights}">
                        <tr>
                            <td>
                                <strong style="color: var(--secondary); font-size: 1rem;">
                                    <c:out value="${flight.flightNumber}" />
                                </strong>
                            </td>
                            <td>
                                <strong><c:out value="${flight.airline.airlineName}" /></strong>
                                <small style="color: var(--gray-400);">(<c:out value="${flight.airline.airlineCode}" />)</small>
                            </td>
                            <td>
                                <c:out value="${flight.route.sourceAirport.city} (${flight.route.sourceAirport.airportCode})" />
                                →
                                <c:out value="${flight.route.destinationAirport.city} (${flight.route.destinationAirport.airportCode})" />
                            </td>
                            <td>
                                <strong><c:out value="${flight.departureTime.toLocalTime()}" /></strong>
                                <div style="font-size: 0.8rem; color: var(--gray-500);"><c:out value="${flight.departureTime.toLocalDate()}" /></div>
                            </td>
                            <td>
                                <strong><c:out value="${flight.arrivalTime.toLocalTime()}" /></strong>
                                <div style="font-size: 0.8rem; color: var(--gray-500);"><c:out value="${flight.arrivalTime.toLocalDate()}" /></div>
                            </td>
                            <td>
                                <div>
                                    <strong style="color: ${flight.availableSeats > 20 ? 'var(--success)' : 'var(--danger)'};">
                                        <c:out value="${flight.availableSeats}" />
                                    </strong>
                                    / <c:out value="${flight.totalSeats}" /> Seats
                                </div>
                            </td>
                            <td>
                                <strong>₹<fmt:formatNumber value="${flight.ticketPrice}" pattern="#,##0" /></strong>
                            </td>
                            <td>
                                <span class="badge ${flight.status == 'SCHEDULED' ? 'badge-scheduled' : (flight.status == 'DELAYED' ? 'badge-delayed' : 'badge-cancelled')}">
                                    <c:out value="${flight.status}" />
                                </span>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="<c:url value='/admin/flights/edit/${flight.id}' />" class="btn btn-outline-primary btn-sm">
                                        Edit
                                    </a>
                                    <form action="<c:url value='/admin/flights/delete/${flight.id}' />" method="post" class="delete-confirm-form" style="display: inline;">
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
