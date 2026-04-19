/* =========================================================
   CLIENT PROFILE PAGE JS
   What this file does:
   - Connects the profile page UI to backend API endpoints
   - Handles card-specific alerts with close button + auto-hide
   - Handles profile update, password update
   - Handles avatar select/remove
   - Handles login activity filtering
   - Handles delete account modal and request
   - Syncs profile avatar and name with the topbar
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    /* =========================================================
       1. CONFIG + COMMON PAGE ELEMENTS
       ========================================================= */
    const config = window.profilePageConfig || {};
    const contextPath = config.contextPath || "";
    const apiBase = config.apiBase || (contextPath + "/client/api/profile");
    const defaultAvatar = config.defaultAvatar || (contextPath + "/resources/images/avatars/default-avatar.png");
    const csrfToken = config.csrfToken || "";
    const csrfHeader = config.csrfHeader || "";

    /* Global alerts (fallback only) */
    const profileSuccessAlert = document.getElementById("profileSuccessAlert");
    const profileErrorAlert = document.getElementById("profileErrorAlert");

    /* Personal info card */
    const profileInfoForm = document.getElementById("profileInfoForm");
    const fullNameInput = document.getElementById("fullNameInput");
    const resetProfileBtn = document.getElementById("resetProfileBtn");
    const profileDisplayName = document.getElementById("profileDisplayName");
    const profileInfoSuccessAlert = document.getElementById("profileInfoSuccessAlert");
    const profileInfoErrorAlert = document.getElementById("profileInfoErrorAlert");
	
	const photoModalSuccessAlert = document.getElementById("photoModalSuccessAlert");
	const photoModalErrorAlert = document.getElementById("photoModalErrorAlert");

	const accountSuccessAlert = document.getElementById("accountSuccessAlert");
	const accountErrorAlert = document.getElementById("accountErrorAlert");

    /* Photo / overview */
    const profileImageInput = document.getElementById("profileImageInput");
    const profileAvatarPreview = document.getElementById("profileAvatarPreview");
    const removePhotoBtn = document.getElementById("removePhotoBtn");

    const openPhotoChoiceModalBtn = document.getElementById("openPhotoChoiceModalBtn");
    const profilePhotoModalOverlay = document.getElementById("profilePhotoModalOverlay");
    const closePhotoChoiceModalBtn = document.getElementById("closePhotoChoiceModalBtn");
    const cancelPhotoChoiceModalBtn = document.getElementById("cancelPhotoChoiceModalBtn");
    const uploadFromDeviceBtn = document.getElementById("uploadFromDeviceBtn");
    const avatarOptionButtons = document.querySelectorAll(".profile-avatar-option");

    /* Password card */
    const changePasswordForm = document.getElementById("changePasswordForm");
    const clearPasswordBtn = document.getElementById("clearPasswordBtn");
    const currentPassword = document.getElementById("currentPassword");
    const newPassword = document.getElementById("newPassword");
    const confirmPassword = document.getElementById("confirmPassword");
    const passwordStrengthText = document.getElementById("passwordStrengthText");
    const passwordLastUpdated = document.getElementById("passwordLastUpdated");
    const passwordSuccessAlert = document.getElementById("passwordSuccessAlert");
    const passwordErrorAlert = document.getElementById("passwordErrorAlert");

    const ruleLength = document.getElementById("ruleLength");
    const ruleUpper = document.getElementById("ruleUpper");
    const ruleLower = document.getElementById("ruleLower");
    const ruleNumber = document.getElementById("ruleNumber");
    const ruleSymbol = document.getElementById("ruleSymbol");

    /* Login filter card */
    const loginAttemptFilterForm = document.getElementById("loginAttemptFilterForm");
    const attemptFromDate = document.getElementById("attemptFromDate");
    const attemptToDate = document.getElementById("attemptToDate");
    const resetAttemptsBtn = document.getElementById("resetAttemptsBtn");
    const rangeAttemptCount = document.getElementById("rangeAttemptCount");
    const loginActivityTableBody = document.getElementById("loginActivityTableBody");
    const loginActivityEmptyState = document.getElementById("loginActivityEmptyState");
    const loginFilterSuccessAlert = document.getElementById("loginFilterSuccessAlert");
    const loginFilterErrorAlert = document.getElementById("loginFilterErrorAlert");

    /* Security summary */
    const failedTodayCount = document.getElementById("failedTodayCount");
    const failedMonthCount = document.getElementById("failedMonthCount");
    const profileSecurityStatus = document.getElementById("profileSecurityStatus");

    /* Delete modal */
    const openDeleteBtn = document.getElementById("openDeleteAccountModalBtn");
    const deleteModal = document.getElementById("profileDeleteModalOverlay");
    const closeDeleteBtn = document.getElementById("closeDeleteAccountModalBtn");
    const cancelDeleteBtn = document.getElementById("cancelDeleteAccountBtn");
    const confirmDeleteBtn = document.getElementById("confirmDeleteAccountBtn");

    /* Topbar */
    const topbarProfileImage = document.getElementById("topbarProfileImage");
    const topbarProfileInitial = document.getElementById("topbarProfileInitial");
    const topbarUserName = document.getElementById("topbarUserName");

    const initialProfileState = {
        fullName: fullNameInput ? fullNameInput.value : "",
        avatarSrc: profileAvatarPreview ? profileAvatarPreview.src : defaultAvatar
    };

    /* =========================================================
       2. HTTP HELPERS
       ========================================================= */
    function getHeaders(isJson = true) {
        const headers = {};

        if (isJson) {
            headers["Content-Type"] = "application/json";
        }

        if (csrfToken && csrfHeader) {
            headers[csrfHeader] = csrfToken;
        }

        return headers;
    }

    async function request(url, options = {}) {
        const response = await fetch(url, {
            credentials: "same-origin",
            ...options
        });

        let data = {};
        try {
            data = await response.json();
        } catch (error) {
            data = {};
        }

        if (!response.ok) {
            throw new Error(data.message || "Something went wrong.");
        }

        return data;
    }

    /* =========================================================
       3. ALERT HELPERS
       What this block does:
       - Shows alerts inside the correct card
       - Adds close button to every alert
       - Auto-hides after 3 seconds
       - Uses global alert only as fallback
       ========================================================= */
    const alertTimerMap = new WeakMap();

	const alertGroups = {
	    global: {
	        success: profileSuccessAlert,
	        error: profileErrorAlert
	    },
	    profileInfo: {
	        success: profileInfoSuccessAlert,
	        error: profileInfoErrorAlert
	    },
	    password: {
	        success: passwordSuccessAlert,
	        error: passwordErrorAlert
	    },
	    loginFilter: {
	        success: loginFilterSuccessAlert,
	        error: loginFilterErrorAlert
	    },
	    profileOverview: {
	        success: profileSuccessAlert,
	        error: profileErrorAlert
	    },
	    photoModal: {
	        success: photoModalSuccessAlert,
	        error: photoModalErrorAlert
	    },
	    account: {
	        success: accountSuccessAlert,
	        error: accountErrorAlert
	    }
	};

	function clearAlertTimer(element) {
	    if (!element) return;

	    const existingTimer = alertTimerMap.get(element);
	    if (existingTimer) {
	        clearTimeout(existingTimer);
	        alertTimerMap.delete(element);
	    }
	}


    function buildAlertMarkup(message) {
        const safeMessage = message || "";
        return `
            <div class="profile-inline-alert-content">
                <span class="profile-inline-alert-text">${safeMessage}</span>
                <button type="button" class="profile-inline-alert-close" aria-label="Close alert">&times;</button>
            </div>
        `;
    }

	function attachCloseHandler(element) {
	    if (!element) return;

	    const closeBtn = element.querySelector(".profile-inline-alert-close");
	    if (!closeBtn) return;

	    closeBtn.addEventListener("click", function () {
	        hideSingleAlert(element);
	    });
	}

	function hideSingleAlert(element) {
	    if (!element) return;

	    clearAlertTimer(element);

	    if (element.classList.contains("d-none")) {
	        element.classList.remove("profile-inline-alert-show", "profile-inline-alert-hide");
	        element.innerHTML = "";
	        return;
	    }

	    element.classList.remove("profile-inline-alert-show");
	    element.classList.add("profile-inline-alert-hide");

	    setTimeout(function () {
	        element.classList.add("d-none");
	        element.classList.remove("profile-inline-alert-hide");
	        element.innerHTML = "";
	    }, 320);
	}


    function hideAlertGroup(sectionKey) {
        const group = alertGroups[sectionKey];
        if (!group) return;

        hideSingleAlert(group.success);
        hideSingleAlert(group.error);
    }

    function hideAllAlerts() {
        Object.keys(alertGroups).forEach(function (key) {
            hideAlertGroup(key);
        });
    }

	function showSectionAlert(sectionKey, type, message) {
	    const group = alertGroups[sectionKey] || alertGroups.global;
	    if (!group) return;

	    const target = type === "success" ? group.success : group.error;
	    const other = type === "success" ? group.error : group.success;

	    if (!target) return;

	    hideSingleAlert(other);
	    clearAlertTimer(target);

	    target.innerHTML = buildAlertMarkup(message);
	    target.classList.remove("d-none", "profile-inline-alert-hide");
	    target.classList.add(type === "success" ? "profile-inline-alert-success" : "profile-inline-alert-danger");

	    requestAnimationFrame(function () {
	        target.classList.add("profile-inline-alert-show");
	    });

	    attachCloseHandler(target);

	    const timerId = setTimeout(function () {
	        hideSingleAlert(target);
	    }, 5000);

	    alertTimerMap.set(target, timerId);
	}

    function showAlert(type, message) {
        showSectionAlert("global", type, message);
    }

    /* =========================================================
       4. SMALL VALIDATION / FORMAT HELPERS
       ========================================================= */
    function sanitizeText(value) {
        return (value || "").trim().replace(/\s+/g, " ");
    }

    function validateFullName(name) {
        const cleaned = sanitizeText(name);

        if (!cleaned) {
            return "Full name is required.";
        }

        if (cleaned.length < 2) {
            return "Full name must be at least 2 characters.";
        }

        if (cleaned.length > 100) {
            return "Full name must not exceed 100 characters.";
        }

        return null;
    }

    function formatDateTime(value) {
        if (!value) return "—";

        const date = new Date(value);
        if (Number.isNaN(date.getTime())) {
            return value;
        }

        return date.toLocaleString("en-US", {
            month: "short",
            day: "2-digit",
            year: "numeric",
            hour: "2-digit",
            minute: "2-digit",
            hour12: true
        });
    }

    function formatDateOnly(value) {
        if (!value) return "—";

        const date = new Date(value);
        if (Number.isNaN(date.getTime())) {
            return value;
        }

        return date.toLocaleDateString("en-US", {
            month: "short",
            day: "2-digit",
            year: "numeric"
        });
    }

    /* =========================================================
       5. TOPBAR SYNC HELPERS
       ========================================================= */
    function getInitialLetter(name) {
        const cleaned = (name || "").trim();
        return cleaned ? cleaned.charAt(0).toUpperCase() : "C";
    }

    function syncTopbarName(name) {
        if (topbarUserName) {
            topbarUserName.textContent = name || "";
        }

        if (topbarProfileInitial) {
            topbarProfileInitial.textContent = getInitialLetter(name);
        }
    }

    function syncTopbarAvatar(imageSrc) {
        if (!topbarProfileImage || !topbarProfileInitial) return;

        const normalizedSrc = imageSrc || "";
        const hasCustomImage =
            normalizedSrc &&
            normalizedSrc !== defaultAvatar &&
            !normalizedSrc.endsWith("/resources/images/avatars/default-avatar.png");

        if (hasCustomImage) {
            topbarProfileImage.src = normalizedSrc;
            topbarProfileImage.classList.remove("d-none");
            topbarProfileInitial.classList.add("d-none");
        } else {
            topbarProfileImage.src = "";
            topbarProfileImage.classList.add("d-none");
            topbarProfileInitial.classList.remove("d-none");
        }
    }

    /* =========================================================
       6. MODAL HELPERS
       ========================================================= */
	   function openPhotoModal() {
	       if (!profilePhotoModalOverlay) return;
	       hideAlertGroup("photoModal");
	       profilePhotoModalOverlay.classList.remove("d-none");
	       document.body.style.overflow = "hidden";
	   }

	   function closePhotoModal() {
	       if (!profilePhotoModalOverlay) return;
	       hideAlertGroup("photoModal");
	       profilePhotoModalOverlay.classList.add("d-none");
	       document.body.style.overflow = "";
	   }

    function openDeleteModal() {
        if (!deleteModal) return;
        deleteModal.classList.remove("d-none");
        document.body.style.overflow = "hidden";
    }

    function closeDeleteModal() {
        if (!deleteModal) return;
        deleteModal.classList.add("d-none");
        document.body.style.overflow = "";
    }

    /* =========================================================
       7. PASSWORD STRENGTH HELPERS
       ========================================================= */
    function setRuleState(element, isValid) {
        if (!element) return;
        element.classList.remove("rule-valid", "rule-invalid");
        element.classList.add(isValid ? "rule-valid" : "rule-invalid");
    }

    function evaluatePasswordStrength(password) {
        const lengthValid = password.length >= 8;
        const upperValid = /[A-Z]/.test(password);
        const lowerValid = /[a-z]/.test(password);
        const numberValid = /\d/.test(password);
        const symbolValid = /[^A-Za-z0-9]/.test(password);

        setRuleState(ruleLength, lengthValid);
        setRuleState(ruleUpper, upperValid);
        setRuleState(ruleLower, lowerValid);
        setRuleState(ruleNumber, numberValid);
        setRuleState(ruleSymbol, symbolValid);

        const score = [lengthValid, upperValid, lowerValid, numberValid, symbolValid].filter(Boolean).length;

        if (!password) return "Not entered";
        if (score <= 2) return "Weak";
        if (score === 3 || score === 4) return "Medium";
        return "Strong";
    }

    function resetPasswordUI() {
        if (changePasswordForm) {
            changePasswordForm.reset();
        }

        if (passwordStrengthText) {
            passwordStrengthText.textContent = "Not entered";
        }

        [ruleLength, ruleUpper, ruleLower, ruleNumber, ruleSymbol].forEach(function (rule) {
            if (rule) {
                rule.classList.remove("rule-valid", "rule-invalid");
            }
        });

        document.querySelectorAll(".profile-password-toggle").forEach(function (toggleBtn) {
            const targetId = toggleBtn.getAttribute("data-target");
            const targetInput = document.getElementById(targetId);

            if (targetInput) {
                targetInput.type = "password";
            }

            toggleBtn.textContent = "Show";
        });
    }

    /* =========================================================
       8. SECURITY BADGE
       ========================================================= */
    function updateSecurityBadge() {
        if (!profileSecurityStatus || !failedTodayCount || !failedMonthCount) return;

        const today = parseInt(failedTodayCount.textContent || "0", 10) || 0;
        const month = parseInt(failedMonthCount.textContent || "0", 10) || 0;

        profileSecurityStatus.classList.remove(
            "profile-status-good",
            "profile-status-warning",
            "profile-status-danger"
        );

        if (today > 0) {
            profileSecurityStatus.textContent = "Risk Detected";
            profileSecurityStatus.classList.add("profile-status-danger");
            return;
        }

        if (month > 0) {
            profileSecurityStatus.textContent = "Monitor";
            profileSecurityStatus.classList.add("profile-status-warning");
            return;
        }

        profileSecurityStatus.textContent = "Secure";
        profileSecurityStatus.classList.add("profile-status-good");
    }

    /* =========================================================
       9. LOGIN ACTIVITY RENDERING
       ========================================================= */
    function renderLoginActivity(rows) {
        if (!loginActivityTableBody || !loginActivityEmptyState) return;

        loginActivityTableBody.innerHTML = "";

        if (!rows || !rows.length) {
            loginActivityEmptyState.classList.remove("d-none");
            return;
        }

        loginActivityEmptyState.classList.add("d-none");

        rows.forEach(function (row) {
            const tr = document.createElement("tr");
            const isSuccess = String(row.status || "").toUpperCase() === "SUCCESS";

            tr.innerHTML = `
                <td>${formatDateTime(row.attemptedAt)}</td>
                <td>
                    <span class="profile-table-badge ${isSuccess ? "profile-table-badge-success" : "profile-table-badge-danger"}">
                        ${isSuccess ? "Success" : "Failed"}
                    </span>
                </td>
                <td>${row.reason || "—"}</td>
                <td>${row.ipAddress || "—"}</td>
                <td>${row.deviceBrowser || "—"}</td>
            `;

            loginActivityTableBody.appendChild(tr);
        });
    }

    async function loadLoginActivity(fromDate = "", toDate = "", failedOnly = false) {
        const params = new URLSearchParams();

        if (fromDate) params.append("fromDate", fromDate);
        if (toDate) params.append("toDate", toDate);

        const url = params.toString()
            ? `${apiBase}/login-activity?${params.toString()}`
            : `${apiBase}/login-activity`;

        const data = await request(url, {
            method: "GET",
            headers: getHeaders(false)
        });

        if (!data.success) {
            throw new Error(data.message || "Unable to load login activity.");
        }

        const rowsToRender = failedOnly ? (data.failedRows || []) : (data.rows || []);
        renderLoginActivity(rowsToRender);

        if (rangeAttemptCount) {
            rangeAttemptCount.textContent = String(data.failedCount || 0);
        }
    }

    /* =========================================================
       10. PHOTO MODAL EVENTS
       ========================================================= */
    if (openPhotoChoiceModalBtn) {
        openPhotoChoiceModalBtn.addEventListener("click", function () {
            hideAllAlerts();
            openPhotoModal();
        });
    }

    if (closePhotoChoiceModalBtn) {
        closePhotoChoiceModalBtn.addEventListener("click", function () {
            closePhotoModal();
        });
    }

    if (cancelPhotoChoiceModalBtn) {
        cancelPhotoChoiceModalBtn.addEventListener("click", function () {
            closePhotoModal();
        });
    }

    if (profilePhotoModalOverlay) {
        profilePhotoModalOverlay.addEventListener("click", function (e) {
            if (e.target === profilePhotoModalOverlay) {
                closePhotoModal();
            }
        });
    }

    /* =========================================================
       11. DELETE MODAL EVENTS
       ========================================================= */
    if (openDeleteBtn) {
        openDeleteBtn.addEventListener("click", openDeleteModal);
    }

    if (closeDeleteBtn) {
        closeDeleteBtn.addEventListener("click", closeDeleteModal);
    }

    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener("click", closeDeleteModal);
    }

    if (deleteModal) {
        deleteModal.addEventListener("click", function (e) {
            if (e.target === deleteModal) {
                closeDeleteModal();
            }
        });
    }

    /* =========================================================
       12. ESC KEY HANDLER
       ========================================================= */
    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            if (profilePhotoModalOverlay && !profilePhotoModalOverlay.classList.contains("d-none")) {
                closePhotoModal();
            }

            if (deleteModal && !deleteModal.classList.contains("d-none")) {
                closeDeleteModal();
            }
        }
    });

    /* =========================================================
       13. PROFILE PHOTO ACTIONS
       Note:
       - No dedicated inline alert box exists in the overview card yet,
         so photo actions still use global fallback alert.
       ========================================================= */
    if (uploadFromDeviceBtn) {
        uploadFromDeviceBtn.addEventListener("click", function () {
            if (profileImageInput) {
                profileImageInput.click();
            }
        });
    }

	avatarOptionButtons.forEach(function (button) {
	    button.addEventListener("click", async function () {
	        hideAlertGroup("photoModal");

	        const avatarSrc = button.getAttribute("data-avatar");
	        if (!avatarSrc || !profileAvatarPreview) return;

	        try {
	            const data = await request(`${apiBase}/photo`, {
	                method: "PUT",
	                headers: getHeaders(true),
	                body: JSON.stringify({
	                    profileImagePath: avatarSrc
	                })
	            });

	            if (!data.success) {
	                throw new Error(data.message || "Unable to save avatar.");
	            }

	            const savedPath = data.profileImagePath || avatarSrc;
	            const previewSrc = contextPath + savedPath;

	            profileAvatarPreview.src = previewSrc;
	            syncTopbarAvatar(previewSrc);

	            if (profileImageInput) {
	                profileImageInput.value = "";
	            }

	            initialProfileState.avatarSrc = previewSrc;

	            showSectionAlert("photoModal", "success", data.message || "Profile photo updated successfully.");
	        } catch (error) {
	            showSectionAlert("photoModal", "error", error.message || "Unable to save avatar.");
	        }
	    });
	});
	if (profileImageInput) {
	    profileImageInput.addEventListener("change", async function (e) {
	        hideAlertGroup("photoModal");

	        const file = e.target.files && e.target.files[0];
	        if (!file) return;

	        const allowedTypes = ["image/png", "image/jpeg", "image/jpg", "image/webp"];
	        const maxSize = 2 * 1024 * 1024;

	        if (!allowedTypes.includes(file.type)) {
	            showSectionAlert("photoModal", "error", "Only PNG, JPG, JPEG, and WEBP files are allowed.");
	            profileImageInput.value = "";
	            return;
	        }

	        if (file.size > maxSize) {
	            showSectionAlert("photoModal", "error", "Profile picture must be 2MB or less.");
	            profileImageInput.value = "";
	            return;
	        }

	        const formData = new FormData();
	        formData.append("profileImage", file);

	        try {
	            const response = await fetch(contextPath + "/upload-photo", {
	                method: "POST",
	                credentials: "same-origin",
	                headers: csrfToken && csrfHeader ? { [csrfHeader]: csrfToken } : {},
	                body: formData
	            });

	            let data = {};
	            try {
	                data = await response.json();
	            } catch (error) {
	                data = {};
	            }

	            if (!response.ok || !data.success) {
	                throw new Error(data.message || "Unable to upload profile photo.");
	            }

	            const uploadedPath = data.profileImagePath || "";
	            const uploadedSrc = contextPath + uploadedPath;
	            const cacheBustedSrc = uploadedSrc + "?t=" + Date.now();

	            if (profileAvatarPreview) {
	                profileAvatarPreview.src = cacheBustedSrc;
	            }

	            syncTopbarAvatar(cacheBustedSrc);

	            if (profileImageInput) {
	                profileImageInput.value = "";
	            }

	            initialProfileState.avatarSrc = uploadedSrc;

	            showSectionAlert("photoModal", "success", data.message || "Profile photo uploaded successfully.");

	          

	        } catch (error) {
	            profileImageInput.value = "";
	            showSectionAlert("photoModal", "error", error.message || "Unable to upload profile photo.");
	        }
	    });
	}

	if (removePhotoBtn) {
	    removePhotoBtn.addEventListener("click", async function () {
	        hideAlertGroup("profileOverview");

	        try {
	            const data = await request(`${apiBase}/photo`, {
	                method: "DELETE",
	                headers: getHeaders(false)
	            });

	            if (!data.success) {
	                throw new Error(data.message || "Unable to remove profile photo.");
	            }

	            if (profileAvatarPreview) {
	                profileAvatarPreview.src = defaultAvatar;
	            }

	            syncTopbarAvatar(defaultAvatar);

	            if (profileImageInput) {
	                profileImageInput.value = "";
	            }

	            initialProfileState.avatarSrc = defaultAvatar;
	            showSectionAlert("profileOverview", "success", data.message || "Profile photo removed successfully.");
	        } catch (error) {
	            showSectionAlert("profileOverview", "error", error.message || "Unable to remove profile photo.");
	        }
	    });
	}

    /* =========================================================
       14. PERSONAL INFORMATION FORM
       ========================================================= */
    if (profileInfoForm) {
        profileInfoForm.addEventListener("submit", async function (e) {
            e.preventDefault();
            hideAlertGroup("profileInfo");

            const fullName = sanitizeText(fullNameInput.value);
            const validationMessage = validateFullName(fullName);

            if (validationMessage) {
                showSectionAlert("profileInfo", "error", validationMessage);
                return;
            }

            try {
                const data = await request(`${apiBase}/info`, {
                    method: "PUT",
                    headers: getHeaders(true),
                    body: JSON.stringify({ fullName })
                });

                if (!data.success) {
                    throw new Error(data.message || "Unable to update profile information.");
                }

                fullNameInput.value = data.fullName || fullName;

                if (profileDisplayName) {
                    profileDisplayName.textContent = data.fullName || fullName;
                }

                syncTopbarName(data.fullName || fullName);

                initialProfileState.fullName = data.fullName || fullName;
                showSectionAlert("profileInfo", "success", data.message || "Profile information updated successfully.");
            } catch (error) {
                showSectionAlert("profileInfo", "error", error.message || "Unable to update profile information.");
            }
        });
    }

    if (resetProfileBtn) {
        resetProfileBtn.addEventListener("click", function () {
            hideAlertGroup("profileInfo");

            if (fullNameInput) {
                fullNameInput.value = initialProfileState.fullName;
            }

            if (profileDisplayName) {
                profileDisplayName.textContent = initialProfileState.fullName;
            }

            syncTopbarName(initialProfileState.fullName);
        });
    }

    /* =========================================================
       15. PASSWORD FORM
       ========================================================= */
    if (newPassword && passwordStrengthText) {
        newPassword.addEventListener("input", function () {
            passwordStrengthText.textContent = evaluatePasswordStrength(newPassword.value);
        });
    }

    document.querySelectorAll(".profile-password-toggle").forEach(function (toggleBtn) {
        toggleBtn.addEventListener("click", function () {
            const targetId = toggleBtn.getAttribute("data-target");
            const targetInput = document.getElementById(targetId);
            if (!targetInput) return;

            const isPassword = targetInput.type === "password";
            targetInput.type = isPassword ? "text" : "password";
            toggleBtn.textContent = isPassword ? "Hide" : "Show";
        });
    });

    if (changePasswordForm) {
        changePasswordForm.addEventListener("submit", async function (e) {
            e.preventDefault();
            hideAlertGroup("password");

            const currentVal = currentPassword.value || "";
            const newVal = newPassword.value || "";
            const confirmVal = confirmPassword.value || "";

            if (!currentVal || !newVal || !confirmVal) {
                showSectionAlert("password", "error", "Please complete all password fields.");
                return;
            }

            if (newVal !== confirmVal) {
                showSectionAlert("password", "error", "New password and confirm password do not match.");
                return;
            }

            if (newVal === currentVal) {
                showSectionAlert("password", "error", "New password must be different from the current password.");
                return;
            }

            const strength = evaluatePasswordStrength(newVal);
            if (strength === "Weak" || strength === "Not entered") {
                showSectionAlert("password", "error", "Please enter a stronger password that satisfies all required rules.");
                return;
            }

            try {
                const data = await request(`${apiBase}/password`, {
                    method: "PUT",
                    headers: getHeaders(true),
                    body: JSON.stringify({
                        currentPassword: currentVal,
                        newPassword: newVal,
                        confirmPassword: confirmVal
                    })
                });

                if (!data.success) {
                    throw new Error(data.message || "Unable to update password.");
                }

                resetPasswordUI();

                if (passwordLastUpdated) {
                    passwordLastUpdated.textContent = formatDateTime(new Date());
                }

                showSectionAlert("password", "success", data.message || "Password updated successfully.");
            } catch (error) {
                showSectionAlert("password", "error", error.message || "Unable to update password.");
            }
        });
    }

    if (clearPasswordBtn) {
        clearPasswordBtn.addEventListener("click", function () {
            hideAlertGroup("password");
            resetPasswordUI();
        });
    }

    /* =========================================================
       16. LOGIN ACTIVITY FILTER
       ========================================================= */
    if (loginAttemptFilterForm) {
        loginAttemptFilterForm.addEventListener("submit", async function (e) {
            e.preventDefault();
            hideAlertGroup("loginFilter");

            const fromVal = attemptFromDate.value;
            const toVal = attemptToDate.value;

            if (fromVal && toVal && fromVal > toVal) {
                showSectionAlert("loginFilter", "error", "The 'From' date must not be later than the 'To' date.");
                return;
            }

            try {
                await loadLoginActivity(fromVal, toVal, true);
                showSectionAlert("loginFilter", "success", "Failed login attempts filter applied successfully.");
            } catch (error) {
                showSectionAlert("loginFilter", "error", error.message || "Unable to filter failed login attempts.");
            }
        });
    }

    if (resetAttemptsBtn) {
        resetAttemptsBtn.addEventListener("click", async function () {
            hideAlertGroup("loginFilter");

            if (attemptFromDate) attemptFromDate.value = "";
            if (attemptToDate) attemptToDate.value = "";

            try {
                await loadLoginActivity("", "", false);
                showSectionAlert("loginFilter", "success", "Login activity has been reset successfully.");
            } catch (error) {
                showSectionAlert("loginFilter", "error", error.message || "Unable to reload login activity.");
            }
        });
    }

    /* =========================================================
       17. DELETE ACCOUNT ACTION
       Note:
       - Still uses global fallback alert because account details card
         does not yet have its own inline alert container.
       ========================================================= */
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener("click", async function () {
            hideAllAlerts();

            try {
                const data = await request(apiBase, {
                    method: "DELETE",
                    headers: getHeaders(false)
                });

                if (!data.success) {
                    throw new Error(data.message || "Unable to delete account.");
                }

                closeDeleteModal();
                showAlert("success", data.message || "Account deleted successfully.");

                setTimeout(function () {
                    window.location.href = contextPath + "/login";
                }, 1200);
            } catch (error) {
                showAlert("error", error.message || "Unable to delete account.");
            }
        });
    }

    /* =========================================================
       18. INITIAL PAGE STATE
       ========================================================= */
    updateSecurityBadge();
    syncTopbarName(fullNameInput ? fullNameInput.value : "");
    syncTopbarAvatar(profileAvatarPreview ? profileAvatarPreview.src : defaultAvatar);
});