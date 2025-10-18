# Script de Teste da API de Autenticação
# Execute este script no PowerShell para testar a API

Write-Host "=== TESTE DA API DE AUTENTICAÇÃO ===" -ForegroundColor Green
Write-Host ""

# Função para fazer requisições
function Test-Endpoint {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [object]$Body = $null,
        [string]$Description
    )
    
    Write-Host "🔍 Testando: $Description" -ForegroundColor Yellow
    Write-Host "📍 $Method $Url"
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            ContentType = "application/json"
        }
        
        if ($Body) {
            $params.Body = ($Body | ConvertTo-Json)
        }
        
        $response = Invoke-WebRequest @params
        
        Write-Host "✅ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "📄 Resposta:"
        $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 5
        Write-Host ""
        
        return $response.Content | ConvertFrom-Json
    }
    catch {
        Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        return $null
    }
}

# Verificar se o servidor está rodando
Write-Host "🌐 Verificando se o servidor está rodando..."
$health = Test-Endpoint -Url "http://localhost:3000/health" -Description "Health Check"

if (-not $health) {
    Write-Host "❌ Servidor não está rodando. Execute 'npm run dev' primeiro!" -ForegroundColor Red
    exit 1
}

# Testar informações da API
Test-Endpoint -Url "http://localhost:3000/api" -Description "Informações da API"

# Testar registro de usuário
$userData = @{
    name = "João Silva"
    email = "joao@exemplo.com"
    password = "MinhaSenh@123"
}

$registerResult = Test-Endpoint -Url "http://localhost:3000/api/auth/register" -Method "POST" -Body $userData -Description "Registro de Usuário"

# Se o registro foi bem-sucedido, testar login
if ($registerResult -and $registerResult.success) {
    $loginData = @{
        email = "joao@exemplo.com"
        password = "MinhaSenh@123"
    }
    
    $loginResult = Test-Endpoint -Url "http://localhost:3000/api/auth/login" -Method "POST" -Body $loginData -Description "Login de Usuário"
    
    # Se o login foi bem-sucedido, testar rotas protegidas
    if ($loginResult -and $loginResult.success) {
        $token = $loginResult.data.token
        
        Write-Host "🔑 Token obtido com sucesso!" -ForegroundColor Green
        Write-Host "Token: $($token.Substring(0, 50))..." -ForegroundColor Cyan
        Write-Host ""
        
        # Testar rota protegida
        try {
            $headers = @{
                "Authorization" = "Bearer $token"
                "Content-Type" = "application/json"
            }
            
            Write-Host "🔒 Testando rota protegida..." -ForegroundColor Yellow
            $protectedResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/protected/dashboard" -Method GET -Headers $headers
            
            Write-Host "✅ Acesso autorizado!" -ForegroundColor Green
            Write-Host "📄 Resposta da rota protegida:"
            $protectedResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 5
            
        }
        catch {
            Write-Host "❌ Erro ao acessar rota protegida: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
} else {
    # Se o usuário já existe, tentar fazer login
    Write-Host "ℹ️  Usuário pode já existir. Tentando fazer login..." -ForegroundColor Cyan
    
    $loginData = @{
        email = "joao@exemplo.com"
        password = "MinhaSenh@123"
    }
    
    $loginResult = Test-Endpoint -Url "http://localhost:3000/api/auth/login" -Method "POST" -Body $loginData -Description "Login de Usuário Existente"
}

Write-Host "=== TESTE CONCLUÍDO ===" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Dicas para resolver 'Rota não encontrada':" -ForegroundColor Yellow
Write-Host "1. Certifique-se de usar o método HTTP correto (POST para registro/login)" -ForegroundColor White
Write-Host "2. Verifique se a URL está correta (ex: /api/auth/register)" -ForegroundColor White
Write-Host "3. Para rotas protegidas, inclua o token: Authorization: Bearer <token>" -ForegroundColor White
Write-Host "4. Use Content-Type: application/json para requisições POST" -ForegroundColor White