# Script de Instalacao do GitGuardian CLI
# Guia interativo para instalacao do ggshield

Write-Host "Instalacao do GitGuardian CLI (ggshield)" -ForegroundColor Blue
Write-Host "=======================================" -ForegroundColor Blue
Write-Host ""

# Verificar se o Python esta instalado
Write-Host "Verificando Python..." -ForegroundColor Green

try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Python encontrado: $pythonVersion" -ForegroundColor Green
    } else {
        Write-Host "Python nao encontrado!" -ForegroundColor Red
        Write-Host "Por favor, instale o Python 3.8+ de https://python.org" -ForegroundColor Yellow
        Read-Host "Pressione ENTER para continuar"
        exit 1
    }
} catch {
    Write-Host "Python nao encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale o Python 3.8+ de https://python.org" -ForegroundColor Yellow
    Read-Host "Pressione ENTER para continuar"
    exit 1
}

Write-Host ""

# Verificar se pip esta disponivel
Write-Host "Verificando pip..." -ForegroundColor Green

$pipFound = $false
$pipCommand = ""

# Tentar diferentes comandos pip
$pipCommands = @("pip", "pip3", "python -m pip", "py -m pip")

foreach ($cmd in $pipCommands) {
    try {
        $result = Invoke-Expression "$cmd --version" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "pip encontrado: $result" -ForegroundColor Green
            $pipCommand = $cmd
            $pipFound = $true
            break
        }
    } catch {
        # Continuar tentando
    }
}

if (-not $pipFound) {
    Write-Host "pip nao encontrado!" -ForegroundColor Red
    Write-Host "Tente instalar com: python -m ensurepip --upgrade" -ForegroundColor Yellow
    Read-Host "Pressione ENTER para continuar"
    exit 1
}

Write-Host ""

# Instalar ggshield
Write-Host "Instalando ggshield..." -ForegroundColor Yellow
Write-Host "Executando: $pipCommand install --user ggshield" -ForegroundColor Gray

try {
    Invoke-Expression "$pipCommand install --user ggshield"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "ggshield instalado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "Erro na instalacao do ggshield" -ForegroundColor Red
        Write-Host "Tente executar manualmente: $pipCommand install ggshield" -ForegroundColor Yellow
        Read-Host "Pressione ENTER para continuar"
        exit 1
    }
} catch {
    Write-Host "Erro na instalacao do ggshield" -ForegroundColor Red
    Write-Host "Tente executar manualmente: $pipCommand install ggshield" -ForegroundColor Yellow
    Read-Host "Pressione ENTER para continuar"
    exit 1
}

Write-Host ""

# Verificar instalacao
Write-Host "Verificando instalacao..." -ForegroundColor Green

try {
    $ggshieldVersion = ggshield --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "ggshield funcional: $ggshieldVersion" -ForegroundColor Green
    } else {
        Write-Host "ggshield instalado mas nao encontrado no PATH" -ForegroundColor Yellow
        Write-Host "Tente reiniciar o terminal" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ggshield instalado mas nao encontrado no PATH" -ForegroundColor Yellow
    Write-Host "Tente reiniciar o terminal" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Proximo passo - Configuracao do GitGuardian:" -ForegroundColor Blue
Write-Host "1. Crie uma conta em https://dashboard.gitguardian.com" -ForegroundColor White
Write-Host "2. Va para Settings > API Keys" -ForegroundColor White
Write-Host "3. Crie uma nova API key" -ForegroundColor White
Write-Host "4. Execute: ggshield auth login --token SEU_TOKEN" -ForegroundColor White
Write-Host ""
Write-Host "Apos a configuracao, teste com:" -ForegroundColor Blue
Write-Host "npm run security:scan" -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para finalizar"