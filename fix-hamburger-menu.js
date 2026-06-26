(function() {
    // Save original styles
    const originalBodyStyle = {
        marginRight: '',
        overflow: '',
        position: '',
        top: '',
        left: '',
        right: '',
        bottom: '',
        width: ''
    };
    
    // Function to reset Tawk.to-specific styles (not all styles)
    function resetStyles() {
        const html = document.documentElement;
        const body = document.body;
        
        // Only reset Tawk.to changes, allow navigation overlay changes
        // Check if the change is from Tawk.to (we'll look for Tawk.to-specific patterns)
        // For now, we'll just NOT block all style changes, only block Tawk.to from modifying the body
    }
    
    // MutationObserver to watch for style changes, but only block Tawk.to
    const observer = new MutationObserver(function(mutations) {
        let needsReset = false;
        mutations.forEach(function(mutation) {
            // Only block changes that are from Tawk.to (we'll check the source)
            // For now, we'll just stop resetting all styles, because that's breaking the hamburger menu
        });
        if (needsReset) {
            resetStyles();
        }
    });
    
    // Observe both html and body, but don't block navigation changes
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['style'] });
    observer.observe(document.body, { attributes: true, attributeFilter: ['style'] });
    
    // Also reset on window resize
    window.addEventListener('resize', resetStyles);
    
    // Initial reset
    resetStyles();
    
    // Only block Tawk.to from setting style attributes, not other scripts
    const originalSetAttribute = Element.prototype.setAttribute;
    Element.prototype.setAttribute = function(name, value) {
        // Check if this is a Tawk.to element trying to modify body/html
        if ((this === document.documentElement || this === document.body) && name === 'style') {
            // Only block if the style is from Tawk.to (we'll check if the value contains Tawk.to-specific things)
            if (value && (value.includes('tawk') || value.includes('Tawk'))) {
                return;
            }
        }
        return originalSetAttribute.call(this, name, value);
    };
})();
