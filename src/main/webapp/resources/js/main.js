document.addEventListener('DOMContentLoaded', function () {
    // Staggered animation: set CSS variable --i on each card
    const grid = document.querySelector('.jobs-grid');
    if (grid) {
        const cards = Array.from(grid.querySelectorAll('.card'));
        cards.forEach((card, idx) => {
            card.style.setProperty('--i', `${idx * 80}ms`);
        });

        // Use IntersectionObserver to only animate when in viewport
        const io = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'none';
                    entry.target.classList.add('visible');
                    io.unobserve(entry.target);
                }
            });
        }, { threshold: 0.08 });

        cards.forEach(c => io.observe(c));
    }

    // Mobile navigation toggle
    const toggle = document.querySelector('.mobile-nav-toggle');
    const navLinks = document.querySelector('.nav-links');
    if (toggle && navLinks) {
        toggle.addEventListener('click', () => {
            navLinks.classList.toggle('mobile-active');
        });
    }
});

// Small helper: smooth scroll for anchor links (optional)
document.addEventListener('click', function (e) {
    const a = e.target.closest('a');
    if (a && a.hash && document.querySelector(a.hash)) {
        e.preventDefault();
        document.querySelector(a.hash).scrollIntoView({ behavior: 'smooth' });
    }
});
