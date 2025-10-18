# Script para cadastrar usuários em massa na API JWT
# Carrega os usuários do arquivo JSON e faz requests para a API

Clear-Host
Write-Host "========================================"
Write-Host "    CADASTRO EM MASSA DE USUÁRIOS"
Write-Host "========================================"
Write-Host ""

# Verificar se o servidor está rodando
try {
    $null = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method GET -TimeoutSec 5
    Write-Host "✅ Servidor está rodando!"
    Write-Host ""
} catch {
    Write-Host "❌ ERRO: Servidor não está rodando!"
    Write-Host "Execute primeiro: npm start"
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit
}

# Carregar usuários do arquivo JSON
if (-not (Test-Path "usuarios-teste.json")) {
    Write-Host "❌ ERRO: Arquivo usuarios-teste.json não encontrado!"
    Read-Host "Pressione ENTER para sair"
    exit
}

$usuariosData = Get-Content "usuarios-teste.json" | ConvertFrom-Json
$usuarios = $usuariosData.usuarios

Write-Host "📋 Encontrados $($usuarios.Count) usuários para cadastrar"
Write-Host ""

$confirmation = Read-Host "Deseja continuar? (s/n)"
if ($confirmation -ne "s" -and $confirmation -ne "S") {
    Write-Host "Operação cancelada."
    exit
}

Write-Host ""
Write-Host "Iniciando cadastros..."
Write-Host ""

$sucessos = 0
$erros = 0
$total = $usuarios.Count

for ($i = 0; $i -lt $total; $i++) {
    $usuario = $usuarios[$i]
    $progresso = [math]::Round((($i + 1) / $total) * 100, 1)
    
    Write-Progress -Activity "Cadastrando usuários" -Status "Usuário $($i + 1) de $total ($progresso%)" -PercentComplete $progresso
    
    try {
        $body = @{
            name = $usuario.name
            email = $usuario.email
            password = $usuario.password
        } | ConvertTo-Json
        
        $null = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/register" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        Write-Host "✅ $($usuario.name) - $($usuario.email)" -ForegroundColor Green
        $sucessos++
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 400) {
            Write-Host "⚠️  $($usuario.name) - $($usuario.email) (já existe)" -ForegroundColor Yellow
        } else {
            Write-Host "❌ $($usuario.name) - $($usuario.email) (erro: $statusCode)" -ForegroundColor Red
            $erros++
        }
    }
    
    # Pequena pausa para não sobrecarregar o servidor
    Start-Sleep -Milliseconds 100
}

Write-Progress -Activity "Cadastrando usuários" -Completed

Write-Host ""
Write-Host "========================================"
Write-Host "    RESULTADO DO CADASTRO"
Write-Host "========================================"
Write-Host "Total de usuários: $total"
Write-Host "Sucessos: $sucessos" -ForegroundColor Green
Write-Host "Erros: $erros" -ForegroundColor Red
Write-Host "Já existentes: $($total - $sucessos - $erros)" -ForegroundColor Yellow
Write-Host ""

if ($sucessos -gt 0) {
    Write-Host "🎉 $sucessos usuários cadastrados com sucesso!"
    Write-Host ""
    Write-Host "PRÓXIMOS PASSOS:"
    Write-Host "1. Use o Postman para testar login com qualquer usuário"
    Write-Host "2. Email: qualquer um da lista"
    Write-Host "3. Senha: Nome@números ou Nome#números (ex: Ana@2024!, Bruno#123)"
    Write-Host "4. Endpoint: POST http://localhost:3000/api/auth/login"
}

Write-Host ""
Read-Host "Pressione ENTER para sair"