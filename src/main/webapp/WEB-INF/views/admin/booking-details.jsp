<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Booking Details - ${booking.bookingReference}" scope="request" />
<c:set var="isAdminSection" value="true" scope="request" />
<c:set var="activePage" value="admin" scope="request" />
<c:set var="adminActive" value="bookings" scope="request" />
<c:set var="adminPageTitle" value="Inspection: ${booking.bookingReference}" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-back-row with-actions">
            <a href="<c:url value='/admin/bookings' />" class="admin-back-btn">
                <span>&larr;</span> Back to Bookings List
            </a>
            <c:if test="${booking.confirmed}">
                <form action="<c:url value='/admin/bookings/cancel/${booking.id}' />" method="post"
                      onsubmit="return confirm('ADMIN OVERRIDE: Are you sure you want to cancel this customer booking and process a refund?');">
                    <button type="submit" class="btn btn-danger btn-sm">
                        ✕ Cancel Booking (Admin Override)
                    </button>
                </form>
            </c:if>
        </div>

        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🎫 Booking Inspection</span>
                <h1 class="page-title">Reservation Details</h1>
                <p class="page-subtitle">Full customer, flight, passenger and payment record for this booking.</p>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="detail-card">
            <div class="detail-card-header">
                <div>
                    <h3>
                        PNR Reference: <span class="pnr-code"><c:out value="${booking.bookingReference}" /></span>
                    </h3>
                    <small>Booked: <c:out value="${booking.bookingDate}" /></small>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${booking.confirmed}">
                            <span class="badge badge-confirmed badge-lg">Confirmed</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-cancelled badge-lg">Cancelled</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="detail-card-body">
                <!-- Customer & Flight Grid -->
                <div class="detail-grid-2">
                    <div class="detail-panel">
                        <h4>👤 Customer Information</h4>
                        <p><strong>Name:</strong> <c:out value="${booking.user.fullName}" /></p>
                        <p><strong>Email:</strong> <c:out value="${booking.user.email}" /></p>
                        <p><strong>Phone:</strong> <c:out value="${booking.user.phoneNumber}" /></p>
                        <p><strong>Account Status:</strong> <span class="badge badge-active"><c:out value="${booking.user.status}" /></span></p>
                    </div>

                    <div class="detail-panel">
                        <h4>✈ Flight Schedule</h4>
                        <p><strong>Flight Number:</strong> <c:out value="${booking.flight.flightNumber}" /> (<c:out value="${booking.flight.airline.airlineName}" />)</p>
                        <p><strong>Route:</strong> <c:out value="${booking.flight.route.sourceAirport.city} (${booking.flight.route.sourceAirport.airportCode}) → ${booking.flight.route.destinationAirport.city} (${booking.flight.route.destinationAirport.airportCode})" /></p>
                        <p><strong>Departure:</strong> <c:out value="${booking.flight.departureTime}" /></p>
                        <p><strong>Arrival:</strong> <c:out value="${booking.flight.arrivalTime}" /></p>
                    </div>
                </div>

                <!-- Passenger Manifest -->
                <h4 class="detail-section-title">👥 Passenger Manifest (${booking.passengerCount})</h4>
                <div class="detail-table-wrap">
                    <table class="data-table">
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
                                    <td><span class="seat-tag"><c:out value="${passenger.seatNumber}" /></span></td>
                                    <td><c:out value="${passenger.passportOrId != null ? passenger.passportOrId : 'Verified'}" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Payment Record -->
                <h4 class="detail-section-title">💳 Payment Record</h4>
                <div class="detail-grid-4">
                    <div>
                        <span class="detail-label">Transaction Ref</span>
                        <div class="detail-value mono">
                            <c:out value="${booking.payment != null ? booking.payment.transactionReference : 'N/A'}" />
                        </div>
                    </div>
                    <div>
                        <span class="detail-label">Amount</span>
                        <div class="detail-value amount">
                            ₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" />
                        </div>
                    </div>
                    <div>
                        <span class="detail-label">Method</span>
                        <div class="detail-value">
                            <c:out value="${booking.payment != null ? booking.payment.paymentMethod : 'SIMULATED'}" />
                        </div>
                    </div>
                    <div>
                        <span class="detail-label">Status</span>
                        <div>
                            <span class="badge ${booking.payment != null and booking.payment.paymentStatus == 'PAID' ? 'badge-paid' : 'badge-refunded'}">
                                <c:out value="${booking.payment != null ? booking.payment.paymentStatus : 'PAID'}" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
