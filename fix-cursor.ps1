
# Fix custom cursor in ALL HTML files
$rootPath = "c:\Users\Administrator\Desktop\hozabss"
$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse -File

# The CSS we want to replace
$oldCss = @'
	/* Tawk.to SUPER FIX */
	.tawk-chat-container, 
	.tawk-mobile-chat-container,
	.tawk-iframe,
	.tawk-iframe-container,
	.tawk-min-container {
		position: fixed !important;
		z-index: 999999999 !important;
		box-sizing: border-box !important;
		max-width: none !important;
		width: auto !important;
	}
	</style>
'@

# The new CSS with cursor fix
$newCss = @'
	/* Tawk.to SUPER FIX */
	.tawk-chat-container, 
	.tawk-mobile-chat-container,
	.tawk-iframe,
	.tawk-iframe-container,
	.tawk-min-container {
		position: fixed !important;
		z-index: 999999999 !important;
		box-sizing: border-box !important;
		max-width: none !important;
		width: auto !important;
	}
	/* CUSTOM CURSOR FIX */
	.cursor, #cursor {
		width: 10px !important;
		height: 10px !important;
		max-width: none !important;
	}
	.cursor-ring, #cursorRing {
		width: 36px !important;
		height: 36px !important;
		max-width: none !important;
	}
	</style>
'@

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace
    if ($content -match [regex]::Escape($oldCss)) {
        $content = $content.Replace($oldCss, $newCss)
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Fixed!"
    } else {
        Write-Host "  Already fixed or not found"
    }
}

Write-Host "All files processed!"
