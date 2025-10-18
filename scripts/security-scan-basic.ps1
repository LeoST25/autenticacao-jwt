# Script de Seguranca Basico - Deteccao Manual de Segredos
# Funciona sem ggshield instalado

Write-Host "Executando verificacao basica de seguranca..." -ForegroundColor Blue
Write-Host ""

$secretPatterns = @{
    "API Key" = @(
        'api[_-]?key\s*[=:]\s*["\x27][^"\x27]{10,}["\x27]',
        'apikey\s*[=:]\s*["\x27][^"\x27]{10,}["\x27]'
    )
    "AWS Key" = @(
        'AKIA[0-9A-Z]{16}',
        'aws[_-]?secret[_-]?access[_-]?key'
    )
    "GitHub Token" = @(
        'ghp_[0-9a-zA-Z]{36}',
        'github[_-]?token'
    )
    "JWT Real" = @(
        'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'
    )
    "Password in Code" = @(
        'password\s*[=:]\s*["\x27][^"\x27]{6,}["\x27]',
        'pwd\s*[=:]\s*["\x27][^"\x27]{6,}["\x27]'
    )
    "Database URL" = @(
        'mongodb\+srv://[^/\s]+:[^@\s]+@[^/\s]+',
        'mysql://[^/\s]+:[^@\s]+@[^/\s]+',
        'postgres://[^/\s]+:[^@\s]+@[^/\s]+'
    )
    "Private Key" = @(
        '-----BEGIN PRIVATE KEY-----',
        '-----BEGIN RSA PRIVATE KEY-----'
    )
}

# Arquivos a ignorar
$ignorePatterns = @(
    'node_modules/',
    '.git/',
    '*.log',
    'package-lock.json'
)

$totalSecrets = 0
$secretsFound = @()

function Test-FileForSecrets {
    param(
        [string]$filePath,
        [hashtable]$patterns
    )
    
    if (-not (Test-Path $filePath)) {
        return @()
    }
    
    try {
        $content = Get-Content $filePath -Raw -ErrorAction SilentlyContinue
        if (-not $content) { return @() }
        
        $foundSecrets = @()
        
        foreach ($category in $patterns.Keys) {
            foreach ($pattern in $patterns[$category]) {
                $matches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                
                foreach ($match in $matches) {
                    $foundSecrets += [PSCustomObject]@{
                        File = $filePath
                        Category = $category
                        Pattern = $pattern
                        Match = $match.Value
                        Line = ($content.Substring(0, $match.Index) -split "`n").Count
                    }
                }
            }
        }
        
        return $foundSecrets
    }
    catch {
        Write-Host "Erro ao processar arquivo: $filePath" -ForegroundColor Yellow
        return @()
    }
}

function Get-FilesToCheck {
    $allFiles = @()
    
    # Buscar arquivos JavaScript (excluindo node_modules)
    $jsFiles = Get-ChildItem -Path "." -Filter "*.js" -Recurse | Where-Object {
        $_.FullName -notlike "*node_modules*" -and $_.FullName -notlike "*.git*"
    }
    
    $allFiles += $jsFiles
    
    # Buscar arquivos de configuracao
    $configFiles = @()
    if (Test-Path "config") {
        $configFiles = Get-ChildItem -Path "config" -Recurse
    }
    $allFiles += $configFiles
    
    # Buscar arquivos .env
    $envFiles = Get-ChildItem -Path "." -Filter ".env*"
    $allFiles += $envFiles
    
    # Buscar arquivos package.json
    $packageFiles = Get-ChildItem -Path "." -Filter "package*.json" -Recurse
    $allFiles += $packageFiles
    
    return $allFiles | Sort-Object FullName -Unique
}

Write-Host "Escaneando arquivos..." -ForegroundColor Green

$filesToCheck = Get-FilesToCheck
$processedFiles = 0

foreach ($file in $filesToCheck) {
    $processedFiles++
    Write-Progress -Activity "Escaneando arquivos" -Status "Processando: $($file.Name)" -PercentComplete (($processedFiles / $filesToCheck.Count) * 100)
    
    $secrets = Test-FileForSecrets -filePath $file.FullName -patterns $secretPatterns
    
    if ($secrets.Count -gt 0) {
        $secretsFound += $secrets
        $totalSecrets += $secrets.Count
    }
}

Write-Progress -Activity "Escaneando arquivos" -Completed

Write-Host ""
Write-Host "=== RESULTADO DA VERIFICACAO ===" -ForegroundColor Cyan
Write-Host ""

if ($totalSecrets -eq 0) {
    Write-Host "Nenhum segredo detectado nos arquivos escaneados!" -ForegroundColor Green
    Write-Host "   Arquivos verificados: $($filesToCheck.Count)" -ForegroundColor Gray
} else {
    Write-Host "Encontrados $totalSecrets possivel(is) segredo(s):" -ForegroundColor Yellow
    Write-Host ""
    
    # Agrupar por arquivo
    $groupedSecrets = $secretsFound | Group-Object -Property File
    
    foreach ($group in $groupedSecrets) {
        Write-Host "Arquivo: $($group.Name)" -ForegroundColor Red
        
        foreach ($secret in $group.Group) {
            Write-Host "   Linha $($secret.Line): $($secret.Category)" -ForegroundColor Yellow
            Write-Host "      Padrao: $($secret.Match.Substring(0, [Math]::Min(50, $secret.Match.Length)))..." -ForegroundColor Gray
        }
        Write-Host ""
    }
}

Write-Host "Para protecao avancada, instale o GitGuardian:" -ForegroundColor Blue
Write-Host "   npm run security:install-ggshield" -ForegroundColor Gray
Write-Host ""

if ($totalSecrets -gt 0) {
    Write-Host "Verificacao concluida com alertas." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "Verificacao concluida com sucesso!" -ForegroundColor Green
    exit 0
}