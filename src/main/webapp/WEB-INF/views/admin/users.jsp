<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Customer Accounts - SkyFly Admin" />
<c:set var="isAdminSection" value="true" />
<c:set var="adminActive" value="users" />
<c:set var="adminPageTitle" value="Registered Customers & User Management" />
<jsp:include page="../common/header.jsp" />

<jsp:include page="../common/admin-sidebar.jsp" />

<main class="admin-main">
    <jsp:include page="../common/admin-navbar.jsp" />

    <div class="admin-content">
        <jsp:include page="../common/messages.jsp" />

        <div class="table-card">
            <div class="table-header">
                <h3>Registered Customer Accounts</h3>
                <form action="<c:url value='/admin/users' />" method="get" class="table-search-form">
                    <input type="text" name="keyword" class="table-search-input" 
                           placeholder="Search customer by name or email..." value="${keyword}">
                    <button type="submit" class="btn btn-primary btn-sm">Search</button>
                    <c:if test="${not empty keyword}">
                        <a href="<c:url value='/admin/users' />" class="btn btn-sm btn-outline-primary">Reset</a>
                    </c:if>
                </form>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email Address</th>
                        <th>Phone Number</th>
                        <th>Role</th>
                        <th>Account Status</th>
                        <th>Registered Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty users}">
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.id}</td>
                                    <td><strong><c:out value="${user.fullName}" /></strong></td>
                                    <td><c:out value="${user.email}" /></td>
                                    <td><c:out value="${user.phoneNumber}" /></td>
                                    <td>
                                        <span style="font-weight: 600; font-size: 0.85rem; color: var(--primary);">
                                            <c:out value="${user.role}" />
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status == 'ACTIVE'}">
                                                <span class="badge badge-active">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:out value="${user.createdAt != null ? user.createdAt.toLocalDate() : 'N/A'}" />
                                    </td>
                                    <td>
                                        <form action="<c:url value='/admin/users/toggle-status/${user.id}' />" method="post" style="display: inline;"
                                              onsubmit="return confirm('Are you sure you want to toggle account status for ${user.fullName}?');">
                                            <button type="submit" class="btn btn-sm ${user.status == 'ACTIVE' ? 'btn-danger' : 'btn-outline-primary'}">
                                                <c:out value="${user.status == 'ACTIVE' ? 'Deactivate' : 'Activate'}" />
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" style="text-align: center; color: var(--gray-400); padding: 30px;">
                                    No customer accounts found.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
