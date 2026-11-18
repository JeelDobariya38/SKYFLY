<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Booking Confirmed - SkyFly Airlines" />
<c:set var="activePage" value="bookings" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding-top: 40px; padding-bottom: 80px;">
    <!-- Success Banner -->
    <div style="text-align: center; max-width: 600px; margin: 0 auto 30px;">
        <div style="width: 70px; height: 70px; background: #ecfdf5; color: var(--success); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 16px;">
            ✓
        </div>
        <h1 style="font-size: 2.2rem; color: var(--primary); font-weight: 800; margin-bottom: 8px;">Booking Confirmed!</h1>
        <p style="color: var(--gray-500); font-size: 1.05rem;">
            Thank you for booking with SkyFly Airlines. Your e-ticket has been generated and confirmed in the reservation database.
        </p>
    </div>

    <!-- E-Ticket Card -->
    <div class="ticket-wrapper">
        <div class="ticket-header">
            <div>
                <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9;">Official Boarding E-Ticket</span>
                <h2 style="font-size: 1.6rem; font-weight: 800; margin-top: 4px;">SkyFly Airlines</h2>
            </div>
            <div style="text-align: right;">
                <span style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9;">Booking Reference (PNR)</span>
                <div style="font-size: 1.5rem; font-weight: 800; letter-spacing: 2px; color: #38bdf8;">
                    <c:out value="${booking.bookingReference}" />
                </div>
            </div>
        </div>

        <div class="ticket-body">
            <!-- Row 1: Flight details -->
            <div class="ticket-row">
                <div>
                    <div class="ticket-label">Flight Number</div>
                    <div class="ticket-value"><c:out value="${booking.flight.flightNumber}" /></div>
                    <small style="color: var(--gray-500);"><c:out value="${booking.flight.airline.airlineName}" /></small>
                </div>
                <div>
                    <div class="ticket-label">Departure</div>
                    <div class="ticket-value"><c:out value="${booking.flight.departureTime.toLocalTime()}" /></div>
                    <div style="font-size: 0.9rem; color: var(--gray-700);"><c:out value="${booking.flight.route.sourceAirport.city} (${booking.flight.route.sourceAirport.airportCode})" /></div>
                    <small style="color: var(--gray-400);"><c:out value="${booking.flight.departureTime.toLocalDate()}" /></small>
                </div>
                <div>
                    <div class="ticket-label">Arrival</div>
                    <div class="ticket-value"><c:out value="${booking.flight.arrivalTime.toLocalTime()}" /></div>
                    <div style="font-size: 0.9rem; color: var(--gray-700);"><c:out value="${booking.flight.route.destinationAirport.city} (${booking.flight.route.destinationAirport.airportCode})" /></div>
                    <small style="color: var(--gray-400);"><c:out value="${booking.flight.arrivalTime.toLocalDate()}" /></small>
                </div>
                <div>
                    <div class="ticket-label">Status</div>
                    <div>
                        <span class="badge badge-confirmed"><c:out value="${booking.bookingStatus}" /></span>
                    </div>
                </div>
            </div>

            <!-- Row 2: Passengers List -->
            <div style="margin-bottom: 24px;">
                <div class="ticket-label">Passenger Manifest (${booking.passengerCount} Passenger<c:if test="${booking.passengerCount > 1}">s</c:if>)</div>
                <table class="passenger-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Passenger Name</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Seat Number</th>
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
                                <td><c:out value="${passenger.passportOrId != null ? passenger.passportOrId : 'N/A'}" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Row 3: Payment details -->
            <div class="ticket-row" style="border-bottom: none; margin-bottom: 0; padding-bottom: 0;">
                <div>
                    <div class="ticket-label">Transaction Reference</div>
                    <div class="ticket-value" style="font-size: 0.95rem; font-family: monospace;">
                        <c:out value="${booking.payment != null ? booking.payment.transactionReference : 'SIM-TXN-OK'}" />
                    </div>
                </div>
                <div>
                    <div class="ticket-label">Payment Status</div>
                    <div>
                        <span class="badge badge-paid">
                            <c:out value="${booking.payment != null ? booking.payment.paymentStatus : 'PAID'}" />
                        </span>
                    </div>
                </div>
                <div>
                    <div class="ticket-label">Payment Method</div>
                    <div style="font-size: 0.95rem; font-weight: 600;">
                        <c:out value="${booking.payment != null ? booking.payment.paymentMethod : 'SIMULATED'}" />
                    </div>
                </div>
                <div>
                    <div class="ticket-label">Total Amount Paid</div>
                    <div class="ticket-value" style="color: var(--primary); font-size: 1.4rem;">
                        ₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Actions -->
    <div style="display: flex; justify-content: center; gap: 16px; margin-top: 30px;">
        <button onclick="window.print()" class="btn btn-outline-primary">
            🖨 Print Ticket
        </button>
        <a href="<c:url value='/my-bookings' />" class="btn btn-primary">
            View All My Bookings →
        </a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
