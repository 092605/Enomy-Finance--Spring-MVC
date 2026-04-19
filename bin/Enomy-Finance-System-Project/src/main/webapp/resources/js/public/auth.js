function togglePassword(fieldId, iconContainer) {
    const input = document.getElementById(fieldId);
    const icon = iconContainer.querySelector("i");

    if (!input || !icon) return;

    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    } else {
        input.type = "password";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    }
}

document.addEventListener("DOMContentLoaded", function () {
    setupSignupPasswordValidation();
});

function setupSignupPasswordValidation() {
    const signupForm = document.getElementById("signupForm");
    const passwordInput = document.getElementById("password");
    const confirmPasswordInput = document.getElementById("confirmPassword");

    const strengthText = document.getElementById("passwordStrengthText");
    const matchText = document.getElementById("confirmPasswordMessage");

    const ruleLength = document.getElementById("ruleLength");
    const ruleUpper = document.getElementById("ruleUpper");
    const ruleLower = document.getElementById("ruleLower");
    const ruleNumber = document.getElementById("ruleNumber");
    const ruleSymbol = document.getElementById("ruleSymbol");

    if (!signupForm || !passwordInput || !confirmPasswordInput) return;

    function hasMinLength(value) {
        return value.length >= 8;
    }

    function hasUppercase(value) {
        return /[A-Z]/.test(value);
    }

    function hasLowercase(value) {
        return /[a-z]/.test(value);
    }

    function hasNumber(value) {
        return /[0-9]/.test(value);
    }

    function hasSpecialChar(value) {
        return /[^A-Za-z0-9]/.test(value);
    }

    function evaluatePasswordStrength(value) {
        if (!value) return "Not entered";

        const checks = [
            hasMinLength(value),
            hasUppercase(value),
            hasLowercase(value),
            hasNumber(value),
            hasSpecialChar(value)
        ];

        const passed = checks.filter(Boolean).length;

        if (passed <= 2) return "Weak";
        if (passed <= 4) return "Medium";
        return "Strong";
    }

    function updateRuleState(ruleElement, isValid) {
        if (!ruleElement) return;
        ruleElement.classList.remove("rule-valid", "rule-invalid");
        ruleElement.classList.add(isValid ? "rule-valid" : "rule-invalid");
    }

    function updatePasswordRules(value) {
        updateRuleState(ruleLength, hasMinLength(value));
        updateRuleState(ruleUpper, hasUppercase(value));
        updateRuleState(ruleLower, hasLowercase(value));
        updateRuleState(ruleNumber, hasNumber(value));
        updateRuleState(ruleSymbol, hasSpecialChar(value));
    }

    function updatePasswordStrength(value) {
        if (!strengthText) return;

        const strength = evaluatePasswordStrength(value);
        strengthText.textContent = strength;
        strengthText.classList.remove(
            "auth-password-strength-weak",
            "auth-password-strength-medium",
            "auth-password-strength-strong"
        );

        if (strength === "Weak") {
            strengthText.classList.add("auth-password-strength-weak");
        } else if (strength === "Medium") {
            strengthText.classList.add("auth-password-strength-medium");
        } else if (strength === "Strong") {
            strengthText.classList.add("auth-password-strength-strong");
        }
    }

    function updateConfirmPasswordState() {
        if (!matchText) return;

        const passwordVal = passwordInput.value || "";
        const confirmVal = confirmPasswordInput.value || "";

        matchText.classList.remove(
            "auth-password-match-error",
            "auth-password-match-success"
        );

        if (!confirmVal) {
            matchText.textContent = "";
            return;
        }

        if (passwordVal === confirmVal) {
            matchText.textContent = "Passwords match";
            matchText.classList.add("auth-password-match-success");
        } else {
            matchText.textContent = "Passwords do not match";
            matchText.classList.add("auth-password-match-error");
        }
    }

    passwordInput.addEventListener("input", function () {
        const value = passwordInput.value || "";
        updatePasswordRules(value);
        updatePasswordStrength(value);
        updateConfirmPasswordState();
    });

    confirmPasswordInput.addEventListener("input", function () {
        updateConfirmPasswordState();
    });

    signupForm.addEventListener("submit", function (e) {
        const passwordVal = passwordInput.value || "";
        const confirmVal = confirmPasswordInput.value || "";
        const strength = evaluatePasswordStrength(passwordVal);

        if (!passwordVal || !confirmVal) {
            e.preventDefault();
            return;
        }

        if (passwordVal !== confirmVal) {
            e.preventDefault();
            updateConfirmPasswordState();
            confirmPasswordInput.focus();
            return;
        }

        if (strength === "Weak" || strength === "Not entered") {
            e.preventDefault();
            updatePasswordStrength(passwordVal);
            passwordInput.focus();
        }
    });

    updatePasswordRules(passwordInput.value || "");
    updatePasswordStrength(passwordInput.value || "");
    updateConfirmPasswordState();
}