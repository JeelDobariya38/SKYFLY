<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Administrator Dashboard - SkyFly" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="dashboard" />
<c:set var="adminPageTitle" value="Operations & Analytical Dashboard" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <jsp:include page="../common/messages.jsp" />

        <!-- AJT Tech Callout -->
        <div style="background: #e0f2fe; border: 1px solid #bae6fd; border-radius: var(--radius-md); padding: 14px 20px; margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between;">
            <div>
                <strong style="color: #0369a1;">⚡ Advanced Java Technologies (AJT) Architecture Note:</strong>
                <span style="color: #0c4a6e; font-size: 0.9rem; margin-left: 8px;">
                    All analytical statistics below are computed directly via <code>Spring JdbcTemplate</code> raw SQL aggregation queries.
                </span>
            </div>
            <a href="<c:url value='/servlet/health' />" target="_blank" class="btn btn-sm btn-primary">
                View Servlet JSON API
            </a>
        </div>

        <!-- KPI Cards Grid -->
        <div class="kpi-grid">
            <div class="kpi-card kpi-revenue">
                <div class="kpi-info">
                    <h3>₹<fmt:formatNumber value="${stats.totalRevenue}" pattern="#,##0" /></h3>
                    <p>Total Recorded Revenue</p>
                </div>
                <div class="kpi-icon">💰</div>
            </div>

            <div class="kpi-card kpi-bookings">
                <div class="kpi-info">
                    <h3><c:out value="${stats.totalBookings}" /></h3>
                    <p>Total Bookings</p>
                    <small style="color: var(--gray-500); font-size: 0.75rem;">
                        <span style="color: var(--success); font-weight: 700;"><c:out value="${stats.confirmedBookings}" /> Confirmed</span> | 
                        <span style="color: var(--danger); font-weight: 700;"><c:out value="${stats.cancelledBookings}" /> Cancelled</span>
                    </small>
                </div>
                <div class="kpi-icon">🎫</div>
            </div>

            <div class="kpi-card kpi-flights">
                <div class="kpi-info">
                    <h3><c:out value="${stats.totalFlights}" /></h3>
                    <p>Active Flights</p>
                </div>
                <div class="kpi-icon">✈</div>
            </div>

            <div class="kpi-card kpi-users">
                <div class="kpi-info">
                    <h3><c:out value="${stats.totalCustomers}" /></h3>
                    <p>Registered Customers</p>
                </div>
                <div class="kpi-icon">👥</div>
            </div>
        </div>

        <!-- Two Columns: Popular Routes & Quick Actions -->
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px; margin-bottom: 30px;">
            <!-- Top Routes -->
            <div class="table-card" style="margin-bottom: 0;">
                <div class="table-header">
                    <h3>Top Routes by Bookings (JDBC Query)</h3>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Route</th>
                            <th>Confirmed Bookings</th>
                            <th>Generated Revenue</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty stats.popularRoutes}">
                                <c:forEach var="item" items="${stats.popularRoutes}">
                                    <tr>
                                        <td><strong><c:out value="${item.route_label}" /></strong></td>
                                        <td><span class="badge badge-active"><c:out value="${item.booking_count}" /> Bookings</span></td>
                                        <td><strong>₹<fmt:formatNumber value="${item.route_revenue}" pattern="#,##0" /></strong></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: var(--gray-400);">No route bookings recorded yet.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Quick Management Shortcuts -->
            <div class="card" style="height: 100%;">
                <h3 style="font-size: 1.15rem; color: var(--primary); margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px;">
                    ⚡ Quick Operations
                </h3>
                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <a href="<c:url value='/admin/flights/new' />" class="btn btn-primary" style="justify-content: flex-start;">
                        <span>+ Schedule New Flight</span>
                    </a>
                    <a href="<c:url value='/admin/airlines/new' />" class="btn btn-outline-primary" style="justify-content: flex-start;">
                        <span>+ Register New Airline</span>
                    </a>
                    <a href="<c:url value='/admin/airports/new' />" class="btn btn-outline-primary" style="justify-content: flex-start;">
                        <span>+ Add New Airport</span>
                    </a>
                    <a href="<c:url value='/admin/routes/new' />" class="btn btn-outline-primary" style="justify-content: flex-start;">
                        <span>+ Create New Route</span>
                    </a>
                    <a href="<c:url value='/admin/bookings' />" class="btn btn-outline-primary" style="justify-content: flex-start;">
                        <span>🔍 Inspect All Bookings</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Recent Bookings Table -->
        <div class="table-card">
            <div class="table-header">
                <h3>Recent Customer Reservations</h3>
                <a href="<c:url value='/admin/bookings' />" class="btn btn-sm btn-outline-primary">
                    View All Bookings →
                </a>
            </div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Customer</th>
                        <th>Flight</th>
                        <th>Date & Time</th>
                        <th>Pax</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty stats.recentBookings}">
                            <c:forEach var="booking" items="${stats.recentBookings}">
                                <tr>
                                    <td>
                                        <strong style="color: var(--secondary); font-family: monospace;">
                                            <c:out value="${booking.bookingReference}" />
                                        </strong>
                                    </td>
                                    <td>
                                        <div><strong><c:out value="${booking.user.fullName}" /></strong></div>
                                        <small style="color: var(--gray-400);"><c:out value="${booking.user.email}" /></small>
                                    </td>
                                    <td>
                                        <strong><c:out value="${booking.flight.flightNumber}" /></strong>
                                        <div style="font-size: 0.8rem; color: var(--gray-500);">
                                            <c:out value="${booking.flight.route.sourceAirport.city} → ${booking.flight.route.destinationAirport.city}" />
                                        </div>
                                    </td>
                                    <td>
                                        <c:out value="${booking.bookingDate.toLocalDate()}" />
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
                                        <a href="<c:url value='/admin/bookings/${booking.id}' />" class="btn btn-sm btn-outline-primary">
                                            Inspect
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" style="text-align: center; color: var(--gray-400); padding: 30px;">
                                    No reservations in database yet.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
