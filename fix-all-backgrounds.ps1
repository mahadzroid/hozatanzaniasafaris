
# Fix ALL background-image urls in ALL HTML files
$rootPath = "c:\Users\Administrator\Desktop\hozabss"
$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse -File

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    
    # Calculate relative path from this file back to root
    $relativePath = $file.FullName.Substring($rootPath.Length)
    $depth = ($relativePath -split '\\').Count - 2
    
    $prefix = "./"
    if ($depth -gt 0) {
        $prefix = "../" * $depth
    }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Replace any background-image:url(/ with correct prefix
    # Handle both url("...") and url('...') and url(...) (no quotes)
    $content = $content -replace "background-image:url\(/", "background-image:url($prefix"
    $content = $content -replace 'background-image:url\("/', "background-image:url(`"$prefix"
    $content = $content -replace "background-image:url\('/", "background-image:url('$prefix"
    
    # Also check for style="background-image: ..."
    $content = $content -replace 'background-image:\s*url\(/', "background-image:url($prefix"
    $content = $content -replace 'background-image:\s*url\("/', "background-image:url(`"$prefix"
    $content = $content -replace "background-image:\s*url\('/", "background-image:url('$prefix"
    
    Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
    Write-Host "  Fixed with prefix: $prefix"
}

Write-Host "All background images fixed!"
