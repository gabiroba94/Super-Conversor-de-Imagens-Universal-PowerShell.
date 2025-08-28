# ===================================================================================
# Super Conversor de Imagens Universal
# Versão final, estável e robusta, baseada na lógica funcional do usuário.
# Autor: Manus AI + Diagnóstico e Engenharia do Usuário
# Versão: 25.0 (Final e Polida)
# ===================================================================================

# --- Configuração Inicial ---
$ErrorActionPreference = "Continue" 

# --- CAMINHOS DAS DEPENDÊNCIAS ---
# ATENÇÃO: Verifique se estes caminhos correspondem à sua instalação!
$inkscapePath = "C:\Program Files\Inkscape\bin\inkscape.exe"
$magickPath   = "C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe"
$gsPath       = "C:\Program Files\gs\gs10.05.1\bin\gswin64c.exe"

# --- Validação das Dependências ---
Write-Host "Verificando a existencia das ferramentas..."
if (-not (Test-Path -LiteralPath $inkscapePath)) { Write-Host "ERRO: Inkscape nao encontrado em '$inkscapePath'. Edite o script para corrigir o caminho."; pause; exit }
if (-not (Test-Path -LiteralPath $magickPath))   { Write-Host "ERRO: ImageMagick nao encontrado em '$magickPath'. Edite o script para corrigir o caminho."; pause; exit }
if (-not (Test-Path -LiteralPath $gsPath))       { Write-Host "ERRO: Ghostscript nao encontrado em '$gsPath'. Edite o script para corrigir o caminho."; pause; exit }
Write-Host "  Todas as ferramentas foram encontradas."

# --- Configurações de Conversão ---
$sourceDir = $PSScriptRoot
$outputFolders = @("JPG", "PNG", "PDF", "EPS", "SVG")
$validImageExtensions = @(".ai", ".cdr", ".psd", ".eps", ".svg", ".pdf", ".png", ".jpg", ".jpeg", ".gif", ".tiff", ".bmp", ".webp")

