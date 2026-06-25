# Get the correct CSS from the fixed index.html
$fixedHtml = Get-Content "c:\Users\Administrator\Desktop\hozabss\index.html" -Raw
$startTag = '	<style>
	/* FULL WIDTH EDGE-TO-EDGE'
$endTag = '	</style>'

$startIdx = $fixedHtml.IndexOf($startTag)
$tempEndIdx = $fixedHtml.IndexOf($endTag, $startIdx)
$correctCss = $fixedHtml.Substring($startIdx, $tempEndIdx - $startIdx + $endTag.Length)

# List of main website pages to fix
$pagesToFix = @(
    "c:\Users\Administrator\Desktop\hozabss\services\index.html",
    "c:\Users\Administrator\Desktop\hozabss\gallary\index.html",
    "c:\Users\Administrator\Desktop\hozabss\contact-as\index.html",
    "c:\Users\Administrator\Desktop\hozabss\fr\index.html",
    "c:\Users\Administrator\Desktop\hozabss\fr\services\index.html",
    "c:\Users\Administrator\Desktop\hozabss\fr\gallary\index.html",
    "c:\Users\Administrator\Desktop\hozabss\fr\contact-as\index.html",
    "c:\Users\Administrator\Desktop\hozabss\es\index.html",
    "c:\Users\Administrator\Desktop\hozabss\es\gallary\index.html",
    "c:\Users\Administrator\Desktop\hozabss\es\contact-as\index.html"
)

foreach ($page in $pagesToFix) {
    if (Test-Path $page) {
        $content = Get-Content $page -Raw
        
        # Find the old style block and replace
        $oldStartIdx = $content.IndexOf('	<style>')
        
        if ($oldStartIdx -ge 0) {
            $oldEndIdx = $content.IndexOf('	</style>', $oldStartIdx) + '	</style>'.Length
            
            if ($oldEndIdx -gt $oldStartIdx) {
                $newContent = $content.Substring(0, $oldStartIdx) + $correctCss + $content.Substring($oldEndIdx)
                Set-Content -Path $page -Value $newContent -NoNewline
                Write-Host "Fixed: $page"
            }
        }
    }
}

Write-Host "All pages fixed! Your original colors are back and full width edge-to-edge!"
