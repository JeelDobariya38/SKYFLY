/**
 * SkyFly Airlines - Administrator JavaScript
 */
document.addEventListener('DOMContentLoaded', function () {
    // 1. Delete confirmations
    const deleteForms = document.querySelectorAll('.delete-confirm-form');
    deleteForms.forEach(function (form) {
        form.addEventListener('submit', function (e) {
            const confirmed = confirm('Are you sure you want to proceed with this deletion? This action cannot be undone.');
            if (!confirmed) {
                e.preventDefault();
            }
        });
    });

    // 2. Client-side table row filter
    const quickSearchInput = document.getElementById('tableQuickSearch');
    if (quickSearchInput) {
        quickSearchInput.addEventListener('keyup', function () {
            const query = quickSearchInput.value.toLowerCase();
            const rows = document.querySelectorAll('.data-table tbody tr');
            rows.forEach(function (row) {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    }
});
