# GitGuardian Pre-commit Hook para Windows PowerShell
# Executa o scan de segurança antes de cada commit

Write-Host "🔒 Executando GitGuardian scan..." -ForegroundColor Blue

# Verifica se ggshield está instalado
try {
    $null = Get-Command ggshield -ErrorAction Stop
} catch {
    Write-Host "⚠️  ggshield não está instalado." -ForegroundColor Yellow
    Write-Host "� Executando scan básico como alternativa..." -ForegroundColor Cyan
    Write-Host ""
    
    # Executar scan básico
    $basicScanPath = Join-Path $PSScriptRoot "security-scan-basic.ps1"
    if (Test-Path $basicScanPath) {
        & $basicScanPath
        exit $LASTEXITCODE
    } else {
        Write-Host "📦 Para proteção completa, execute: npm run security:install" -ForegroundColor Cyan
        Write-Host "⏭️  Continuando sem scan..." -ForegroundColor Yellow
        exit 0
    }
}

# Verifica se GITGUARDIAN_API_KEY está configurada
if (-not $env:GITGUARDIAN_API_KEY) {
    Write-Host "⚠️  GITGUARDIAN_API_KEY não configurada." -ForegroundColor Yellow
    Write-Host "🔑 Configure sua API key: https://dashboard.gitguardian.com/settings/api-tokens" -ForegroundColor Cyan
    Write-Host "📝 Execute: `$env:GITGUARDIAN_API_KEY='sua_api_key'" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "⏭️  Continuando sem scan (configure API key para proteção completa)..." -ForegroundColor Yellow
    exit 0
}

# Executa o scan nos arquivos staged
Write-Host "🔍 Executando scan..." -ForegroundColor Blue
ggshield secret scan pre-commit | Out-Host
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host "✅ GitGuardian scan: Nenhum segredo detectado!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ GitGuardian scan: Segredos detectados!" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 Para corrigir:" -ForegroundColor Yellow
    Write-Host "1. Remova os segredos detectados" -ForegroundColor White
    Write-Host "2. Use variáveis de ambiente" -ForegroundColor White
    Write-Host "3. Adicione ao .gitignore se necessário" -ForegroundColor White
    Write-Host "4. Configure exceções no .gitguardian.yml" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  Commit bloqueado por segurança!" -ForegroundColor Red
    exit 1
}