# --- Cria as pastas de destino ---
Write-Host "Criando pastas de destino..."
foreach ($folder in $outputFolders) {
    $folderPath = Join-Path -Path $sourceDir -ChildPath $folder
    if (-not (Test-Path -LiteralPath $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }
}

# --- Coleta todos os arquivos ---
Write-Host "Procurando arquivos de imagem compativeis..."
$allFiles = Get-ChildItem -Path $sourceDir -Recurse -File
$filesToProcess = @()
foreach ($file in $allFiles) {
    $ext = $file.Extension.ToLower()
    $dirName = $file.Directory.Name
    if (($validImageExtensions -contains $ext) -and ($outputFolders -notcontains $dirName)) {
        $filesToProcess += $file
    }
}

if ($filesToProcess.Count -eq 0) { Write-Host "Nenhum arquivo de imagem compativel encontrado na origem."; pause; exit }

Write-Host "Iniciando conversao de $($filesToProcess.Count) arquivos..."
$startTime = Get-Date
$successCount = @{ "JPG" = 0; "PNG" = 0; "PDF" = 0; "EPS" = 0; "SVG" = 0 }

# ===================================================================================
# BLOCO DE PROCESSAMENTO - LÓGICA FINAL E ESTÁVEL
# ===================================================================================
foreach ($file in $filesToProcess) {
    if ($file.Name.StartsWith("~$")) { continue }

    $baseName = $file.BaseName
    $extension = $file.Extension.ToLower()
    $inputFile = $file.FullName
    $inputFileLayer0 = "$($file.FullName)[0]"

    $jpgDest = Join-Path $sourceDir "JPG\$baseName.jpg"
    $pngDest = Join-Path $sourceDir "PNG\$baseName.png"
    $pdfDest = Join-Path $sourceDir "PDF\$baseName.pdf"
    $epsDest = Join-Path $sourceDir "EPS\$baseName.eps"
    $svgDest = Join-Path $sourceDir "SVG\$baseName.svg"

    Write-Host "---"
    Write-Host "Processando: $($file.Name)"
    $status = @{}

    # --- JPG ---
    try {
        if ($extension -in @(".jpg", ".jpeg")) { Copy-Item $inputFile $jpgDest -Force } 
        elseif ($extension -eq ".cdr") { $tempPdf = Join-Path $env:TEMP "$baseName-jpg.pdf"; & $inkscapePath "$inputFile" --export-type="pdf" "--export-filename=$tempPdf"; if (Test-Path $tempPdf) { & $magickPath "$tempPdf" -resize "2000x2000^>" -background white -flatten -quality 100 "$jpgDest"; Remove-Item $tempPdf -Force } } 
        else { & $magickPath "$inputFileLayer0" -resize "2000x2000^>" -background white -flatten -quality 100 "$jpgDest" }
        Start-Sleep -Milliseconds 500; $status["JPG"] = if (Test-Path $jpgDest) { "OK" } else { "FALHA" }
    } catch { $status["JPG"] = "ERRO" }

    # --- PNG ---
    try {
        if ($extension -eq ".png") { Copy-Item $inputFile $pngDest -Force } 
        elseif ($extension -eq ".cdr") { $tempPdf = Join-Path $env:TEMP "$baseName-png.pdf"; & $inkscapePath "$inputFile" --export-type="pdf" "--export-filename=$tempPdf"; if (Test-Path $tempPdf) { & $magickPath "$tempPdf" -resize "2000x2000^>" -quality 100 -density 300 "$pngDest"; Remove-Item $tempPdf -Force } } 
        else { & $magickPath "$inputFileLayer0" -resize "2000x2000^>" -quality 100 -density 300 "$pngDest" }
        Start-Sleep -Milliseconds 500; $status["PNG"] = if (Test-Path $pngDest) { "OK" } else { "FALHA" }
    } catch { $status["PNG"] = "ERRO" }

    # --- PDF ---
    try {
        if ($extension -eq ".pdf") { Copy-Item $inputFile $pdfDest -Force } 
        elseif ($extension -in @(".ai", ".cdr", ".svg")) { & $inkscapePath "$inputFile" --export-type="pdf" "--export-filename=$pdfDest" }
        elseif ($extension -eq ".eps") { & $gsPath -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER "-sOutputFile=$pdfDest" "$inputFile" }
        else { & $magickPath "$inputFileLayer0" "$pdfDest" }
        Start-Sleep -Milliseconds 500; $status["PDF"] = if (Test-Path $pdfDest) { "OK" } else { "FALHA" }
    } catch { $status["PDF"] = "ERRO" }

    # --- EPS ---
    try {
        if ($extension -eq ".eps") { Copy-Item $inputFile $epsDest -Force } 
        elseif ($extension -in @(".ai", ".cdr", ".svg")) { & $inkscapePath "$inputFile" --export-type="eps" "--export-filename=$epsDest" } 
        else { & $magickPath "$inputFileLayer0" "$epsDest" }
        Start-Sleep -Milliseconds 500; $status["EPS"] = if (Test-Path $epsDest) { "OK" } else { "FALHA" }
    } catch { $status["EPS"] = "ERRO" }

    # --- SVG ---
    try {
        if ($extension -eq ".svg") { Copy-Item $inputFile $svgDest -Force } 
        elseif ($extension -in @(".ai", ".cdr", ".pdf")) { & $inkscapePath "$inputFile" --export-type="svg" "--export-filename=$svgDest" } 
        elseif ($extension -eq ".eps") {
            $tempPdf = Join-Path $env:TEMP "$baseName-svg-$(Get-Random).pdf"
            & $gsPath -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER "-sOutputFile=$tempPdf" "$inputFile" 2>$null
            Start-Sleep -Milliseconds 300
            if (Test-Path $tempPdf) {
                & $inkscapePath "$tempPdf" --export-type="svg" "--export-filename=$svgDest" 2>$null
                Remove-Item $tempPdf -Force -ErrorAction SilentlyContinue
            }
        } else { & $magickPath "$inputFileLayer0" "$svgDest" }
        Start-Sleep -Milliseconds 500; $status["SVG"] = if (Test-Path $svgDest) { "OK" } else { "FALHA" }
    } catch { $status["SVG"] = "ERRO" }

    # --- RELATÓRIO POR ARQUIVO ---
    Write-Host "  Resultado da conversao:"
    foreach ($key in $status.Keys | Sort-Object) {
        $statusText = $status[$key]
        $color = if ($statusText -eq "OK") { "Green" } else { "Red" }
        Write-Host "    $key -> $statusText" -ForegroundColor $color
        if ($statusText -eq "OK") { $successCount[$key]++ }
    }
}

# --- FINALIZAÇÃO ---
$duration = (Get-Date) - $startTime
$totalProcessed = $filesToProcess.Count

Write-Host "---"
Write-Host "Todas as conversoes foram concluidas!" -ForegroundColor Green
Write-Host "Tempo total de execucao: $($duration.ToString('g'))"

# --- ESTATÍSTICAS FINAIS ---
Write-Host "---"
Write-Host "ESTATISTICAS FINAIS:" -ForegroundColor Cyan
foreach ($folder in $outputFolders) {
    $count = $successCount[$folder]
    $percentage = if ($totalProcessed -gt 0) { [math]::Round(($count / $totalProcessed) * 100, 0) } else { 0 }
    $color = if ($percentage -eq 100) { "Green" } elseif ($percentage -ge 80) { "Yellow" } else { "Red" }
    Write-Host "  $folder`: $count/$totalProcessed arquivos ($percentage`%)" -ForegroundColor $color
}
pause
