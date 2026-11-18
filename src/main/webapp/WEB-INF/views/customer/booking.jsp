<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Book Flight - SkyFly Airlines" />
<c:set var="activePage" value="flights" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding-top: 40px; padding-bottom: 80px;">
    <div style="margin-bottom: 30px;">
        <a href="javascript:history.back()" style="font-weight: 600; font-size: 0.9rem;">← Back to Flight Search</a>
        <h1 style="font-size: 2rem; color: var(--primary); font-weight: 800; margin-top: 10px;">Complete Your Flight Booking</h1>
        <p style="color: var(--gray-500);">Review itinerary and provide passenger information to issue your e-ticket.</p>
    </div>

    <jsp:include page="../common/messages.jsp" />

    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px; align-items: start;">
        <!-- Left: Passenger Form -->
        <div>
            <form action="<c:url value='/booking/confirm' />" method="post" id="bookingForm">
                <input type="hidden" name="flightId" value="${flight.id}">
                <input type="hidden" name="passengerCount" value="${passengerCount}">

                <!-- Passengers Card -->
                <div class="card" style="margin-bottom: 24px;">
                    <h3 style="font-size: 1.25rem; color: var(--primary); margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                        Passenger Information (${passengerCount} Passenger<c:if test="${passengerCount > 1}">s</c:if>)
                    </h3>

                    <c:forEach var="i" begin="0" end="${passengerCount - 1}">
                        <div style="background: var(--gray-50); border: 1px solid var(--gray-200); border-radius: var(--radius-md); padding: 20px; margin-bottom: 20px;">
                            <h4 style="font-size: 1rem; color: var(--secondary); margin-bottom: 16px;">
                                👤 Passenger ${i + 1} Details
                            </h4>

                            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 16px; margin-bottom: 14px;">
                                <div class="form-group">
                                    <label class="form-label" for="passengerName_${i}">Full Name (as on ID)</label>
                                    <input type="text" id="passengerName_${i}" name="passengers[${i}].fullName" 
                                           class="form-control" placeholder="e.g. John Doe" 
                                           value="${bookingRequest.passengers[i].fullName}" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="passengerAge_${i}">Age</label>
                                    <input type="number" id="passengerAge_${i}" name="passengers[${i}].age" 
                                           class="form-control" min="1" max="120" placeholder="28" 
                                           value="${bookingRequest.passengers[i].age != null ? bookingRequest.passengers[i].age : 25}" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="passengerGender_${i}">Gender</label>
                                    <select id="passengerGender_${i}" name="passengers[${i}].gender" class="form-control" required>
                                        <option value="MALE" ${bookingRequest.passengers[i].gender == 'MALE' ? 'selected' : ''}>Male</option>
                                        <option value="FEMALE" ${bookingRequest.passengers[i].gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                        <option value="OTHER" ${bookingRequest.passengers[i].gender == 'OTHER' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 16px;">
                                <div class="form-group">
                                    <label class="form-label" for="passengerId_${i}">Govt ID / Passport (Optional)</label>
                                    <input type="text" id="passengerId_${i}" name="passengers[${i}].passportOrId" 
                                           class="form-control" placeholder="Aadhaar / Passport / Voter ID" 
                                           value="${bookingRequest.passengers[i].passportOrId}">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="passengerSeat_${i}">Preferred Seat</label>
                                    <input type="text" id="passengerSeat_${i}" name="passengers[${i}].seatNumber" 
                                           class="form-control" placeholder="Auto-assigned" 
                                           value="${bookingRequest.passengers[i].seatNumber}">
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Payment Selection Card -->
                <div class="card" style="margin-bottom: 24px;">
                    <h3 style="font-size: 1.25rem; color: var(--primary); margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                        Payment Method (Academic Demonstration)
                    </h3>
                    <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 16px;">
                        This system uses a simulated payment processor. No real charges will be made.
                    </p>

                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <label style="display: flex; align-items: center; gap: 10px; padding: 12px; border: 1.5px solid var(--secondary); border-radius: var(--radius-md); background: var(--accent-bg); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="SIMULATED" checked>
                            <div>
                                <strong style="color: var(--primary);">Instant Simulated Payment (Recommended)</strong>
                                <div style="font-size: 0.8rem; color: var(--gray-500);">Instant confirmation with auto-generated transaction reference</div>
                            </div>
                        </label>

                        <label style="display: flex; align-items: center; gap: 10px; padding: 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-md); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="CREDIT_CARD">
                            <div>
                                <strong style="color: var(--dark);">Credit / Debit Card (Simulated)</strong>
                                <div style="font-size: 0.8rem; color: var(--gray-500);">Visa, MasterCard, RuPay</div>
                            </div>
                        </label>

                        <label style="display: flex; align-items: center; gap: 10px; padding: 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-md); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="UPI">
                            <div>
                                <strong style="color: var(--dark);">UPI / QR Code (Simulated)</strong>
                                <div style="font-size: 0.8rem; color: var(--gray-500);">Google Pay, PhonePe, Paytm</div>
                            </div>
                        </label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                    Confirm Booking & Pay ₹<fmt:formatNumber value="${totalFare}" pattern="#,##0" /> →
                </button>
            </form>
        </div>

        <!-- Right: Flight Summary Card -->
        <div>
            <div class="card" style="position: sticky; top: 90px;">
                <h3 style="font-size: 1.15rem; color: var(--primary); margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px;">
                    Flight Itinerary
                </h3>

                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
                    <div>
                        <span class="airline-code-badge"><c:out value="${flight.airline.airlineCode}" /></span>
                        <h4 style="font-size: 1.1rem; color: var(--dark); margin-top: 4px;"><c:out value="${flight.airline.airlineName}" /></h4>
                        <span style="font-size: 0.85rem; color: var(--gray-500);"><c:out value="${flight.flightNumber}" /></span>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-size: 0.8rem; color: var(--gray-400);">Aircraft Capacity</span>
                        <div style="font-size: 0.9rem; font-weight: 600;"><c:out value="${flight.totalSeats}" /> Seats</div>
                    </div>
                </div>

                <div style="background: var(--gray-50); border-radius: var(--radius-md); padding: 14px; margin-bottom: 16px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                        <div>
                            <strong><c:out value="${flight.departureTime.toLocalTime()}" /></strong>
                            <div style="font-size: 0.85rem; color: var(--gray-600);"><c:out value="${flight.route.sourceAirport.city}" /></div>
                            <small style="color: var(--gray-400);"><c:out value="${flight.route.sourceAirport.airportCode}" /></small>
                        </div>
                        <div style="text-align: center; font-size: 0.8rem; color: var(--gray-400); align-self: center;">
                            <div>✈ <c:out value="${flight.formattedDuration}" /></div>
                            <div>Direct</div>
                        </div>
                        <div style="text-align: right;">
                            <strong><c:out value="${flight.arrivalTime.toLocalTime()}" /></strong>
                            <div style="font-size: 0.85rem; color: var(--gray-600);"><c:out value="${flight.route.destinationAirport.city}" /></div>
                            <small style="color: var(--gray-400);"><c:out value="${flight.route.destinationAirport.airportCode}" /></small>
                        </div>
                    </div>
                    <div style="font-size: 0.8rem; color: var(--gray-500); border-top: 1px dashed var(--gray-200); padding-top: 8px; margin-top: 8px;">
                        Date: <strong><c:out value="${flight.departureTime.toLocalDate()}" /></strong>
                    </div>
                </div>

                <!-- Fare Breakdown -->
                <div style="border-top: 1px solid var(--gray-200); padding-top: 14px;">
                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 8px;">
                        <span style="color: var(--gray-600);">Base Fare per Ticket:</span>
                        <span>₹<fmt:formatNumber value="${flight.ticketPrice}" pattern="#,##0" /></span>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 8px;">
                        <span style="color: var(--gray-600);">Passenger Count:</span>
                        <span>× ${passengerCount}</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 8px;">
                        <span style="color: var(--gray-600);">Taxes & Airport Surcharges:</span>
                        <span style="color: var(--success); font-weight: 600;">Included</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 800; color: var(--primary); border-top: 1.5px solid var(--gray-200); padding-top: 12px; margin-top: 8px;">
                        <span>Total Fare:</span>
                        <span>₹<fmt:formatNumber value="${totalFare}" pattern="#,##0" /></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
