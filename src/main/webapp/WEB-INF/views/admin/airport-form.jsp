<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Airport' : 'Add Airport'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="airports" />
<c:set var="adminPageTitle" value="${isEdit ? 'Edit Airport' : 'Add New Airport'}" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <div style="margin-bottom: 24px;">
            <a href="<c:url value='/admin/airports' />" style="font-weight: 600;">← Back to Airports List</a>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="card" style="max-width: 600px;">
            <form action="<c:url value='/admin/airports/save' />" method="post">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${airportDto.id}">
                </c:if>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="airportName">Airport Name</label>
                    <input type="text" id="airportName" name="airportName" class="form-control" 
                           placeholder="e.g. Kempegowda International Airport" value="${airportDto.airportName}" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="airportCode">IATA Airport Code (3 Letters)</label>
                    <input type="text" id="airportCode" name="airportCode" class="form-control" 
                           placeholder="e.g. BLR" value="${airportDto.airportCode}" maxlength="10" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="city">City</label>
                    <input type="text" id="city" name="city" class="form-control" 
                           placeholder="e.g. Bengaluru" value="${airportDto.city}" required>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="country">Country</label>
                    <input type="text" id="country" name="country" class="form-control" 
                           placeholder="e.g. India" value="${airportDto.country}" required>
                </div>

                <div style="display: flex; gap: 12px;">
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
