<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Administrator Dashboard - SkyFly Airlines" />
<c:set var="isAdminSection" value="true" />
<c:set var="activePage" value="admin" />
<c:set var="adminActive" value="dashboard" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">✈ Operations Control Center</span>
                <h1 class="page-title">Operations & Analytical Dashboard</h1>
                <p class="page-subtitle">Real-time metrics, revenue aggregation, and live flight operations summary.</p>
            </div>
            <div class="admin-page-actions">
                <a href="<c:url value='/admin/flights/new' />" class="btn btn-primary">
                    <span>+ Schedule New Flight</span>
                </a>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <!-- AJT Tech Callout -->
        <div class="ajt-callout">
            <div class="ajt-callout-text">
                <h4>⚡ Advanced Java Technologies (AJT) Architecture Note</h4>
                <p>All analytical statistics below are computed directly via <code>Spring JdbcTemplate</code> raw SQL aggregation queries.</p>
            </div>
            <a href="<c:url value='/servlet/health' />" target="_blank" class="btn btn-sm btn-outline-primary" style="background: var(--white);">
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
                        <span style="color: var(--success); font-weight: 700;"><c:out value="${stats.confirmedBookings}" /> Confirmed</span> &bull; 
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
        <div class="admin-two-col">
            <!-- Top Routes Table Card -->
            <div class="table-card" style="margin-bottom: 0;">
                <div class="table-header">
                    <h3><span>🗺</span> Top Routes by Bookings</h3>
                    <span style="font-size: 0.8rem; color: var(--gray-400); font-weight: 600;">JDBC Query Aggregation</span>
                </div>
                <div class="table-responsive">
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
                                            <td><strong style="color: var(--primary);">₹<fmt:formatNumber value="${item.route_revenue}" pattern="#,##0" /></strong></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" style="text-align: center; color: var(--gray-400); padding: 24px;">No route bookings recorded yet.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Quick Management Shortcuts Card -->
            <div class="card" style="display: flex; flex-direction: column;">
                <h3 style="font-size: 1.15rem; color: var(--primary); margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px; display: flex; align-items: center; gap: 8px;">
                    <span>⚡</span> Quick Operations
                </h3>
                <div style="display: flex; flex-direction: column; gap: 10px; flex: 1;">
                    <a href="<c:url value='/admin/flights/new' />" class="quick-action-link">
                        <span class="quick-action-icon">✈</span>
                        <span>Schedule New Flight</span>
                    </a>
                    <a href="<c:url value='/admin/airlines/new' />" class="quick-action-link">
                        <span class="quick-action-icon">🏢</span>
                        <span>Register New Airline</span>
                    </a>
                    <a href="<c:url value='/admin/airports/new' />" class="quick-action-link">
                        <span class="quick-action-icon">🛫</span>
                        <span>Add New Airport</span>
                    </a>
                    <a href="<c:url value='/admin/routes/new' />" class="quick-action-link">
                        <span class="quick-action-icon">🗺</span>
                        <span>Create New Route</span>
                    </a>
                    <a href="<c:url value='/admin/bookings' />" class="quick-action-link">
                        <span class="quick-action-icon">🎫</span>
                        <span>Inspect All Bookings</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Recent Bookings Table -->
        <div class="table-card">
            <div class="table-header">
                <h3><span>🎫</span> Recent Customer Reservations</h3>
                <a href="<c:url value='/admin/bookings' />" class="btn btn-sm btn-outline-primary">
                    View All Bookings &rarr;
                </a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Reference (PNR)</th>
                            <th>Customer</th>
                            <th>Flight</th>
                            <th>Date</th>
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
                                            <strong style="color: var(--secondary); font-family: monospace; font-size: 0.95rem;">
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
                                            <strong style="color: var(--primary);">₹<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0" /></strong>
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
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
