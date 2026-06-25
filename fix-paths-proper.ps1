# Fix absolute paths PROPERLY for GitHub Pages based on directory depth
$rootPath = "c:\Users\Administrator\Desktop\hozabss"
$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse -File

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    
    # Calculate relative path from root
    $relativePath = $file.FullName.Substring($rootPath.Length)
    $depth = ($relativePath -split '\\').Count - 2
    
    # Determine the correct prefix (./, ../, ../../, etc.)
    $prefix = "./"
    if ($depth -gt 0) {
        $prefix = "../" * $depth
    }
    
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace absolute paths (starting with /) with correct relative paths
    $content = $content -replace 'src="/', "src=`"$prefix"
    $content = $content -replace 'href="/', "href=`"$prefix"
    $content = $content -replace 'srcset="/', "srcset=`"$prefix"
    $content = $content -replace 'background-image: url\("/', "background-image: url(`"$prefix"
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  Fixed with prefix: $prefix"
}

Write-Host "All HTML files fixed PROPERLY for GitHub Pages!"
