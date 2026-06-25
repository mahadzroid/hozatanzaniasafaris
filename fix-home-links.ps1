# Fix homepage navigation links
$rootPath = "c:\Users\Administrator\Desktop\hozabss"
$files = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse -File

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $relativePath = $file.FullName.Substring($rootPath.Length)
    $depth = ($relativePath -split '\\').Count - 2
    
    # Fix homepage links
    if ($relativePath -match "^\\fr\\") {
        # French pages
        if ($depth -eq 1) {
            # fr/index.html
            $content = $content -replace 'href="\.\./fr/"', 'href="./"'
        }
        if ($depth -eq 2) {
            # fr/services/index.html
            $content = $content -replace 'href="\.\./\.\./fr/"', 'href="../"'
        }
    } elseif ($relativePath -match "^\\es\\") {
        # Spanish pages
        if ($depth -eq 1) {
            # es/index.html
            $content = $content -replace 'href="\.\./es/"', 'href="./"'
        }
        if ($depth -eq 2) {
            # es/services/index.html
            $content = $content -replace 'href="\.\./\.\./es/"', 'href="../"'
        }
    } else {
        # English pages
        if ($depth -eq 0) {
            # index.html
            $content = $content -replace 'href="\./"', 'href="./"'
        }
        if ($depth -eq 1) {
            # services/index.html
            $content = $content -replace 'href="\.\./"', 'href="../"'
        }
    }
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
}

Write-Host "Home navigation links fixed!"
