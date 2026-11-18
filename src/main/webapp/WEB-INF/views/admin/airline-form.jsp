<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Airline' : 'Add Airline'} - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="airlines" />
<c:set var="adminPageTitle" value="${isEdit ? 'Edit Airline Carrier' : 'Register New Airline Carrier'}" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <div style="margin-bottom: 24px;">
            <a href="<c:url value='/admin/airlines' />" style="font-weight: 600;">← Back to Airlines List</a>
        </div>

        <jsp:include page="../common/messages.jsp" />

        <div class="card" style="max-width: 600px;">
            <form action="<c:url value='/admin/airlines/save' />" method="post">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${airlineDto.id}">
                </c:if>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="airlineName">Airline Name</label>
                    <input type="text" id="airlineName" name="airlineName" class="form-control" 
                           placeholder="e.g. Singapore Airlines" value="${airlineDto.airlineName}" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="airlineCode">Carrier Code (2-4 Characters)</label>
                    <input type="text" id="airlineCode" name="airlineCode" class="form-control" 
                           placeholder="e.g. SQ" value="${airlineDto.airlineCode}" maxlength="10" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="description">Fleet & Description</label>
                    <textarea id="description" name="description" class="form-control" rows="3" 
                              placeholder="Brief description of operations, fleet types, or service standards.">${airlineDto.description}</textarea>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="status">Operating Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE" ${airlineDto.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${airlineDto.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div style="display: flex; gap: 12px;">
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
