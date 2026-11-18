<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <a href="<c:url value='/' />" class="brand">
                    <div class="brand-icon">✈</div>
                    <span>SkyFly Airlines</span>
                </a>
                <p>Advanced Java Technologies (AJT) Academic Project — A full-stack airline reservation and ticket booking platform built with Spring Boot, Servlets, JSP, JSTL, Hibernate JPA & MySQL.</p>
            </div>
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="<c:url value='/' />">Home</a></li>
                    <li><a href="<c:url value='/flights/search' />">Search Flights</a></li>
                    <li><a href="<c:url value='/my-bookings' />">My Bookings</a></li>
                    <li><a href="<c:url value='/login' />">Customer Login</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Technology Stack</h4>
                <ul>
                    <li><a href="<c:url value='/servlet/health' />" target="_blank">Health Check Servlet</a></li>
                    <li><a href="<c:url value='/app-info' />" target="_blank">App Info Servlet</a></li>
                    <li><a href="#">Spring Boot 3.4.5</a></li>
                    <li><a href="#">Hibernate ORM & JDBC</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Academic Evaluation</h4>
                <ul>
                    <li><a href="#">Marwadi University</a></li>
                    <li><a href="#">AJT Semester Project</a></li>
                    <li><a href="<c:url value='/admin/dashboard' />">Admin Portal</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 SkyFly Airlines. All rights reserved. Academic Demonstration Build.</p>
            <p>Servlet Endpoint: <a href="<c:url value='/servlet/health' />" style="color: #38bdf8;">/servlet/health</a></p>
        </div>
    </div>
</footer>

<script src="<c:url value='/js/main.js' />"></script>
<c:if test="${isAdminSection}">
    <script src="<c:url value='/js/admin.js' />"></script>
</c:if>
</body>
</html>
