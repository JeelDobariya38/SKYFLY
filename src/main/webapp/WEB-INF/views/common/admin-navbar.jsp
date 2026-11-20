<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Admin sub-navigation: sits directly beneath the shared client navbar --%>
<nav class="admin-subnav-bar" aria-label="Administrator navigation">
    <div class="container">
        <div class="admin-subnav-inner">
            <div class="admin-subnav-links">
                <a href="<c:url value='/admin/dashboard' />" class="admin-subnav-link ${adminActive == 'dashboard' ? 'active' : ''}">
                    <span class="subnav-icon">📊</span><span>Dashboard</span>
                </a>
                <a href="<c:url value='/admin/airlines' />" class="admin-subnav-link ${adminActive == 'airlines' ? 'active' : ''}">
                    <span class="subnav-icon">🏢</span><span>Airlines</span>
                </a>
                <a href="<c:url value='/admin/airports' />" class="admin-subnav-link ${adminActive == 'airports' ? 'active' : ''}">
                    <span class="subnav-icon">🛫</span><span>Airports</span>
                </a>
                <a href="<c:url value='/admin/routes' />" class="admin-subnav-link ${adminActive == 'routes' ? 'active' : ''}">
                    <span class="subnav-icon">🗺</span><span>Routes</span>
                </a>
                <a href="<c:url value='/admin/flights' />" class="admin-subnav-link ${adminActive == 'flights' ? 'active' : ''}">
                    <span class="subnav-icon">✈</span><span>Flights</span>
                </a>
                <a href="<c:url value='/admin/bookings' />" class="admin-subnav-link ${adminActive == 'bookings' ? 'active' : ''}">
                    <span class="subnav-icon">🎫</span><span>Bookings</span>
                </a>
                <a href="<c:url value='/admin/users' />" class="admin-subnav-link ${adminActive == 'users' ? 'active' : ''}">
                    <span class="subnav-icon">👥</span><span>Customers</span>
                </a>
            </div>
            <div class="admin-subnav-actions">
                <a href="<c:url value='/servlet/health' />" class="subnav-servlet-badge" target="_blank">⚡ Servlet Status</a>
            </div>
        </div>
    </div>
</nav>
