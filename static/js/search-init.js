// Kept in an external file rather than inline so the site can carry a strict
// Content-Security-Policy without needing 'unsafe-inline' or a nonce.
window.addEventListener("DOMContentLoaded", function () {
  new PagefindUI({ element: "#search", showSubResults: true, showImages: false });
});
