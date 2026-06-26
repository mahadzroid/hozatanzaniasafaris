# Script to fix all HTML files by removing the problematic hamburger-menu-breaking script
$files = Get-ChildItem -Path "C:\Users\Administrator\Desktop\hozabss -Filter "index.html" -Recurse -File

# The problematic script to remove
$oldScript = @'
	<script>
	// SUPER BLOCK Tawk.to FROM CHANGING ANYTHING
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
		
		// Function to reset styles
		function resetStyles() {
			const html = document.documentElement;
			const body = document.body;
			
			// Reset HTML
			html.style.marginRight = '';
			html.style.marginLeft = '';
			html.style.marginTop = '';
			html.style.marginBottom = '';
			html.style.padding = '';
			html.style.width = '';
			html.style.overflowX = '';
			html.style.overflowY = '';
			html.style.position = '';
			html.style.top = '';
			html.style.left = '';
			html.style.right = '';
			html.style.bottom = '';
			
			// Reset body
			body.style.marginRight = '';
			body.style.marginLeft = '';
			body.style.marginTop = '';
			body.style.marginBottom = '';
			body.style.padding = '';
			body.style.width = '';
			body.style.overflowX = '';
			body.style.overflowY = '';
			body.style.position = '';
			body.style.top = '';
			body.style.left = '';
			body.style.right = '';
			body.style.bottom = '';
		}
		
		// MutationObserver to watch for style changes
		const observer = new MutationObserver(function(mutations) {
			let needsReset = false;
			mutations.forEach(function(mutation) {
				if (mutation.attributeName === 'style') {
					needsReset = true;
				}
			});
			if (needsReset) {
				resetStyles();
			}
		});
		
		// Observe both html and body
		observer.observe(document.documentElement, { attributes: true, attributeFilter: ['style'] });
		observer.observe(document.body, { attributes: true, attributeFilter: ['style'] });
		
		// Also reset on window resize
		window.addEventListener('resize', resetStyles);
		
		// Initial reset
		resetStyles();
		
		// Also block setAttribute for style
		const originalSetAttribute = Element.prototype.setAttribute;
		Element.prototype.setAttribute = function(name, value) {
			if ((this === document.documentElement || this === document.body) && name === 'style') {
				return;
			}
			return originalSetAttribute.call(this, name, value);
		};
	})();
	</script>
'@

# Replace the shorter variant (with maybe different line endings)
$oldScript2 = @'
	<script>
	// BLOCK Tawk.to FROM CHANGING STYLES (without breaking hamburger menu!)
	(function() {
		// Only block Tawk.to from modifying body/html styles, allow WordPress navigation!
		const originalSetAttribute = Element.prototype.setAttribute;
		Element.prototype.setAttribute = function(name, value) {
			// Check if this is a style change to body/html
			if ((this === document.documentElement || this === document.body) && name === 'style') {
				// Only block if the style looks like Tawk.to's (adds margin-right or overflow hidden)
				// Allow WordPress navigation to work!
				if (value && (value.includes('margin-right') || value.includes('overflow'))) {
					// Don't block, let WordPress navigation work!
				}
			}
			return originalSetAttribute.call(this, name, value);
		};
	})();
	</script>
'@

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName"
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -match [regex]::Escape($oldScript)) {
        $content = $content.Replace($oldScript, '')
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated $($file.FullName)"
    }
    elseif ($content -match [regex]::Escape($oldScript2)) {
        $content = $content.Replace($oldScript2, '')
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated $($file.FullName) - variant 2"
    }
}

Write-Host "Done! All files processed!
