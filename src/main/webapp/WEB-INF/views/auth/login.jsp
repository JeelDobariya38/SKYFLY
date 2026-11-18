<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In - SkyFly Airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <div class="brand-icon" style="margin: 0 auto 12px; width: 44px; height: 44px; font-size: 1.4rem;">✈</div>
            <h2>Welcome Back</h2>
            <p>Sign in to your SkyFly account to manage bookings</p>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <!-- Academic Demo Credentials Box -->
        <div class="demo-credentials-box">
            <h4>⚡ AJT Academic Demonstration Credentials</h4>
            <p style="color: var(--gray-600); font-size: 0.8rem; margin-bottom: 8px;">Click to auto-populate credentials for instant testing:</p>
            <div class="demo-btn-group">
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="fillDemoCredentials('admin@skyfly.com', 'Admin@123')">
                    👑 Admin Demo
                </button>
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="fillDemoCredentials('customer@skyfly.com', 'Customer@123')">
                    👤 Customer Demo
                </button>
            </div>
        </div>

        <form action="<c:url value='/login' />" method="post">
            <c:if test="${not empty returnUrl}">
                <input type="hidden" name="returnUrl" value="${returnUrl}">
            </c:if>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label" for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" 
                       placeholder="name@example.com" value="${loginRequest.email}" required autofocus>
            </div>

            <div class="form-group" style="margin-bottom: 24px;">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" 
                       placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-bottom: 20px;">
                Sign In →
            </button>
        </form>

        <div style="text-align: center; font-size: 0.9rem; color: var(--gray-500); border-top: 1px solid var(--gray-200); padding-top: 18px;">
            Don't have an account yet? 
            <a href="<c:url value='/register' />" style="font-weight: 700;">Create an account</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
