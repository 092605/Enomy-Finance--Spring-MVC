/* =====================================
   GLOBAL INLINE MESSAGE SYSTEM
   Reusable for all client pages
===================================== */

(function () {
    const activeTimers = new WeakMap();

    function clearInlineMessageTimer(element) {
        if (!element) return;

        const timer = activeTimers.get(element);
        if (timer) {
            clearTimeout(timer.hideTimer);
            clearTimeout(timer.cleanupTimer);
            activeTimers.delete(element);
        }
    }

    function setInlineMessage(element, message, type) {
        if (!element) return;

        element.textContent = message || "";
        element.classList.remove("inline-error-message", "inline-success-message");

        if (type === "success") {
            element.classList.add("inline-success-message");
        } else {
            element.classList.add("inline-error-message");
        }
    }

    function showInlineMessage(element, message, type = "error", duration = 3000) {
        if (!element) return;

        clearInlineMessageTimer(element);
        setInlineMessage(element, message, type);

        element.classList.remove("hide");
        element.classList.add("show");

        const hideTimer = setTimeout(() => {
            hideInlineMessage(element);
        }, duration);

        activeTimers.set(element, {
            hideTimer: hideTimer,
            cleanupTimer: null
        });
    }

    function hideInlineMessage(element) {
        if (!element) return;

        const current = activeTimers.get(element) || {};
        if (current.hideTimer) {
            clearTimeout(current.hideTimer);
        }
        if (current.cleanupTimer) {
            clearTimeout(current.cleanupTimer);
        }

        element.classList.remove("show");
        element.classList.add("hide");

        const cleanupTimer = setTimeout(() => {
            element.textContent = "";
            element.classList.remove("hide");
            activeTimers.delete(element);
        }, 520);

        activeTimers.set(element, {
            hideTimer: null,
            cleanupTimer: cleanupTimer
        });
    }

    function clearInlineMessage(element) {
        if (!element) return;

        clearInlineMessageTimer(element);
        hideInlineMessage(element);
    }

    function autoHideRenderedInlineMessages(duration = 3000) {
        const renderedMessages = document.querySelectorAll(
            ".inline-error-message.show, .inline-success-message.show"
        );

        renderedMessages.forEach(function (messageEl) {
            clearInlineMessageTimer(messageEl);

            const hideTimer = setTimeout(() => {
                hideInlineMessage(messageEl);
            }, duration);

            activeTimers.set(messageEl, {
                hideTimer: hideTimer,
                cleanupTimer: null
            });
        });
    }

    window.showInlineMessage = showInlineMessage;
    window.showInlineError = function (element, message, duration = 3000) {
        showInlineMessage(element, message, "error", duration);
    };
    window.showInlineSuccess = function (element, message, duration = 3000) {
        showInlineMessage(element, message, "success", duration);
    };
    window.hideInlineMessage = hideInlineMessage;
    window.clearInlineMessage = clearInlineMessage;
    window.autoHideRenderedInlineMessages = autoHideRenderedInlineMessages;
})();