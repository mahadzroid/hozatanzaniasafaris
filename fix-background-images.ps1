# Fix ALL background-image URLs
$rootPath = "c:\Users\Administrator\Desktop\hozabss"
$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse -File

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    $relativePath = $file.FullName.Substring($rootPath.Length)
    $depth = ($relativePath -split '\\').Count - 2
    $prefix = "./"
    if ($depth -gt 0) {
        $prefix = "../" * $depth
    }
    
    $content = Get-Content -Path $file.FullName -Raw
    # Fix background-image url(/... to url(prefix...)
    $content = $content -replace 'background-image:url\("/', "background-image:url(`"$prefix"
    # Fix background-image:url("/ with single quotes too
    $content = $content -replace "background-image:url\('/", "background-image:url('$prefix"
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  Fixed with prefix: $prefix"
}

Write-Host "All background images fixed!"
