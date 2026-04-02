/* =========================================================
   CLIENT PROFILE PAGE JS
   What this file does:
   - Connects the profile page UI to backend API endpoints
   - Handles alerts, profile update, password update
   - Handles avatar select/remove
   - Handles login activity filtering
   - Handles delete account modal and request
   - Syncs profile avatar and name with the topbar
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    /* =========================================================
       1. CONFIG + COMMON PAGE ELEMENTS
       What this block does:
       - Reads values passed from JSP
       - Stores commonly used DOM elements
       - Prepares initial page state for reset actions
       ========================================================= */
    const config = window.profilePageConfig || {};
    const contextPath = config.contextPath || "";
    const apiBase = config.apiBase || (contextPath + "/client/api/profile");
    const defaultAvatar = config.defaultAvatar || (contextPath + "/resources/images/avatars/default-avatar.png");
    const csrfToken = config.csrfToken || "";
    const csrfHeader = config.csrfHeader || "";

    const profileSuccessAlert = document.getElementById("profileSuccessAlert");
    const profileErrorAlert = document.getElementById("profileErrorAlert");

    const profileInfoForm = document.getElementById("profileInfoForm");
    const fullNameInput = document.getElementById("fullNameInput");
    const resetProfileBtn = document.getElementById("resetProfileBtn");
    const profileDisplayName = document.getElementById("profileDisplayName");

    const profileImageInput = document.getElementById("profileImageInput");
    const profileAvatarPreview = document.getElementById("profileAvatarPreview");
    const removePhotoBtn = document.getElementById("removePhotoBtn");

    const openPhotoChoiceModalBtn = document.getElementById("openPhotoChoiceModalBtn");
    const profilePhotoModalOverlay = document.getElementById("profilePhotoModalOverlay");
    const closePhotoChoiceModalBtn = document.getElementById("closePhotoChoiceModalBtn");
    const cancelPhotoChoiceModalBtn = document.getElementById("cancelPhotoChoiceModalBtn");
    const uploadFromDeviceBtn = document.getElementById("uploadFromDeviceBtn");
    const avatarOptionButtons = document.querySelectorAll(".profile-avatar-option");

    const changePasswordForm = document.getElementById("changePasswordForm");
    const clearPasswordBtn = document.getElementById("clearPasswordBtn");
    const currentPassword = document.getElementById("currentPassword");
    const newPassword = document.getElementById("newPassword");
    const confirmPassword = document.getElementById("confirmPassword");
    const passwordStrengthText = document.getElementById("passwordStrengthText");
    const passwordLastUpdated = document.getElementById("passwordLastUpdated");

    const ruleLength = document.getElementById("ruleLength");
    const ruleUpper = document.getElementById("ruleUpper");
    const ruleLower = document.getElementById("ruleLower");
    const ruleNumber = document.getElementById("ruleNumber");
    const ruleSymbol = document.getElementById("ruleSymbol");

    const loginAttemptFilterForm = document.getElementById("loginAttemptFilterForm");
    const attemptFromDate = document.getElementById("attemptFromDate");
    const attemptToDate = document.getElementById("attemptToDate");
    const resetAttemptsBtn = document.getElementById("resetAttemptsBtn");
    const rangeAttemptCount = document.getElementById("rangeAttemptCount");
    const loginActivityTableBody = document.getElementById("loginActivityTableBody");
    const loginActivityEmptyState = document.getElementById("loginActivityEmptyState");

    const failedTodayCount = document.getElementById("failedTodayCount");
    const failedMonthCount = document.getElementById("failedMonthCount");
    const profileSecurityStatus = document.getElementById("profileSecurityStatus");

    const openDeleteBtn = document.getElementById("openDeleteAccountModalBtn");
    const deleteModal = document.getElementById("profileDeleteModalOverlay");
    const closeDeleteBtn = document.getElementById("closeDeleteAccountModalBtn");
    const cancelDeleteBtn = document.getElementById("cancelDeleteAccountBtn");
    const confirmDeleteBtn = document.getElementById("confirmDeleteAccountBtn");

    const topbarProfileImage = document.getElementById("topbarProfileImage");
    const topbarProfileInitial = document.getElementById("topbarProfileInitial");
    const topbarUserName = document.getElementById("topbarUserName");

    const initialProfileState = {
        fullName: fullNameInput ? fullNameInput.value : "",
        avatarSrc: profileAvatarPreview ? profileAvatarPreview.src : defaultAvatar
    };

    /* =========================================================
       2. HTTP HELPERS
       What this block does:
       - Builds request headers
       - Adds CSRF token when available
       - Sends fetch requests and safely reads JSON responses
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
       - Shows success or error alert at the top of the page
       - Clears previous alerts before showing a new one
       ========================================================= */
    function showAlert(type, message) {
        hideAlerts();

        const target = type === "success" ? profileSuccessAlert : profileErrorAlert;
        if (!target) return;

        target.textContent = message;
        target.classList.remove("d-none");

        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    }

    function hideAlerts() {
        if (profileSuccessAlert) {
            profileSuccessAlert.classList.add("d-none");
            profileSuccessAlert.textContent = "";
        }

        if (profileErrorAlert) {
            profileErrorAlert.classList.add("d-none");
            profileErrorAlert.textContent = "";
        }
    }

    /* =========================================================
       4. SMALL VALIDATION / FORMAT HELPERS
       What this block does:
       - Cleans text input
       - Validates full name
       - Formats date and datetime values for display
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
       What this block does:
       - Keeps topbar name in sync with profile name
       - Switches topbar avatar between image and initial fallback
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
       What this block does:
       - Opens and closes the profile photo modal
       - Opens and closes the delete account modal
       - Locks page scroll while modal is open
       ========================================================= */
    function openPhotoModal() {
        if (!profilePhotoModalOverlay) return;
        profilePhotoModalOverlay.classList.remove("d-none");
        document.body.style.overflow = "hidden";
    }

    function closePhotoModal() {
        if (!profilePhotoModalOverlay) return;
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
       What this block does:
       - Evaluates new password strength
       - Updates password rule colors
       - Resets password form UI after clear/success
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
       What this block does:
       - Updates the Security Summary badge based on failed attempts
       - Shows Secure / Monitor / Risk Detected
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
       What this block does:
       - Builds the Login Activity table rows from API data
       - Shows empty state if no rows are returned
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

    async function loadLoginActivity(fromDate = "", toDate = "") {
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

        renderLoginActivity(data.rows || []);

        if (rangeAttemptCount) {
            rangeAttemptCount.textContent = String(data.failedCount || 0);
        }
    }

    /* =========================================================
       10. PHOTO MODAL EVENTS
       What this block does:
       - Opens/closes photo modal
       - Allows Escape key and overlay click close behavior
       ========================================================= */
    if (openPhotoChoiceModalBtn) {
        openPhotoChoiceModalBtn.addEventListener("click", function () {
            hideAlerts();
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
       What this block does:
       - Opens/closes delete account modal
       - Allows overlay click close behavior
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
       What this block does:
       - Closes any open modal when Escape is pressed
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
       What this block does:
       - Opens file picker for upload preview
       - Saves preset avatar to backend
       - Removes saved avatar from backend
       - Keeps upload from device as preview-only for now
       - Syncs profile image changes to topbar
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
            hideAlerts();

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

                profileAvatarPreview.src = data.profileImagePath || avatarSrc;
                syncTopbarAvatar(data.profileImagePath || avatarSrc);

                if (profileImageInput) {
                    profileImageInput.value = "";
                }

                initialProfileState.avatarSrc = profileAvatarPreview.src;
                closePhotoModal();
                showAlert("success", data.message || "Profile photo updated successfully.");
            } catch (error) {
                showAlert("error", error.message || "Unable to save avatar.");
            }
        });
    });

    if (profileImageInput) {
        profileImageInput.addEventListener("change", function (e) {
            hideAlerts();

            const file = e.target.files && e.target.files[0];
            if (!file) return;

            const allowedTypes = ["image/png", "image/jpeg", "image/jpg", "image/webp"];
            const maxSize = 2 * 1024 * 1024;

            if (!allowedTypes.includes(file.type)) {
                showAlert("error", "Only PNG, JPG, JPEG, and WEBP files are allowed.");
                profileImageInput.value = "";
                return;
            }

            if (file.size > maxSize) {
                showAlert("error", "Profile picture must be 2MB or less.");
                profileImageInput.value = "";
                return;
            }

            const reader = new FileReader();
            reader.onload = function (event) {
                if (profileAvatarPreview) {
                    profileAvatarPreview.src = event.target.result;
                }

                syncTopbarAvatar(event.target.result);
                closePhotoModal();
                showAlert("error", "Upload from device is preview-only for now. Preset avatars can already be saved to the backend.");
            };
            reader.readAsDataURL(file);
        });
    }

    if (removePhotoBtn) {
        removePhotoBtn.addEventListener("click", async function () {
            hideAlerts();

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
                showAlert("success", data.message || "Profile photo removed successfully.");
            } catch (error) {
                showAlert("error", error.message || "Unable to remove profile photo.");
            }
        });
    }

    /* =========================================================
       14. PERSONAL INFORMATION FORM
       What this block does:
       - Validates full name
       - Sends update request to backend
       - Updates display name on success
       - Resets to original value when Reset is clicked
       - Syncs topbar name and initial
       ========================================================= */
    if (profileInfoForm) {
        profileInfoForm.addEventListener("submit", async function (e) {
            e.preventDefault();
            hideAlerts();

            const fullName = sanitizeText(fullNameInput.value);
            const validationMessage = validateFullName(fullName);

            if (validationMessage) {
                showAlert("error", validationMessage);
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
                showAlert("success", data.message || "Profile information updated successfully.");
            } catch (error) {
                showAlert("error", error.message || "Unable to update profile information.");
            }
        });
    }

    if (resetProfileBtn) {
        resetProfileBtn.addEventListener("click", function () {
            hideAlerts();

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
       What this block does:
       - Shows live password strength
       - Toggles Show/Hide for password inputs
       - Sends password update request to backend
       - Resets password UI after success or clear
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
            hideAlerts();

            const currentVal = currentPassword.value || "";
            const newVal = newPassword.value || "";
            const confirmVal = confirmPassword.value || "";

            if (!currentVal || !newVal || !confirmVal) {
                showAlert("error", "Please complete all password fields.");
                return;
            }

            if (newVal !== confirmVal) {
                showAlert("error", "New password and confirm password do not match.");
                return;
            }

            if (newVal === currentVal) {
                showAlert("error", "New password must be different from the current password.");
                return;
            }

            const strength = evaluatePasswordStrength(newVal);
            if (strength === "Weak" || strength === "Not entered") {
                showAlert("error", "Please enter a stronger password that satisfies all required rules.");
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
                    passwordLastUpdated.textContent = formatDateOnly(new Date());
                }

                showAlert("success", data.message || "Password updated successfully.");
            } catch (error) {
                showAlert("error", error.message || "Unable to update password.");
            }
        });
    }

    if (clearPasswordBtn) {
        clearPasswordBtn.addEventListener("click", function () {
            hideAlerts();
            resetPasswordUI();
        });
    }

    /* =========================================================
       16. LOGIN ACTIVITY FILTER
       What this block does:
       - Validates From/To dates
       - Calls backend to filter login activity
       - Resets filters and reloads all rows
       ========================================================= */
    if (loginAttemptFilterForm) {
        loginAttemptFilterForm.addEventListener("submit", async function (e) {
            e.preventDefault();
            hideAlerts();

            const fromVal = attemptFromDate.value;
            const toVal = attemptToDate.value;

            if (fromVal && toVal && fromVal > toVal) {
                showAlert("error", "The 'From' date must not be later than the 'To' date.");
                return;
            }

            try {
                await loadLoginActivity(fromVal, toVal);
                showAlert("success", "Login activity filter applied successfully.");
            } catch (error) {
                showAlert("error", error.message || "Unable to filter login activity.");
            }
        });
    }

    if (resetAttemptsBtn) {
        resetAttemptsBtn.addEventListener("click", async function () {
            hideAlerts();

            if (attemptFromDate) attemptFromDate.value = "";
            if (attemptToDate) attemptToDate.value = "";

            try {
                await loadLoginActivity();
            } catch (error) {
                showAlert("error", error.message || "Unable to reload login activity.");
            }
        });
    }

    /* =========================================================
       17. DELETE ACCOUNT ACTION
       What this block does:
       - Sends delete request to backend
       - Closes modal
       - Shows success message
       - Redirects user to login page
       ========================================================= */
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener("click", async function () {
            hideAlerts();

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
       What this block does:
       - Sets the correct security badge on first load
       - Syncs topbar name and avatar on first load
       ========================================================= */
    updateSecurityBadge();
    syncTopbarName(fullNameInput ? fullNameInput.value : "");
    syncTopbarAvatar(profileAvatarPreview ? profileAvatarPreview.src : defaultAvatar);
});