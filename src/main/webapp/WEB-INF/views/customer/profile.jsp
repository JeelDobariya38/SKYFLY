<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Profile - SkyFly Airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container" style="padding-top: 40px; padding-bottom: 80px;">
    <div style="margin-bottom: 30px;">
        <h1 style="font-size: 2rem; color: var(--primary); font-weight: 800;">Customer Account Profile</h1>
        <p style="color: var(--gray-500);">Manage your personal contact details and security preferences.</p>
    </div>

    <jsp:include page="../common/messages.jsp" />

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: start;">
        <!-- Card 1: Personal Details -->
        <div class="card">
            <h3 style="font-size: 1.25rem; color: var(--primary); margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px;">
                👤 Personal Information
            </h3>

            <form action="<c:url value='/profile/update' />" method="post">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" 
                           value="${user.fullName}" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="email">Email Address (Registered)</label>
                    <input type="email" id="email" class="form-control" 
                           value="${user.email}" disabled style="background: var(--gray-100); color: var(--gray-500);">
                    <small style="color: var(--gray-400);">Email address is your primary login identifier.</small>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" 
                           value="${user.phoneNumber}" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    Save Profile Changes
                </button>
            </form>
        </div>

        <!-- Card 2: Security & Password -->
        <div class="card">
            <h3 style="font-size: 1.25rem; color: var(--primary); margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px;">
                🔒 Security & Password
            </h3>

            <form action="<c:url value='/profile/change-password' />" method="post">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" 
                           placeholder="At least 6 characters" minlength="6" required>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    Update Password
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
