/**
 * SkyFly Airlines - Main Vanilla JavaScript
 */
document.addEventListener('DOMContentLoaded', function () {
    // 1. Auto-dismiss flash messages after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function () {
            alerts.forEach(function (alert) {
                alert.style.transition = 'opacity 0.4s ease';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 400);
            });
        }, 5000);
    }

    // 2. Prevent same source and destination on search forms
    const flightSearchForm = document.getElementById('flightSearchForm');
    if (flightSearchForm) {
        flightSearchForm.addEventListener('submit', function (e) {
            const source = document.getElementById('sourceCity');
            const dest = document.getElementById('destinationCity');
            if (source && dest && source.value && dest.value && source.value === dest.value) {
                e.preventDefault();
                alert('Source and Destination cities cannot be the same. Please choose different airports.');
            }
        });
    }

    // 3. Set minimum date for flight search input to today
    const departureDateInput = document.getElementById('departureDate');
    if (departureDateInput) {
        const today = new Date().toISOString().split('T')[0];
        departureDateInput.min = today;
    }
});

// Quick fill helper for login demonstration
function fillDemoCredentials(email, password) {
    const emailField = document.getElementById('email');
    const passwordField = document.getElementById('password');
    if (emailField && passwordField) {
        emailField.value = email;
        passwordField.value = password;
    }
}
