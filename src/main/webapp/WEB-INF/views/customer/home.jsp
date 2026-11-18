<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="SkyFly Airlines - Seamless Flight Reservations" />
<c:set var="activePage" value="home" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<section class="hero">
    <div class="container">
        <div class="hero-content">
            <span class="hero-badge">✈ Premium Airline Reservation Experience</span>
            <h1 class="hero-title">Fly Higher, Travel Smarter with SkyFly</h1>
            <p class="hero-subtitle">Explore top domestic and international destinations with real-time seat availability, instant booking confirmation, and flexible cancellation.</p>
        </div>

        <div class="search-box">
            <jsp:include page="../common/messages.jsp" />
            <form id="flightSearchForm" action="<c:url value='/flights/search' />" method="get" class="search-form">
                <div class="form-group">
                    <label class="form-label" for="sourceCity">From (Origin)</label>
                    <select id="sourceCity" name="sourceCity" class="form-control" required>
                        <option value="">Select Departure City</option>
                        <c:forEach var="airport" items="${airports}">
                            <option value="${airport.city}">
                                <c:out value="${airport.city} (${airport.airportCode})" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="destinationCity">To (Destination)</label>
                    <select id="destinationCity" name="destinationCity" class="form-control" required>
                        <option value="">Select Destination City</option>
                        <c:forEach var="airport" items="${airports}">
                            <option value="${airport.city}">
                                <c:out value="${airport.city} (${airport.airportCode})" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="departureDate">Departure Date</label>
                    <input type="date" id="departureDate" name="departureDate" class="form-control">
                </div>

                <div class="form-group">
                    <label class="form-label" for="passengers">Passengers</label>
                    <select id="passengers" name="passengers" class="form-control">
                        <option value="1">1 Passenger</option>
                        <option value="2">2 Passengers</option>
                        <option value="3">3 Passengers</option>
                        <option value="4">4 Passengers</option>
                        <option value="5">5 Passengers</option>
                    </select>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%; height: 48px;">
                        <span>🔍 Search</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Featured Flights Section -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Featured Upcoming Flights</h2>
            <p class="section-subtitle">Handpicked departures with guaranteed best fares and available seats.</p>
        </div>

        <div class="flight-list">
            <c:choose>
                <c:when test="${not empty featuredFlights}">
                    <c:forEach var="flight" items="${featuredFlights}">
                        <div class="flight-card">
                            <div class="airline-info">
                                <span class="airline-code-badge"><c:out value="${flight.airline.airlineCode}" /></span>
                                <h3 class="airline-name"><c:out value="${flight.airline.airlineName}" /></h3>
                                <span class="flight-number"><c:out value="${flight.flightNumber}" /></span>
                            </div>

                            <div class="flight-timeline">
                                <div class="time-box">
                                    <h4><c:out value="${flight.departureTime.toLocalTime()}" /></h4>
                                    <p><c:out value="${flight.route.sourceAirport.city} (${flight.route.sourceAirport.airportCode})" /></p>
                                    <small style="color: var(--gray-400);"><c:out value="${flight.departureTime.toLocalDate()}" /></small>
                                </div>

                                <div class="route-indicator">
                                    <span class="flight-duration"><c:out value="${flight.formattedDuration}" /></span>
                                    <div class="route-line"></div>
                                    <span class="seats-badge ${flight.availableSeats > 20 ? 'seats-available' : 'seats-low'}">
                                        <c:out value="${flight.availableSeats}" /> seats left
                                    </span>
                                </div>

                                <div class="time-box">
                                    <h4><c:out value="${flight.arrivalTime.toLocalTime()}" /></h4>
                                    <p><c:out value="${flight.route.destinationAirport.city} (${flight.route.destinationAirport.airportCode})" /></p>
                                    <small style="color: var(--gray-400);"><c:out value="${flight.arrivalTime.toLocalDate()}" /></small>
                                </div>
                            </div>

                            <div class="flight-pricing">
                                <span class="price-label">Price per passenger</span>
                                <span class="price-tag">₹<fmt:formatNumber value="${flight.ticketPrice}" pattern="#,##0" /></span>
                                <a href="<c:url value='/booking/new?flightId=${flight.id}&passengers=1' />" class="btn btn-primary btn-sm">
                                    Book Now →
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="card" style="text-align: center; padding: 40px;">
                        <p style="color: var(--gray-500);">No scheduled flights available right now. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- Why Choose SkyFly -->
<section class="section" style="background-color: var(--white);">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Why Fly with SkyFly?</h2>
            <p class="section-subtitle">Experience seamless aviation booking built with robust modern architecture.</p>
        </div>

        <div class="grid-4">
            <div class="card feature-card">
                <div class="feature-icon">🛡</div>
                <h3>100% Reliable</h3>
                <p>Real-time seat synchronisation backed by ACID database transactions preventing overbooking.</p>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Instant E-Tickets</h3>
                <p>Generate verifiable unique booking references and simulated instant payment confirmations.</p>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">🔄</div>
                <h3>Easy Cancellation</h3>
                <p>One-click self-service ticket cancellation with automated seat restoration and simulated refunds.</p>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">🎓</div>
                <h3>AJT Certified</h3>
                <p>VISIBLY demonstrates Servlets, JSP, JSTL, EL, Spring DI, Hibernate ORM, and direct JDBC.</p>
            </div>
        </div>
    </div>
</section>

<jsp:include page="../common/footer.jsp" />
