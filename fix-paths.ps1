# Fix absolute paths for GitHub Pages
$files = Get-ChildItem -Path "c:\Users\Administrator\Desktop\hozabss" -Filter "*.html" -Recurse -File

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace absolute paths (starting with /) with relative paths
    $content = $content -replace 'src="/', 'src="./'
    $content = $content -replace 'href="/', 'href="./'
    $content = $content -replace 'srcset="/', 'srcset="./'
    $content = $content -replace 'background-image: url\("/', 'background-image: url("./'
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  Fixed!"
}

Write-Host "All HTML files fixed for GitHub Pages!"
