<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Airline' : 'Add Airline'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="activePage" value="admin" />
<c:set var="adminActive" value="airlines" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/admin-navbar.jsp" />

<main class="admin-main">
    <div class="admin-content">
        <div style="margin-bottom: 20px;">
            <a href="<c:url value='/admin/airlines' />" class="admin-back-btn">
                <span>&larr;</span> Back to Airlines List
            </a>
        </div>

        <div class="admin-page-header">
            <div>
                <span class="admin-header-pill">🏢 Airline Registry</span>
                <h1 class="page-title">${isEdit ? 'Edit Airline Carrier' : 'Register New Airline Carrier'}</h1>
                <p class="page-subtitle">Configure carrier identification, operational status, and fleet information.</p>
            </div>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="admin-form-card">
            <div class="admin-form-header">
                <div class="admin-form-icon">🏢</div>
                <div>
                    <h2>${isEdit ? 'Update Airline Details' : 'Carrier Information'}</h2>
                    <p>Enter the commercial flight operator credentials below.</p>
                </div>
            </div>

            <form action="<c:url value='/admin/airlines/save' />" method="post">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${airlineDto.id}">
                </c:if>

                <div class="form-grid-2" style="margin-bottom: 16px;">
                    <div class="form-group">
                        <label class="form-label" for="airlineName">Airline Name</label>
                        <input type="text" id="airlineName" name="airlineName" class="form-control" 
                               placeholder="e.g. Singapore Airlines" value="${airlineDto.airlineName}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="airlineCode">Carrier Code</label>
                        <input type="text" id="airlineCode" name="airlineCode" class="form-control" 
                               placeholder="e.g. SQ" value="${airlineDto.airlineCode}" maxlength="10" required>
                        <span class="form-hint">2 to 4 alphanumeric characters (e.g. AI, 6E, SQ)</span>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="description">Fleet & Description</label>
                    <textarea id="description" name="description" class="form-control" rows="3" 
                              placeholder="Brief description of operations, fleet aircraft, or service standards.">${airlineDto.description}</textarea>
                </div>

                <div class="form-group" style="margin-bottom: 20px; max-width: 320px;">
                    <label class="form-label" for="status">Operating Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE" ${airlineDto.status == 'ACTIVE' ? 'selected' : ''}>Active (Available for Scheduling)</option>
                        <option value="INACTIVE" ${airlineDto.status == 'INACTIVE' ? 'selected' : ''}>Inactive (Suspended)</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <c:out value="${isEdit ? 'Update Airline' : 'Save Airline'}" />
                    </button>
                    <a href="<c:url value='/admin/airlines' />" class="btn btn-outline-primary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
