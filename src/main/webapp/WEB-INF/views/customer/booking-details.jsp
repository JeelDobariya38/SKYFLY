<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Booking Details - ${booking.bookingReference}" />
<c:set var="activePage" value="bookings" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding-top: 40px; padding-bottom: 80px;">
    <div style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
        <div>
            <a href="<c:url value='/my-bookings' />" style="font-weight: 600; font-size: 0.9rem;">← Back to My Bookings</a>
            <h1 style="font-size: 2rem; color: var(--primary); font-weight: 800; margin-top: 10px;">
                Booking Details: <c:out value="${booking.bookingReference}" />
            </h1>
            <p style="color: var(--gray-500);">Booked on <c:out value="${booking.bookingDate.toLocalDate()}" /> at <c:out value="${booking.bookingDate.toLocalTime()}" /></p>
        </div>

        <div>
            <c:choose>
                <c:when test="${booking.confirmed}">
                    <span class="badge badge-confirmed" style="font-size: 0.95rem; padding: 6px 16px;">CONFIRMED</span>
                </c:when>
                <c:otherwise>
                    <span class="badge badge-cancelled" style="font-size: 0.95rem; padding: 6px 16px;">CANCELLED</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="../common/messages.jsp" />

    <div class="ticket-wrapper" style="margin: 0 auto 30px;">
        <div class="ticket-header">
            <div>
                <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9;">Flight Itinerary</span>
                <h2 style="font-size: 1.5rem; font-weight: 800; margin-top: 4px;"><c:out value="${booking.flight.airline.airlineName}" /> (<c:out value="${booking.flight.flightNumber}" />)</h2>
            </div>
            <div style="text-align: right;">
                <span style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9;">Booking Ref</span>
                <div style="font-size: 1.4rem; font-weight: 800; color: #38bdf8;">
                    <c:out value="${booking.bookingReference}" />
                </div>
            </div>
        </div>

        <div class="ticket-body">
            <div class="ticket-row">
                <div>
                    <div class="ticket-label">Departure Airport</div>
                    <div class="ticket-value"><c:out value="${booking.flight.route.sourceAirport.city}" /> (<c:out value="${booking.flight.route.sourceAirport.airportCode}" />)</div>
                    <small style="color: var(--gray-500);"><c:out value="${booking.flight.route.sourceAirport.airportName}" /></small>
                    <div style="margin-top: 4px; font-weight: 700; color: var(--primary);"><c:out value="${booking.flight.departureTime.toLocalDate()}" /> at <c:out value="${booking.flight.departureTime.toLocalTime()}" /></div>
                </div>
                <div>
                    <div class="ticket-label">Arrival Airport</div>
                    <div class="ticket-value"><c:out value="${booking.flight.route.destinationAirport.city}" /> (<c:out value="${booking.flight.route.destinationAirport.airportCode}" />)</div>
                    <small style="color: var(--gray-500);"><c:out value="${booking.flight.route.destinationAirport.airportName}" /></small>
                    <div style="margin-top: 4px; font-weight: 700; color: var(--primary);"><c:out value="${booking.flight.arrivalTime.toLocalDate()}" /> at <c:out value="${booking.flight.arrivalTime.toLocalTime()}" /></div>
                </div>
                <div>
                    <div class="ticket-label">Flight Duration</div>
                    <div class="ticket-value"><c:out value="${booking.flight.formattedDuration}" /></div>
                    <small style="color: var(--gray-500);"><c:out value="${booking.flight.route.distanceKm != null ? booking.flight.route.distanceKm : 1200}" /> km</small>
                </div>
            </div>

            <!-- Passengers -->
            <div style="margin-bottom: 24px;">
                <div class="ticket-label">Passenger Information</div>
                <table class="passenger-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Passenger Name</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Seat Number</th>
                            <th>Identity / Passport</th>
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
            </div>

            <!-- Payment Details -->
            <div class="ticket-row" style="border-bottom: none; margin-bottom: 0; padding-bottom: 0;">
                <div>
                    <div class="ticket-label">Transaction ID</div>
                    <div style="font-family: monospace; font-size: 0.95rem; font-weight: 700;">
                        <c:out value="${booking.payment != null ? booking.payment.transactionReference : 'N/A'}" />
                    </div>
                </div>
                <div>
                    <div class="ticket-label">Payment Method</div>
                    <div style="font-size: 0.95rem; font-weight: 600;">
                        <c:out value="${booking.payment != null ? booking.payment.paymentMethod : 'SIMULATED'}" />
                    </div>
                </div>
                <div>
                    <div class="ticket-label">Payment Status</div>
                    <div>
                        <span class="badge ${booking.payment != null and booking.payment.paymentStatus == 'PAID' ? 'badge-paid' : 'badge-refunded'}">
                            <c:out value="${booking.payment != null ? booking.payment.paymentStatus : 'PAID'}" />
                        </span>
                    </div>
                </div>
                <div>
                    <div class="ticket-label">Total Amount</div>
                    <div class="ticket-value" style="color: var(--primary); font-size: 1.4rem;">
                        ₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Actions -->
    <div style="display: flex; justify-content: center; gap: 16px;">
        <button onclick="window.print()" class="btn btn-outline-primary">
            🖨 Print Itinerary
        </button>
        <c:if test="${booking.canCancel()}">
            <form action="<c:url value='/booking/cancel/${booking.id}' />" method="post"
                  onsubmit="return confirm('Are you sure you want to cancel this booking? A refund will be recorded and your seats will be released.');">
                <button type="submit" class="btn btn-danger">
                    ✕ Cancel Ticket & Request Refund
                </button>
            </form>
        </c:if>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
