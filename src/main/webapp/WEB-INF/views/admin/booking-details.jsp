<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Booking Details - ${booking.bookingReference}" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="bookings" />
<c:set var="adminPageTitle" value="Inspection: ${booking.bookingReference}" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center;">
            <a href="<c:url value='/admin/bookings' />" style="font-weight: 600;">← Back to Bookings List</a>
            <c:if test="${booking.confirmed}">
                <form action="<c:url value='/admin/bookings/cancel/${booking.id}' />" method="post"
                      onsubmit="return confirm('ADMIN OVERRIDE: Are you sure you want to cancel this customer booking and process a refund?');">
                    <button type="submit" class="btn btn-danger btn-sm">
                        ✕ Cancel Booking (Admin Override)
                    </button>
                </form>
            </c:if>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="card" style="margin-bottom: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--gray-200); padding-bottom: 16px; margin-bottom: 16px;">
                <div>
                    <h3 style="font-size: 1.3rem; color: var(--primary);">
                        PNR Reference: <span style="color: var(--secondary); font-family: monospace;"><c:out value="${booking.bookingReference}" /></span>
                    </h3>
                    <small style="color: var(--gray-500);">Booked: <c:out value="${booking.bookingDate}" /></small>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${booking.confirmed}">
                            <span class="badge badge-confirmed" style="font-size: 0.9rem; padding: 6px 14px;">Confirmed</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-cancelled" style="font-size: 0.9rem; padding: 6px 14px;">Cancelled</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Customer & Flight Grid -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
                <div style="background: var(--gray-50); padding: 18px; border-radius: var(--radius-md);">
                    <h4 style="color: var(--primary); margin-bottom: 10px;">👤 Customer Information</h4>
                    <p><strong>Name:</strong> <c:out value="${booking.user.fullName}" /></p>
                    <p><strong>Email:</strong> <c:out value="${booking.user.email}" /></p>
                    <p><strong>Phone:</strong> <c:out value="${booking.user.phoneNumber}" /></p>
                    <p><strong>Account Status:</strong> <span class="badge badge-active"><c:out value="${booking.user.status}" /></span></p>
                </div>

                <div style="background: var(--gray-50); padding: 18px; border-radius: var(--radius-md);">
                    <h4 style="color: var(--primary); margin-bottom: 10px;">✈ Flight Schedule</h4>
                    <p><strong>Flight Number:</strong> <c:out value="${booking.flight.flightNumber}" /> (<c:out value="${booking.flight.airline.airlineName}" />)</p>
                    <p><strong>Route:</strong> <c:out value="${booking.flight.route.sourceAirport.city} (${booking.flight.route.sourceAirport.airportCode}) → ${booking.flight.route.destinationAirport.city} (${booking.flight.route.destinationAirport.airportCode})" /></p>
                    <p><strong>Departure:</strong> <c:out value="${booking.flight.departureTime}" /></p>
                    <p><strong>Arrival:</strong> <c:out value="${booking.flight.arrivalTime}" /></p>
                </div>
            </div>

            <!-- Passenger Manifest -->
            <h4 style="color: var(--primary); margin-bottom: 12px;">👥 Passenger Manifest (${booking.passengerCount})</h4>
            <table class="data-table" style="margin-bottom: 24px;">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Passenger Name</th>
                        <th>Age</th>
                        <th>Gender</th>
                        <th>Seat</th>
                        <th>ID / Passport</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="passenger" items="${booking.passengers}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td><strong><c:out value="${passenger.fullName}" /></strong></td>
                            <td><c:out value="${passenger.age}" /></td>
                            <td><c:out value="${passenger.gender}" /></td>
                            <td><span style="font-weight: 700; color: var(--secondary);"><c:out value="${passenger.seatNumber}" /></span></td>
                            <td><c:out value="${passenger.passportOrId != null ? passenger.passportOrId : 'Verified'}" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Payment Record -->
            <h4 style="color: var(--primary); margin-bottom: 12px;">💳 Payment Record</h4>
            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; background: var(--gray-50); padding: 18px; border-radius: var(--radius-md);">
                <div>
                    <span style="font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">Transaction Ref</span>
                    <div style="font-family: monospace; font-weight: 700;">
                        <c:out value="${booking.payment != null ? booking.payment.transactionReference : 'N/A'}" />
                    </div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">Amount</span>
                    <div style="font-size: 1.2rem; font-weight: 800; color: var(--primary);">
                        ₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" />
                    </div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">Method</span>
                    <div style="font-weight: 600;">
                        <c:out value="${booking.payment != null ? booking.payment.paymentMethod : 'SIMULATED'}" />
                    </div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">Status</span>
                    <div>
                        <span class="badge ${booking.payment != null and booking.payment.paymentStatus == 'PAID' ? 'badge-paid' : 'badge-refunded'}">
                            <c:out value="${booking.payment != null ? booking.payment.paymentStatus : 'PAID'}" />
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
