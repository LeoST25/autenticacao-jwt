# 👤 Como Criar Usuário e Testar Login - Passo a Passo

## 🚀 PASSO 1: Certificar que o servidor está rodando

Primeiro, certifique-se de que o servidor está ativo:

```bash
npm run dev
```

Você deve ver:
```
🚀 Servidor iniciado com sucesso!
📍 Porta: 3000
🌍 Ambiente: development
MongoDB conectado: localhost
```

## 📝 PASSO 2: Criar um usuário via registro

### Opção A: PowerShell (Recomendado para Windows)

```powershell
# 1. Defina os dados do usuário
$dadosUsuario = @{
    name = "Maria Silva"
    email = "maria@exemplo.com" 
    password = "MinhaSenh@123"
} | ConvertTo-Json

# 2. Faça a requisição de registro
$registro = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" -Method POST -Body $dadosUsuario -ContentType "application/json"

# 3. Veja a resposta
$registro.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3
```

### Opção B: curl (se disponível)

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Maria Silva",
    "email": "maria@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

### ✅ Resposta esperada do registro:

```json
{
  "success": true,
  "message": "Usuário registrado com sucesso",
  "data": {
    "user": {
      "_id": "671234567890abcdef123456",
      "name": "Maria Silva",
      "email": "maria@exemplo.com",
      "role": "user",
      "isActive": true,
      "createdAt": "2025-10-18T15:30:00.000Z",
      "updatedAt": "2025-10-18T15:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

## 🔑 PASSO 3: Testar o login com o usuário criado

### PowerShell:

```powershell
# 1. Defina os dados de login (mesmo email e senha do registro)
$dadosLogin = @{
    email = "maria@exemplo.com"
    password = "MinhaSenh@123"
} | ConvertTo-Json

# 2. Faça a requisição de login
$login = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" -Method POST -Body $dadosLogin -ContentType "application/json"

# 3. Veja a resposta e guarde o token
$loginResponse = $login.Content | ConvertFrom-Json
$token = $loginResponse.data.token

