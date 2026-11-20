<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Airport' : 'Add Airport'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="activePage" value="admin" />
<c:set var="adminActive" value="airports" />
<c:set var="adminPageTitle" value="${isEdit ? 'Edit Airport' : 'Add New Airport'}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div class="admin-back-row">
            <a href="<c:url value='/admin/airports' />" class="admin-back-btn">
                <span>&larr;</span> Back to Airports List
            </a>
        </div>

        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🛫 Airport Registry</span>
                <h1 class="page-title">${isEdit ? 'Edit Airport' : 'Add New Airport'}</h1>
                <p class="page-subtitle">Fill out the airport details below to update or register the terminal location.</p>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="admin-form-card">
            <div class="admin-form-header">
                <div class="admin-form-icon">🛫</div>
                <div>
                    <h2>Airport Details</h2>
                    <p>Enter the airport name, IATA code and location below.</p>
                </div>
            </div>

            <form action="<c:url value='/admin/airports/save' />" method="post">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${airportDto.id}">
                </c:if>

                <div class="form-group">
                    <label class="form-label" for="airportName">Airport Name</label>
                    <input type="text" id="airportName" name="airportName" class="form-control" 
                           placeholder="e.g. Kempegowda International Airport" value="${airportDto.airportName}" required>
                </div>

                <div class="form-group" style="max-width: 320px;">
                    <label class="form-label" for="airportCode">IATA Airport Code (3 Letters)</label>
                    <input type="text" id="airportCode" name="airportCode" class="form-control" 
                           placeholder="e.g. BLR" value="${airportDto.airportCode}" maxlength="10" required>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label" for="city">City</label>
                        <input type="text" id="city" name="city" class="form-control" 
                               placeholder="e.g. Bengaluru" value="${airportDto.city}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="country">Country</label>
                        <input type="text" id="country" name="country" class="form-control" 
                               placeholder="e.g. India" value="${airportDto.country}" required>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <c:out value="${isEdit ? 'Update Airport' : 'Save Airport'}" />
                    </button>
                    <a href="<c:url value='/admin/airports' />" class="btn btn-outline-primary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
