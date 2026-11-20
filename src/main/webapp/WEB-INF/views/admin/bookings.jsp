<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Booking Management - SkyFly Admin" scope="request" />
<c:set var="isAdminSection" value="true" scope="request" />
<c:set var="activePage" value="admin" scope="request" />
<c:set var="adminActive" value="bookings" scope="request" />
<c:set var="adminPageTitle" value="Reservation & Passenger Bookings" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🎫 Reservations Desk</span>
                <h1 class="page-title">Reservation & Passenger Bookings</h1>
                <p class="page-subtitle">Search, filter and inspect every customer reservation and its payment status.</p>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3><span>🎫</span> Passenger Reservations</h3>
                <form action="<c:url value='/admin/bookings' />" method="get" class="table-search-form">
                    <input type="text" name="keyword" class="table-search-input" 
                           placeholder="🔍 Search by PNR, customer or flight..." value="${keyword}">
                    <select name="status" class="table-search-input" style="min-width: 140px;" onchange="this.form.submit()">
                        <option value="">All Statuses</option>
                        <option value="CONFIRMED" ${selectedStatus == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                        <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                    <c:if test="${not empty keyword or not empty selectedStatus}">
                        <a href="<c:url value='/admin/bookings' />" class="btn btn-sm btn-outline-primary">Reset</a>
                    </c:if>
                </form>
            </div>

            <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Booked On</th>
                        <th>Customer</th>
                        <th>Flight</th>
                        <th>Route</th>
                        <th>Pax</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty bookings}">
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td>
                                        <strong style="color: var(--secondary); font-family: monospace; font-size: 0.95rem;">
                                            <c:out value="${booking.bookingReference}" />
                                        </strong>
                                    </td>
                                    <td>
                                        <c:out value="${booking.bookingDate.toLocalDate()}" />
                                        <div style="font-size: 0.75rem; color: var(--gray-400);"><c:out value="${booking.bookingDate.toLocalTime()}" /></div>
                                    </td>
                                    <td>
                                        <strong><c:out value="${booking.user.fullName}" /></strong>
                                        <div style="font-size: 0.8rem; color: var(--gray-500);"><c:out value="${booking.user.email}" /></div>
                                    </td>
                                    <td>
                                        <strong><c:out value="${booking.flight.flightNumber}" /></strong>
                                        <div style="font-size: 0.75rem; color: var(--gray-400);"><c:out value="${booking.flight.airline.airlineName}" /></div>
                                    </td>
                                    <td>
                                        <c:out value="${booking.flight.route.sourceAirport.city} (${booking.flight.route.sourceAirport.airportCode})" />
                                        →
                                        <c:out value="${booking.flight.route.destinationAirport.city} (${booking.flight.route.destinationAirport.airportCode})" />
                                    </td>
                                    <td><c:out value="${booking.passengerCount}" /></td>
                                    <td>
                                        <strong>₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" /></strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.confirmed}">
                                                <span class="badge badge-confirmed">Confirmed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-cancelled">Cancelled</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="<c:url value='/admin/bookings/${booking.id}' />" class="btn btn-outline-primary btn-sm">
                                            Inspect
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" style="text-align: center; color: var(--gray-400); padding: 30px;">
                                    No bookings found matching criteria.
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
