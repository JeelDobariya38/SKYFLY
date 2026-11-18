<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Create Account - SkyFly Airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <div class="brand-icon" style="margin: 0 auto 12px; width: 44px; height: 44px; font-size: 1.4rem;">✈</div>
            <h2>Create Account</h2>
            <p>Join SkyFly Airlines for personalized bookings & travel perks</p>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <form action="<c:url value='/register' />" method="post">
            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control" 
                       placeholder="e.g. John Doe" value="${registrationRequest.fullName}" required>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" 
                       placeholder="name@example.com" value="${registrationRequest.email}" required>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" for="phoneNumber">Phone Number</label>
                <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" 
                       placeholder="+91 9876543210" value="${registrationRequest.phoneNumber}" required>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" 
                       placeholder="At least 6 characters" minlength="6" required>
            </div>

            <div class="form-group" style="margin-bottom: 22px;">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                       placeholder="Re-enter password" required>
            </div>

            <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-bottom: 20px;">
                Create Account →
            </button>
        </form>

        <div style="text-align: center; font-size: 0.9rem; color: var(--gray-500); border-top: 1px solid var(--gray-200); padding-top: 18px;">
            Already have an account? 
            <a href="<c:url value='/login' />" style="font-weight: 700;">Sign in here</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
