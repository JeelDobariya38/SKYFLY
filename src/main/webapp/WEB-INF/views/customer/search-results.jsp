<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Search Results - SkyFly Airlines" />
<c:set var="activePage" value="flights" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding-top: 30px; padding-bottom: 60px;">
    <!-- Search Query Bar -->
    <div class="card" style="margin-bottom: 30px; padding: 20px 24px;">
        <form id="flightSearchForm" action="<c:url value='/flights/search' />" method="get" class="search-form" style="margin: 0;">
            <div class="form-group">
                <label class="form-label" for="sourceCity">From</label>
                <select id="sourceCity" name="sourceCity" class="form-control" required>
                    <option value="">Origin City</option>
                    <c:forEach var="airport" items="${airports}">
                        <option value="${airport.city}" ${searchRequest.sourceCity == airport.city ? 'selected' : ''}>
                            <c:out value="${airport.city} (${airport.airportCode})" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="destinationCity">To</label>
                <select id="destinationCity" name="destinationCity" class="form-control" required>
                    <option value="">Destination City</option>
                    <c:forEach var="airport" items="${airports}">
                        <option value="${airport.city}" ${searchRequest.destinationCity == airport.city ? 'selected' : ''}>
                            <c:out value="${airport.city} (${airport.airportCode})" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="departureDate">Date</label>
                <input type="date" id="departureDate" name="departureDate" class="form-control" value="${searchRequest.departureDate}">
            </div>

            <div class="form-group">
                <label class="form-label" for="passengers">Passengers</label>
                <select id="passengers" name="passengers" class="form-control">
                    <option value="1" ${searchRequest.passengers == 1 ? 'selected' : ''}>1 Passenger</option>
                    <option value="2" ${searchRequest.passengers == 2 ? 'selected' : ''}>2 Passengers</option>
                    <option value="3" ${searchRequest.passengers == 3 ? 'selected' : ''}>3 Passengers</option>
                    <option value="4" ${searchRequest.passengers == 4 ? 'selected' : ''}>4 Passengers</option>
                    <option value="5" ${searchRequest.passengers == 5 ? 'selected' : ''}>5 Passengers</option>
                </select>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary" style="width: 100%; height: 46px;">
                    Update Search
                </button>
            </div>
        </form>
    </div>

    <!-- Results Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <div>
            <h2 style="font-size: 1.5rem; color: var(--primary); font-weight: 800;">
                <c:choose>
                    <c:when test="${not empty searchRequest.sourceCity and not empty searchRequest.destinationCity}">
                        Flights: <c:out value="${searchRequest.sourceCity}" /> → <c:out value="${searchRequest.destinationCity}" />
                    </c:when>
                    <c:otherwise>
                        Available Flights
                    </c:otherwise>
                </c:choose>
            </h2>
            <p style="color: var(--gray-500); font-size: 0.9rem;">
                Showing <c:out value="${resultCount}" /> available flight(s) matching your criteria.
            </p>
        </div>
    </div>

    <!-- Flight Results List -->
    <c:choose>
        <c:when test="${not empty flights}">
            <c:forEach var="flight" items="${flights}">
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
                        <span class="price-label">Per Passenger</span>
                        <span class="price-tag">₹<fmt:formatNumber value="${flight.ticketPrice}" pattern="#,##0" /></span>
                        <c:set var="totalForGroup" value="${flight.ticketPrice * searchRequest.passengers}" />
                        <c:if test="${searchRequest.passengers > 1}">
                            <small style="color: var(--gray-500); font-size: 0.8rem;">
                                Total (${searchRequest.passengers} pax): ₹<fmt:formatNumber value="${totalForGroup}" pattern="#,##0" />
                            </small>
                        </c:if>
                        <a href="<c:url value='/booking/new?flightId=${flight.id}&passengers=${searchRequest.passengers}' />" class="btn btn-primary btn-sm" style="margin-top: 4px;">
                            Book Now →
                        </a>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="card" style="text-align: center; padding: 60px 20px;">
                <div style="font-size: 3rem; margin-bottom: 16px;">✈</div>
                <h3 style="font-size: 1.4rem; color: var(--primary); margin-bottom: 8px;">No Flights Found</h3>
                <p style="color: var(--gray-500); max-width: 500px; margin: 0 auto 24px;">
                    We couldn't find any scheduled flights matching your exact route or date. Try selecting a different date or search among all scheduled departures.
                </p>
                <a href="<c:url value='/flights/search' />" class="btn btn-primary">
                    View All Scheduled Flights
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />
