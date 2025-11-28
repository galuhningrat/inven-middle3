/**
 * Horizontal Scroll & Tooltip Implementation
 * File: public/js/horizontal-scroll.js
 *
 * Implementasi fitur scroll horizontal dengan Shift + Mouse Wheel
 * dan tooltip interaktif untuk semua tabel data
 */

(function () {
    "use strict";

    /**
     * Setup horizontal scroll untuk semua container
     */
    function setupHorizontalScroll() {
        const scrollableContainers = document.querySelectorAll(
            ".table-wrapper, .data-table-container, .content-area, .report-container, .modal-content"
        );

        scrollableContainers.forEach((container) => {
            // Tambahkan event listener untuk scroll horizontal
            container.addEventListener("wheel", handleHorizontalScroll, {
                passive: false,
            });

            // Tambahkan indikator scroll jika diperlukan
            if (container.scrollWidth > container.clientWidth) {
                addScrollIndicator(container);
            }
        });
    }

    /**
     * Handler untuk scroll horizontal dengan Shift + Wheel
     */
    function handleHorizontalScroll(event) {
        if (event.shiftKey) {
            event.preventDefault();
            this.scrollLeft += event.deltaY;

            // Hide hint saat user mulai scroll
            hideScrollHint();
        }
    }

    /**
     * Tambahkan indikator visual untuk scroll horizontal
     */
    function addScrollIndicator(container) {
        // Cek apakah sudah ada indikator
        if (container.querySelector(".scroll-indicator")) return;

        const indicator = document.createElement("div");
        indicator.className = "scroll-indicator";
        indicator.innerHTML = "← Scroll →";
        indicator.style.cssText = `
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(37, 99, 235, 0.9);
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 10;
        `;

        // Tambahkan indikator ke container
        const parent = container.closest(".data-table-container") || container;
        if (
            parent.style.position !== "relative" &&
            parent.style.position !== "absolute"
        ) {
            parent.style.position = "relative";
        }
        parent.appendChild(indicator);

        // Show indicator on hover
        container.addEventListener("mouseenter", () => {
            indicator.style.opacity = "1";
        });

        container.addEventListener("mouseleave", () => {
            indicator.style.opacity = "0";
        });

        // Hide indicator after scroll starts
        container.addEventListener(
            "scroll",
            () => {
                indicator.style.opacity = "0";
            },
            { once: true }
        );
    }

    /**
     * Show main scroll hint
     */
    function showScrollHint() {
        const hint = document.getElementById("horizontalScrollHint");
        if (!hint) return;

        // Check if any element is scrollable
        const scrollableElements = document.querySelectorAll(
            ".table-wrapper, .data-table-container, .content-area"
        );

        let hasHorizontalScroll = false;
        scrollableElements.forEach((element) => {
            if (element.scrollWidth > element.clientWidth) {
                hasHorizontalScroll = true;
            }
        });

        if (hasHorizontalScroll) {
            hint.classList.add("show");
            // Auto-hide setelah 5 detik
            setTimeout(() => {
                hint.classList.remove("show");
            }, 5000);
        }
    }

    /**
     * Hide scroll hint
     */
    function hideScrollHint() {
        const hint = document.getElementById("horizontalScrollHint");
        if (hint) {
            hint.classList.remove("show");
        }
    }

    /**
     * Setup keyboard shortcuts untuk scroll hint
     */
    function setupKeyboardShortcuts() {
        document.addEventListener("keydown", (event) => {
            if (event.shiftKey) {
                hideScrollHint();
            }
        });
    }

    /**
     * Check scroll visibility on resize
     */
    function setupResizeObserver() {
        let resizeTimeout;
        window.addEventListener("resize", () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
                showScrollHint();
            }, 500);
        });
    }

    /**
     * Initialize all features
     */
    function init() {
        // Setup horizontal scroll
        setupHorizontalScroll();

        // Setup keyboard shortcuts
        setupKeyboardShortcuts();

        // Setup resize observer
        setupResizeObserver();

        // Show hint on load
        setTimeout(showScrollHint, 1000);

        console.log("✅ Horizontal scroll initialized");
    }

    // Initialize when DOM is ready
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }

    // Re-initialize on dynamic content changes (for AJAX loaded content)
    window.reinitializeHorizontalScroll = function () {
        setupHorizontalScroll();
        showScrollHint();
    };
})();
