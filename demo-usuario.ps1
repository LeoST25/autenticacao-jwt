Write-Host "=== DEMONSTRAÇÃO: CRIAR USUÁRIO E FAZER LOGIN ===" -ForegroundColor Green
Write-Host ""

# Verificar se servidor está rodando
try {
    $null = Invoke-WebRequest -Uri "http://localhost:3000/health" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Servidor está rodando!" -ForegroundColor Green
} catch {
    Write-Host "❌ Servidor não está rodando. Execute 'npm run dev' primeiro!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔸 PASSO 1: Registrando usuário..." -ForegroundColor Cyan

# Dados do usuário
$dadosUsuario = @{
    name = "João Exemplo"
    email = "joao.exemplo@teste.com"
    password = "MinhaSenh@123"
} | ConvertTo-Json

try {
    # Tentar registrar
    $registro = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" -Method POST -Body $dadosUsuario -ContentType "application/json"
    $registroData = $registro.Content | ConvertFrom-Json
    
    Write-Host "✅ USUÁRIO REGISTRADO COM SUCESSO!" -ForegroundColor Green
    Write-Host "👤 Nome: $($registroData.data.user.name)" -ForegroundColor White
    Write-Host "📧 Email: $($registroData.data.user.email)" -ForegroundColor White
    Write-Host "🆔 ID: $($registroData.data.user._id)" -ForegroundColor White
    Write-Host "🔑 Token recebido: $($registroData.data.token.Substring(0,30))..." -ForegroundColor Yellow
    
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "ℹ️  Usuário já existe, continuando para o login..." -ForegroundColor Cyan
    } else {
        Write-Host "❌ Erro no registro: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "🔸 PASSO 2: Fazendo login com o usuário..." -ForegroundColor Cyan

# Dados de login
$dadosLogin = @{
    email = "joao.exemplo@teste.com"
    password = "MinhaSenh@123"
} | ConvertTo-Json

try {
    $login = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" -Method POST -Body $dadosLogin -ContentType "application/json"
    $loginData = $login.Content | ConvertFrom-Json
    
    Write-Host "✅ LOGIN REALIZADO COM SUCESSO!" -ForegroundColor Green
    Write-Host "👤 Usuário: $($loginData.data.user.name)" -ForegroundColor White
    Write-Host "📧 Email: $($loginData.data.user.email)" -ForegroundColor White
    Write-Host "⏰ Último login: $($loginData.data.user.lastLogin)" -ForegroundColor White
    Write-Host "🔑 Novo token: $($loginData.data.token.Substring(0,30))..." -ForegroundColor Yellow
    
    # Guardar o token para teste da rota protegida
    $token = $loginData.data.token
    
} catch {
    Write-Host "❌ Erro no login: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔸 PASSO 3: Testando rota protegida..." -ForegroundColor Cyan

try {
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    $dashboard = Invoke-WebRequest -Uri "http://localhost:3000/api/protected/dashboard" -Headers $headers
    $dashboardData = $dashboard.Content | ConvertFrom-Json
    
    Write-Host "✅ ACESSO AUTORIZADO À ROTA PROTEGIDA!" -ForegroundColor Green
    Write-Host "📊 Mensagem: $($dashboardData.message)" -ForegroundColor White
    Write-Host "⏰ Timestamp: $($dashboardData.data.timestamp)" -ForegroundColor White
    
} catch {
    Write-Host "❌ Erro ao acessar rota protegida: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 DEMONSTRAÇÃO COMPLETA!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 RESUMO DO QUE ACONTECEU:" -ForegroundColor Yellow
Write-Host "1. ✅ Criamos um usuário via POST /api/auth/register" -ForegroundColor White
Write-Host "2. ✅ Fizemos login via POST /api/auth/login" -ForegroundColor White  
Write-Host "3. ✅ Acessamos rota protegida com o token JWT" -ForegroundColor White
Write-Host ""
Write-Host "🔑 O usuário foi salvo no MongoDB e pode ser usado novamente!" -ForegroundColor Cyan