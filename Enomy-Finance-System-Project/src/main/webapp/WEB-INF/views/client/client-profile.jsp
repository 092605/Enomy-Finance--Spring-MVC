

<%-- =========================================================
     JSP FILE DESCRIPTION
     =========================================================
     File Name:
     client-profile.jsp

     Purpose:
     This JSP file serves as the authenticated client
     profile management page for the Enomy Finance system.

     Overview:
     This page allows authenticated users to manage
     their personal account information, monitor login
     activity, update account security settings, and
     customize profile preferences.

     The page supports:
     - Personal information management
     - Password management
     - Login activity monitoring
     - Failed login monitoring
     - Profile image management
     - Avatar selection
     - Account security tracking
     - Account deletion workflow
     - AJAX-based profile updates
     - Inline success and error messaging

     Main Features:
     - Display authenticated client profile overview
     - Display client account information
     - Display login activity records
     - Display failed login statistics
     - Display account security summary
     - Update full name
     - Update account password
     - Password strength validation
     - Filter login activity by date range
     - Upload custom profile photo
     - Select predefined avatar
     - Remove profile photo
     - View current and previous login history
     - View failed login attempts
     - Delete account confirmation workflow
     - Dynamic inline feedback messaging
     - Modal-based avatar selection
     - AJAX-based profile operations

     Note:
     This page focuses on user profile management,
     account monitoring, and authentication-related
     workflows. Advanced biometric authentication
     and external identity provider integrations
     are outside the current project scope.

     CONNECTED RESOURCES

     CSS
     - theme.css
     - components.css
     - inline-messages.css
     - client-profile.css
     - client-dashboard.css
     - bootstrap.min.css

     JavaScript
     - client-dashboard.js
     - client-profile.js
     - inline-messages.js
     - components.js
     - bootstrap.bundle.min.js

     JSP COMPONENTS
     - client/sidebar.jsp
     - client/topbar.jsp

     JAVA CLASSES

     Controllers
     - ClientProfileController
     - ClientProfileApiController
     - ClientGlobalModel

     Services
     - ClientProfileService
     - ClientProfileServiceImpl
     - LoginActivityService
     - LoginActivityServiceImpl
     - PasswordValidationService
     - PasswordValidationServiceImpl
     - ProfileImageService
     - ProfileImageServiceImpl

     DAO Layer
     - UserDao
     - UserDaoImpl
     - LoginActivityDao
     - LoginActivityDaoImpl

     Models
     - User
     - LoginActivity

     DTO Classes
     - ClientProfileDTO
     - LoginActivityDTO
     - UpdateProfileRequestDTO
     - ChangePasswordRequestDTO
     - ProfileImageUploadDTO

     Security Classes
     - SecurityConfig
     - CustomUserDetails
     - PasswordEncoder
     - BCryptPasswordEncoder

     Purpose of Java Class Usage:
     - Handles authenticated profile page routing
     - Retrieves authenticated user profile data
     - Retrieves login activity records
     - Retrieves failed login statistics
     - Supports AJAX-based profile updates
     - Supports password update operations
     - Validates password security rules
     - Supports profile image upload workflows
     - Supports avatar selection workflows
     - Handles account deletion requests
     - Supplies secured client access control
     - Supports inline validation and feedback messaging

     Module:
     Web Development Foundations (WDF)

     System:
     Enomy Finance Web Application

     ========================================================= --%>


<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:set var="defaultAvatar"
	value="${pageContext.request.contextPath}/resources/images/avatars/default-avatar.png" />
<c:set var="profileAvatarSrc"
	value="${empty user.profileImagePath ? defaultAvatar : pageContext.request.contextPath.concat(user.profileImagePath)}" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Profile | Enomy Finance</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/theme.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/components.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/inline-messages.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/client/client-profile.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/client/client-dashboard.css">