Write-Host "✅ Login realizado com sucesso!"
Write-Host "🔑 Token: $($token.Substring(0,50))..."
```

### curl:

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maria@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

### ✅ Resposta esperada do login:

```json
{
  "success": true,
  "message": "Login realizado com sucesso",
  "data": {
    "user": {
      "_id": "671234567890abcdef123456",
      "name": "Maria Silva",
      "email": "maria@exemplo.com",
      "role": "user",
      "isActive": true,
      "lastLogin": "2025-10-18T15:35:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

## 🔒 PASSO 4: Testar rota protegida com o token

Após obter o token do login, teste uma rota protegida:

### PowerShell:

```powershell
# Use o token obtido no login
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Teste a rota do dashboard
$dashboard = Invoke-WebRequest -Uri "http://localhost:3000/api/protected/dashboard" -Headers $headers
$dashboard.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3
```

### curl:

```bash
# Substitua SEU_TOKEN pelo token recebido no login
curl -H "Authorization: Bearer SEU_TOKEN" \
     http://localhost:3000/api/protected/dashboard
```

## 📋 PASSO 5: Script completo para testar tudo

Salve este script como `teste-usuario.ps1`:

```powershell
Write-Host "=== TESTE COMPLETO: REGISTRO → LOGIN → ROTA PROTEGIDA ===" -ForegroundColor Green
Write-Host ""

try {
    # 1. REGISTRO
    Write-Host "1️⃣  Registrando usuário..." -ForegroundColor Yellow
    $dadosUsuario = @{
        name = "Teste Silva"
        email = "teste@exemplo.com"
        password = "Senha@123"
    } | ConvertTo-Json

    $registro = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" -Method POST -Body $dadosUsuario -ContentType "application/json" -ErrorAction Stop
    $registroData = $registro.Content | ConvertFrom-Json
    
    Write-Host "✅ Usuário registrado!" -ForegroundColor Green
    Write-Host "👤 Nome: $($registroData.data.user.name)"
    Write-Host "📧 Email: $($registroData.data.user.email)"
    Write-Host ""

    # 2. LOGIN
    Write-Host "2️⃣  Fazendo login..." -ForegroundColor Yellow
    $dadosLogin = @{
        email = "teste@exemplo.com"
        password = "Senha@123"
    } | ConvertTo-Json

    $login = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" -Method POST -Body $dadosLogin -ContentType "application/json" -ErrorAction Stop
    $loginData = $login.Content | ConvertFrom-Json
    $token = $loginData.data.token

    Write-Host "✅ Login realizado!" -ForegroundColor Green
    Write-Host "🔑 Token obtido: $($token.Substring(0,30))..."
    Write-Host ""

    # 3. ROTA PROTEGIDA
    Write-Host "3️⃣  Testando rota protegida..." -ForegroundColor Yellow
    $headers = @{
        "Authorization" = "Bearer $token"
    }

    $dashboard = Invoke-WebRequest -Uri "http://localhost:3000/api/protected/dashboard" -Headers $headers -ErrorAction Stop
    $dashboardData = $dashboard.Content | ConvertFrom-Json

    Write-Host "✅ Acesso autorizado!" -ForegroundColor Green
    Write-Host "📊 Resposta: $($dashboardData.message)"
    Write-Host ""

    Write-Host "🎉 TODOS OS TESTES PASSARAM!" -ForegroundColor Green

} catch {
    if ($_.Exception.Response.StatusCode -eq 400 -and $_.Exception.Response.Content -like "*já está registrado*") {
        Write-Host "ℹ️  Usuário já existe, tentando apenas login..." -ForegroundColor Cyan
        
        # Tentar login direto
        $dadosLogin = @{
            email = "teste@exemplo.com"
            password = "Senha@123"
        } | ConvertTo-Json

        try {
            $login = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" -Method POST -Body $dadosLogin -ContentType "application/json"
            Write-Host "✅ Login realizado com usuário existente!" -ForegroundColor Green
        } catch {
            Write-Host "❌ Erro no login: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
}
```

## 🔍 Onde os usuários ficam salvos?

Os usuários ficam salvos no **MongoDB**. Para visualizar:

### 1. Conectar ao MongoDB via Docker:

```bash
docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
```

### 2. Ver usuários no banco:

```javascript
// Selecionar o banco
use auth_jwt

// Ver todos os usuários
db.users.find().pretty()

// Contar usuários
db.users.countDocuments()

// Buscar usuário específico
db.users.findOne({email: "maria@exemplo.com"})
```

## ⚠️ Erros Comuns e Soluções

### 1. "Email já está registrado"
**Causa:** Tentando registrar com email que já existe
**Solução:** Use outro email ou faça login com o existente

### 2. "Credenciais inválidas" 
**Causa:** Email ou senha incorretos no login
**Solução:** Verifique se usou exatamente os mesmos dados do registro

### 3. "Token inválido"
**Causa:** Token expirado ou malformado
**Solução:** Faça login novamente para obter novo token

### 4. "Rota não encontrada"
**Causa:** URL ou método HTTP incorreto
**Solução:** Use POST para /api/auth/register e /api/auth/login

## 📱 Testando com Postman/Insomnia

Se preferir interface gráfica:

1. **Criar Collection** com base URL: `http://localhost:3000`

2. **Adicionar requests:**
   - POST `/api/auth/register` 
   - POST `/api/auth/login`
   - GET `/api/protected/dashboard`

3. **Para rotas protegidas:**
   - Authorization → Bearer Token
   - Usar token obtido no login

## 🎯 Resumo do Fluxo

```
1. REGISTRO → Cria usuário no MongoDB + retorna token
2. LOGIN → Valida credenciais + retorna novo token  
3. ROTA PROTEGIDA → Usa token para acessar área restrita
```

**Lembre-se:** Sempre use **POST** para registro e login, e inclua o **token** nas rotas protegidas!