<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="navbar">
    <div class="container">
        <a href="<c:url value='/' />" class="brand">
            <div class="brand-icon">✈</div>
            <span>SkyFly Airlines</span>
        </a>

        <ul class="nav-links">
            <li><a href="<c:url value='/' />" class="${activePage == 'home' ? 'active' : ''}">Home</a></li>
            <li><a href="<c:url value='/flights/search' />" class="${activePage == 'flights' ? 'active' : ''}">Search Flights</a></li>
            <c:if test="${not empty sessionScope.currentUser}">
                <li><a href="<c:url value='/my-bookings' />" class="${activePage == 'bookings' ? 'active' : ''}">My Bookings</a></li>
            </c:if>
            <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
                <li><a href="<c:url value='/admin/dashboard' />" style="color: #38bdf8; font-weight: 700;">Admin Dashboard</a></li>
            </c:if>
        </ul>

        <div class="nav-auth">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <a href="<c:url value='/profile' />" class="btn btn-outline btn-sm">
                        <span>👤 <c:out value="${sessionScope.currentUser.fullName}" /></span>
                    </a>
                    <a href="<c:url value='/logout' />" class="btn btn-primary btn-sm">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/login' />" class="btn btn-outline btn-sm">Log In</a>
                    <a href="<c:url value='/register' />" class="btn btn-primary btn-sm">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
