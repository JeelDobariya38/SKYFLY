<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="admin-sidebar">
    <div class="sidebar-header">
        <a href="<c:url value='/admin/dashboard' />" class="brand" style="font-size: 1.2rem;">
            <div class="brand-icon" style="width: 30px; height: 30px; font-size: 1rem;">✈</div>
            <span>SkyFly Admin</span>
        </a>
    </div>

    <ul class="sidebar-nav">
        <li>
            <a href="<c:url value='/admin/dashboard' />" class="${adminActive == 'dashboard' ? 'active' : ''}">
                <span class="nav-icon">📊</span>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/airlines' />" class="${adminActive == 'airlines' ? 'active' : ''}">
                <span class="nav-icon">🏢</span>
                <span>Airlines</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/airports' />" class="${adminActive == 'airports' ? 'active' : ''}">
                <span class="nav-icon">🛫</span>
                <span>Airports</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/routes' />" class="${adminActive == 'routes' ? 'active' : ''}">
                <span class="nav-icon">🗺</span>
                <span>Routes</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/flights' />" class="${adminActive == 'flights' ? 'active' : ''}">
                <span class="nav-icon">✈</span>
                <span>Flights</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/bookings' />" class="${adminActive == 'bookings' ? 'active' : ''}">
                <span class="nav-icon">🎫</span>
                <span>Bookings</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/users' />" class="${adminActive == 'users' ? 'active' : ''}">
                <span class="nav-icon">👥</span>
                <span>Customers</span>
            </a>
        </li>
        <li style="margin-top: 30px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 10px;">
            <a href="<c:url value='/servlet/health' />" target="_blank" style="color: #38bdf8;">
                <span class="nav-icon">⚡</span>
                <span>AJT Servlet Status</span>
            </a>
        </li>
    </ul>
</aside>