</head>
<body class="dashboard-page">

	<div class="dashboard-layout">

		<jsp:include
			page="/WEB-INF/components/Authenticated/client/sidebar.jsp" />

		<div class="dashboard-main" id="dashboardMain">

			<jsp:include
				page="/WEB-INF/components/Authenticated/client/topbar.jsp" />

			<main class="dashboard-content">
				<div class="container-fluid">

					<!-- Page Header -->
					<section class="profile-page-header">
						<div class="profile-page-header-content">
							<div>
								<span class="profile-page-badge">Client Account</span>
								<h1 class="profile-page-title">Profile</h1>
								<p class="profile-page-subtitle">Manage your personal
									information and account security.</p>
							</div>
						</div>
					</section>

					<!-- Row 1 -->
					<section class="row g-4 mb-4">

						<!-- Profile Overview -->
						<div class="col-12 col-xl-7">
							<div class="profile-card profile-overview-card h-100">
								<div class="profile-card-inner">
									<div class="profile-card-header">
										<h3 class="profile-card-title">Profile Overview</h3>
									</div>

									<div class="profile-inline-alert-stack"
										id="profileOverviewAlertStack">
										<div
											class="profile-inline-alert profile-inline-alert-success d-none"
											id="profileSuccessAlert"></div>
										<div
											class="profile-inline-alert profile-inline-alert-danger d-none"
											id="profileErrorAlert"></div>
									</div>

									<div class="profile-overview-wrap">
										<div class="profile-avatar-area">
											<div class="profile-avatar-frame">
												<img id="profileAvatarPreview" src="${profileAvatarSrc}"
													data-default-avatar="${defaultAvatar}"
													alt="Profile Picture" class="profile-avatar-img" />
											</div>

											<div class="profile-avatar-actions">
												<button type="button"
													class="profile-btn profile-btn-primary mb-2 w-100"
													id="openPhotoChoiceModalBtn">Change Photo</button>
												<input type="file" id="profileImageInput"
													accept=".png,.jpg,.jpeg,.webp" hidden>
												<button type="button"
													class="profile-btn profile-btn-secondary w-100"
													id="removePhotoBtn">Remove</button>
											</div>
										</div>

										<div class="profile-overview-details">
											<div class="profile-identity-block">
												<h2 class="profile-user-name" id="profileDisplayName">${user.fullName}</h2>
												<p class="profile-user-email" id="profileDisplayEmail">${user.email}</p>
											</div>

											<div class="row g-3">
												<div class="col-sm-6">
													<div class="profile-info-tile">
														<span class="profile-info-label">Client ID</span> <span
															class="profile-info-value" id="profileClientId">CL-${user.id}</span>
													</div>
												</div>

												<div class="col-sm-6">
													<div class="profile-info-tile">
														<span class="profile-info-label">Account Type</span> <span
															class="profile-info-value" id="profileAccountType">Client
															Account</span>
													</div>
												</div>

												<div class="col-sm-6">
													<div class="profile-info-tile">
														<span class="profile-info-label">Joined Date</span> <span
															class="profile-info-value" id="profileJoinedDate">
															<c:choose>
																<c:when test="${not empty user.createdAt}">
																	<fmt:formatDate value="${user.createdAt}"
																		pattern="MMM dd, yyyy" />
																</c:when>
																<c:otherwise>—</c:otherwise>
															</c:choose>
														</span>
													</div>
												</div>

												<div class="col-sm-6">
													<div class="profile-info-tile">
														<span class="profile-info-label">Last Login</span> <span
															class="profile-info-value" id="profileLastLogin">
															<c:choose>
																<c:when
																	test="${not empty profileData.previousSuccessfulLogin and not empty profileData.previousSuccessfulLogin.attemptedAt}">
																	<fmt:formatDate
																		value="${profileData.previousSuccessfulLogin.attemptedAt}"
																		pattern="MMM dd, yyyy hh:mm a" />
																</c:when>
																<c:otherwise>—</c:otherwise>
															</c:choose>
														</span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- Security Summary -->
						<div class="col-12 col-xl-5">
							<div class="profile-card profile-security-summary-card h-100">
								<div class="profile-card-inner">
									<div class="profile-card-header">
										<h3 class="profile-card-title">Security Summary</h3>
										<span class="profile-status-badge" id="profileSecurityStatus">
											— </span>
									</div>

									<div class="row g-3">
										<div class="col-12 col-sm-6">
											<div class="profile-stat-tile">
												<span class="profile-stat-label">Failed Today</span>
												<h2 class="profile-stat-value" id="failedTodayCount">${profileData.failedTodayCount}</h2>
											</div>
										</div>

										<div class="col-12 col-sm-6">
											<div class="profile-stat-tile">
												<span class="profile-stat-label">Failed This Month</span>
												<h2 class="profile-stat-value" id="failedMonthCount">${profileData.failedThisMonthCount}</h2>
											</div>
										</div>

										<div class="col-12">
											<div class="profile-security-meta">
												<div class="profile-security-meta-row">
													<span>Last Failed Login</span> <strong id="lastFailedLogin">
														<c:choose>
															<c:when
																test="${not empty profileData.lastFailedLogin and not empty profileData.lastFailedLogin.attemptedAt}">
																<fmt:formatDate
																	value="${profileData.lastFailedLogin.attemptedAt}"
																	pattern="MMM dd, yyyy hh:mm a" />
															</c:when>
															<c:otherwise>—</c:otherwise>
														</c:choose>
													</strong>
												</div>

												<div class="profile-security-meta-row">
													<span class="profile-success-label">Current Login</span> <strong
														class="profile-success-value"> <fmt:formatDate
															value="${profileData.lastSuccessfulLogin.attemptedAt}"
															pattern="MMM dd, yyyy hh:mm a" />
													</strong>
												</div>

												<div class="profile-security-meta-row">
													<span>Previous Login</span> <strong> <c:choose>
															<c:when
																test="${not empty profileData.previousSuccessfulLogin and not empty profileData.previousSuccessfulLogin.attemptedAt}">
																<fmt:formatDate
																	value="${profileData.previousSuccessfulLogin.attemptedAt}"
																	pattern="MMM dd, yyyy hh:mm a" />
															</c:when>
															<c:otherwise>—</c:otherwise>
														</c:choose>
													</strong>
												</div>

												<div class="profile-security-meta-row">
													<span>Password Last Updated</span> <strong
														id="passwordLastUpdated"> <c:choose>
															<c:when test="${not empty user.passwordUpdatedAt}">
																<fmt:formatDate value="${user.passwordUpdatedAt}"
																	pattern="MMM dd, yyyy hh:mm a" />
															</c:when>
															<c:otherwise>—</c:otherwise>
														</c:choose>
													</strong>
												</div>
											</div>
										</div>
									</div>

									<div class="profile-security-note">Keep your account
										secure by monitoring recent login activity.</div>
								</div>
							</div>
						</div>
					</section>

					<!-- Row 2 -->
					<section class="row g-4 mb-4">

						<!-- Personal Information -->
						<div class="col-12 col-xl-6">
							<div class="profile-card h-100">
								<div class="profile-card-inner">
									<div class="profile-card-header">
										<h3 class="profile-card-title">Personal Information</h3>
									</div>

									<div class="profile-inline-alert-stack"
										id="profileInfoAlertStack">
										<div
											class="profile-inline-alert profile-inline-alert-success d-none"
											id="profileInfoSuccessAlert"></div>
										<div
											class="profile-inline-alert profile-inline-alert-danger d-none"
											id="profileInfoErrorAlert"></div>
									</div>

									<form id="profileInfoForm" novalidate>
										<div class="row g-3">
											<div class="col-12">
												<label class="profile-form-label" for="fullNameInput">Full
													Name</label> <input type="text" class="profile-form-control"
													id="fullNameInput" name="fullName" value="${user.fullName}"
													maxlength="100" placeholder="Enter your full name">
												<div class="profile-field-hint">This name will be
													displayed across your account.</div>
											</div>

											<div class="col-12">
												<label class="profile-form-label" for="emailReadOnly">Email
													Address</label> <input type="email"
													class="profile-form-control profile-readonly-input"
													id="emailReadOnly" value="${user.email}" readonly>
											</div>

											<div class="col-12">
												<label class="profile-form-label" for="accountRoleReadOnly">Role</label>
												<input type="text"
													class="profile-form-control profile-readonly-input"
													id="accountRoleReadOnly" value="${user.role}" readonly>
											</div>
										</div>

										<div class="profile-form-actions mt-4">
											<button type="submit" class="profile-btn profile-btn-primary"
												id="saveProfileBtn">Save Changes</button>
											<button type="button"
												class="profile-btn profile-btn-secondary"
												id="resetProfileBtn">Reset</button>
										</div>
									</form>
								</div>
							</div>
						</div>

						<!-- Change Password -->
						<div class="col-12 col-xl-6">
							<div class="profile-card h-100">
								<div class="profile-card-inner">
									<div class="profile-card-header">
										<h3 class="profile-card-title">Change Password</h3>
									</div>

									<div class="profile-inline-alert-stack" id="passwordAlertStack">
										<div
											class="profile-inline-alert profile-inline-alert-success d-none"
											id="passwordSuccessAlert"></div>
										<div
											class="profile-inline-alert profile-inline-alert-danger d-none"
											id="passwordErrorAlert"></div>
									</div>

									<form id="changePasswordForm" novalidate>
										<div class="row g-3">
											<div class="col-12">
												<label class="profile-form-label" for="currentPassword">Current
													Password</label>
												<div class="profile-password-wrap">
													<input type="password" class="profile-form-control"
														id="currentPassword" name="currentPassword"
														placeholder="Enter current password">
													<button type="button" class="profile-password-toggle"
														data-target="currentPassword">Show</button>
												</div>
											</div>

											<div class="col-12">
												<label class="profile-form-label" for="newPassword">New
													Password</label>
												<div class="profile-password-wrap">
													<input type="password" class="profile-form-control"
														id="newPassword" name="newPassword"
														placeholder="Enter new password">
													<button type="button" class="profile-password-toggle"
														data-target="newPassword">Show</button>
												</div>
											</div>

											<div class="col-12">
												<label class="profile-form-label" for="confirmPassword">Confirm
													New Password</label>
												<div class="profile-password-wrap">
													<input type="password" class="profile-form-control"
														id="confirmPassword" name="confirmPassword"
														placeholder="Confirm new password">
													<button type="button" class="profile-password-toggle"
														data-target="confirmPassword">Show</button>
												</div>
											</div>

											<div class="col-12">
												<div class="profile-password-strength">
													<span class="profile-password-strength-label">Password
														Strength</span> <span class="profile-password-strength-value"
														id="passwordStrengthText">Not entered</span>
												</div>

												<ul class="profile-password-rules">
													<li id="ruleLength">At least 8 characters</li>
													<li id="ruleUpper">At least 1 uppercase letter</li>
													<li id="ruleLower">At least 1 lowercase letter</li>
													<li id="ruleNumber">At least 1 number</li>
													<li id="ruleSymbol">At least 1 special character</li>
												</ul>
											</div>
										</div>

										<div class="profile-form-actions mt-4">
											<button type="submit" class="profile-btn profile-btn-primary"
												id="updatePasswordBtn">Update Password</button>
											<button type="button"
												class="profile-btn profile-btn-secondary"
												id="clearPasswordBtn">Clear</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</section>

					<!-- Row 3 + Row 4 Combined -->
					<section class="row g-4 mb-4">
						<div class="col-12">
							<div class="profile-card profile-login-section-card">
								<div class="profile-card-inner">

									<div class="profile-card-header profile-login-section-header">
										<div>
											<h3 class="profile-card-title mb-1">Login Monitoring</h3>
											<p class="profile-login-section-subtitle mb-0">Review
												failed attempts and recent login activity in one place.</p>
										</div>
									</div>

									<!-- Highlighted Filter Box -->
									<div class="profile-login-filter-box">
										<div class="profile-card-header mb-3">
											<h3 class="profile-card-title">Failed Login Attempts</h3>
										</div>

										<div class="profile-inline-alert-stack"
											id="loginFilterAlertStack">
											<div
												class="profile-inline-alert profile-inline-alert-success d-none"
												id="loginFilterSuccessAlert"></div>
											<div
												class="profile-inline-alert profile-inline-alert-danger d-none"
												id="loginFilterErrorAlert"></div>
										</div>

										<form class="row g-3 align-items-end"
											id="loginAttemptFilterForm">
											<div class="col-12 col-md-4 col-lg-3">
												<label class="profile-form-label" for="attemptFromDate">From</label>
												<input type="date" class="profile-form-control"
													id="attemptFromDate" name="fromDate">
											</div>

											<div class="col-12 col-md-4 col-lg-3">
												<label class="profile-form-label" for="attemptToDate">To</label>
												<input type="date" class="profile-form-control"
													id="attemptToDate" name="toDate">
											</div>

											<div class="col-12 col-md-4 col-lg-6">
												<div class="profile-filter-actions">
													<button type="submit"
														class="profile-btn profile-btn-primary"
														id="filterAttemptsBtn">Apply Filter</button>
													<button type="button"
														class="profile-btn profile-btn-secondary"
														id="resetAttemptsBtn">Reset</button>
												</div>
											</div>
										</form>

										<div class="profile-range-summary mt-3"
											id="profileRangeSummary">
											Showing <strong id="rangeAttemptCount">${profileData.failedThisMonthCount}</strong>
											failed attempt(s) for the selected range.
										</div>
									</div>

									<!-- Scrollable Login Activity Box -->
									<div class="profile-login-activity-box mt-4">
										<div class="profile-card-header">
											<h3 class="profile-card-title">Login Activity</h3>
										</div>

										<div class="profile-table-scroll-shell">
											<div
												class="table-responsive profile-table-wrap profile-table-wrap-scrollable">
												<table
													class="table profile-activity-table align-middle mb-0">
													<thead>
														<tr>
															<th>Date / Time</th>
															<th>Status</th>
															<th>Reason</th>
															<th>IP Address</th>
															<th>Device / Browser</th>
														</tr>
													</thead>
													<tbody id="loginActivityTableBody">
														<c:choose>
															<c:when test="${not empty profileData.loginActivities}">
																<c:forEach var="row"
																	items="${profileData.loginActivities}">
																	<tr>
																		<td><c:choose>
																				<c:when test="${not empty row.attemptedAt}">
																					<fmt:formatDate value="${row.attemptedAt}"
																						pattern="MMM dd, yyyy hh:mm a" />
																				</c:when>
																				<c:otherwise>—</c:otherwise>
																			</c:choose></td>
																		<td><span
																			class="profile-table-badge ${row.status eq 'SUCCESS' ? 'profile-table-badge-success' : 'profile-table-badge-danger'}">
																				${row.status eq 'SUCCESS' ? 'Success' : 'Failed'} </span></td>
																		<td>${empty row.reason ? '—' : row.reason}</td>
																		<td>${empty row.ipAddress ? '—' : row.ipAddress}</td>
																		<td>${empty row.deviceBrowser ? '—' : row.deviceBrowser}</td>
																	</tr>
																</c:forEach>
															</c:when>
														</c:choose>
													</tbody>
												</table>
											</div>
										</div>

										<div
											class="profile-empty-state ${not empty profileData.loginActivities ? 'd-none' : ''}"
											id="loginActivityEmptyState">No login activity found
											for the selected range.</div>
									</div>

								</div>
							</div>
						</div>
					</section>

					<!-- Row 5 -->
					<section class="row g-4">
						<div class="col-12">
							<div class="profile-card">
								<div class="profile-card-inner">
									<div class="profile-card-header">
										<h3 class="profile-card-title">Account Details</h3>
									</div>

									<div class="profile-inline-alert-stack"
										id="accountDetailsAlertStack">
										<div
											class="profile-inline-alert profile-inline-alert-success d-none"
											id="accountSuccessAlert"></div>
										<div
											class="profile-inline-alert profile-inline-alert-danger d-none"
											id="accountErrorAlert"></div>
									</div>

									<div class="row g-3">
										<div class="col-12 col-md-6 col-xl-3">
											<div class="profile-info-tile">
												<span class="profile-info-label">Username</span> <span
													class="profile-info-value" id="accountUsername">${user.fullName}</span>
											</div>
										</div>

										<div class="col-12 col-md-6 col-xl-3">
											<div class="profile-info-tile">
												<span class="profile-info-label">Registered Email</span> <span
													class="profile-info-value" id="accountEmail">${user.email}</span>
											</div>
										</div>

										<div class="col-12 col-md-6 col-xl-3">
											<div class="profile-info-tile">
												<span class="profile-info-label">Account Status</span> <span
													class="profile-info-value" id="accountStatusValue">${user.enabled ? 'Active' : 'Disabled'}</span>

												<button type="button" class="profile-delete-link"
													id="openDeleteAccountModalBtn">Delete Account?</button>
											</div>
										</div>

										<div class="col-12 col-md-6 col-xl-3">
											<div class="profile-info-tile">
												<span class="profile-info-label">Created On</span> <span
													class="profile-info-value" id="accountCreatedDate">
													<c:choose>
														<c:when test="${not empty user.createdAt}">
															<fmt:formatDate value="${user.createdAt}"
																pattern="MMM dd, yyyy" />
														</c:when>
														<c:otherwise>—</c:otherwise>
													</c:choose>
												</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</section>

				</div>
			</main>
		</div>
	</div>

	<!-- Photo Choice Modal -->
	<div class="profile-photo-modal-overlay d-none"
		id="profilePhotoModalOverlay">
		<div class="profile-photo-modal-card">
			<div class="profile-photo-modal-header">
				<div>
					<h3 class="profile-photo-modal-title">Choose Profile Photo</h3>
					<p class="profile-photo-modal-subtitle">Upload a photo from
						your device or select one of the available avatars.</p>
				</div>
				<button type="button" class="profile-photo-modal-close"
					id="closePhotoChoiceModalBtn">&times;</button>
			</div>

			<div class="profile-inline-alert-stack" id="photoModalAlertStack">
				<div
					class="profile-inline-alert profile-inline-alert-success d-none"
					id="photoModalSuccessAlert"></div>
				<div class="profile-inline-alert profile-inline-alert-danger d-none"
					id="photoModalErrorAlert"></div>
			</div>

			<div class="profile-photo-modal-section">
				<h4 class="profile-photo-section-title">Upload from Device</h4>
				<button type="button" class="profile-btn profile-btn-primary"
					id="uploadFromDeviceBtn">Upload Photo</button>
			</div>

			<div class="profile-photo-modal-section">
				<h4 class="profile-photo-section-title">Choose an Avatar</h4>
				<div class="profile-avatar-grid">
					<button type="button" class="profile-avatar-option"
						data-avatar="/resources/images/avatars/Avatar 1.png">
						<img
							src="${pageContext.request.contextPath}/resources/images/avatars/Avatar 1.png"
							alt="Avatar 1">
					</button>

					<button type="button" class="profile-avatar-option"
						data-avatar="/resources/images/avatars/Avatar 2.png">
						<img
							src="${pageContext.request.contextPath}/resources/images/avatars/Avatar 2.png"
							alt="Avatar 2">
					</button>

					<button type="button" class="profile-avatar-option"
						data-avatar="/resources/images/avatars/Avatar 3.png">
						<img
							src="${pageContext.request.contextPath}/resources/images/avatars/Avatar 3.png"
							alt="Avatar 3">
					</button>

					<button type="button" class="profile-avatar-option"
						data-avatar="/resources/images/avatars/Avatar 4.png">
						<img
							src="${pageContext.request.contextPath}/resources/images/avatars/Avatar 4.png"
							alt="Avatar 4">
					</button>

					<button type="button" class="profile-avatar-option"
						data-avatar="/resources/images/avatars/Avatar 5.png">
						<img
							src="${pageContext.request.contextPath}/resources/images/avatars/Avatar 5.png"
							alt="Avatar 5">
					</button>

					<button type="button" class="profile-avatar-option"
						data-avatar="/resources/images/avatars/Avatar 6.png">
						<img
							src="${pageContext.request.contextPath}/resources/images/avatars/Avatar 6.png"
							alt="Avatar 6">
					</button>
				</div>
			</div>

		</div>
	</div>

	<!-- Delete Account Modal -->
	<div class="profile-delete-modal-overlay d-none"
		id="profileDeleteModalOverlay">
		<div class="profile-delete-modal-card">

			<div class="profile-delete-modal-header">
				<h3>Delete Account</h3>
				<button type="button" id="closeDeleteAccountModalBtn">&times;</button>
			</div>

			<div class="profile-delete-modal-body">
				<p>This action will permanently delete your account and all
					associated data. This cannot be undone.</p>

				<p class="profile-delete-warning">Are you sure you want to
					proceed?</p>
			</div>

			<div class="profile-delete-modal-footer">
				<button type="button" class="profile-btn profile-btn-secondary"
					id="cancelDeleteAccountBtn">Cancel</button>

				<button type="button" class="profile-btn profile-btn-danger"
					id="confirmDeleteAccountBtn">Yes, Delete Account</button>
			</div>

		</div>
	</div>

	<script>
    window.profilePageConfig = {
        contextPath: "${pageContext.request.contextPath}",
        apiBase: "${pageContext.request.contextPath}/client/api/profile",
        defaultAvatar: "${defaultAvatar}",
        csrfToken: "${_csrf.token}",
        csrfHeader: "${_csrf.headerName}"
    };
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/client/client-dashboard.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/client/client-profile.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/public/inline-messages.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/public/components.js"></script>


</body>
</html>