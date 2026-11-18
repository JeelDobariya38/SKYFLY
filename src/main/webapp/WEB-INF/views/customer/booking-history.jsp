<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Bookings - SkyFly Airlines" />
<c:set var="activePage" value="bookings" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding-top: 40px; padding-bottom: 80px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <div>
            <h1 style="font-size: 2rem; color: var(--primary); font-weight: 800;">My Booking History</h1>
            <p style="color: var(--gray-500);">Review and manage your current and past flight reservations.</p>
        </div>
        <a href="<c:url value='/flights/search' />" class="btn btn-primary">
            + Book New Flight
        </a>
    </div>

    <jsp:include page="../common/messages.jsp" />

    <c:choose>
        <c:when test="${not empty bookings}">
            <div class="table-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Reference (PNR)</th>
                            <th>Flight</th>
                            <th>Route</th>
                            <th>Departure Date & Time</th>
                            <th>Pax</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>
                                    <strong style="color: var(--secondary); font-family: monospace; font-size: 1rem;">
                                        <c:out value="${booking.bookingReference}" />
                                    </strong>
                                    <div style="font-size: 0.75rem; color: var(--gray-400);">
                                        <c:out value="${booking.bookingDate.toLocalDate()}" />
                                    </div>
                                </td>
                                <td>
                                    <strong><c:out value="${booking.flight.flightNumber}" /></strong>
                                    <div style="font-size: 0.8rem; color: var(--gray-500);">
                                        <c:out value="${booking.flight.airline.airlineName}" />
                                    </div>
                                </td>
                                <td>
                                    <c:out value="${booking.flight.route.sourceAirport.city} (${booking.flight.route.sourceAirport.airportCode})" />
                                    →
                                    <c:out value="${booking.flight.route.destinationAirport.city} (${booking.flight.route.destinationAirport.airportCode})" />
                                </td>
                                <td>
                                    <strong><c:out value="${booking.flight.departureTime.toLocalTime()}" /></strong>
                                    <div style="font-size: 0.8rem; color: var(--gray-500);">
                                        <c:out value="${booking.flight.departureTime.toLocalDate()}" />
                                    </div>
                                </td>
                                <td>
                                    <c:out value="${booking.passengerCount}" />
                                </td>
                                <td>
                                    <strong style="color: var(--primary);">
                                        ₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" />
                                    </strong>
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
                                    <div class="action-btns">
                                        <a href="<c:url value='/booking/details/${booking.bookingReference}' />" class="btn btn-outline-primary btn-sm">
                                            Details
                                        </a>
                                        <c:if test="${booking.canCancel()}">
                                            <form action="<c:url value='/booking/cancel/${booking.id}' />" method="post" style="display: inline;"
                                                  onsubmit="return confirm('Are you sure you want to cancel booking ${booking.bookingReference}? Your seat will be restored and payment refunded.');">
                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card" style="text-align: center; padding: 60px 20px;">
                <div style="font-size: 3rem; margin-bottom: 16px;">🎫</div>
                <h3 style="font-size: 1.4rem; color: var(--primary); margin-bottom: 8px;">No Bookings Found</h3>
                <p style="color: var(--gray-500); max-width: 480px; margin: 0 auto 24px;">
                    You haven't made any flight bookings yet. Search flights and book your first journey today!
                </p>
                <a href="<c:url value='/flights/search' />" class="btn btn-primary">
                    Search Flights Now
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />
