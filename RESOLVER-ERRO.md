# Guia Rápido - Resolver "Rota não encontrada"

## 🚀 1. Certifique-se que o servidor está rodando

```bash
# Terminal 1: Iniciar servidor
npm run dev

# Deve aparecer:
# 🚀 Servidor iniciado com sucesso!
# 📍 Porta: 3000
```

## 🔍 2. Rotas Disponíveis (GET - funcionam no navegador)

✅ **Estas rotas funcionam no navegador:**
- http://localhost:3000/health
- http://localhost:3000/api

❌ **Estas rotas NÃO funcionam no navegador (são POST):**
- http://localhost:3000/api/auth/register
- http://localhost:3000/api/auth/login

## 📝 3. Como Testar Corretamente

### No PowerShell (Windows):

```powershell
# 1. Registrar usuário
$body = @{
    name = "João Silva"
    email = "joao@exemplo.com"
    password = "MinhaSenh@123"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" -Method POST -Body $body -ContentType "application/json"
```

```powershell
# 2. Fazer login
$loginBody = @{
    email = "joao@exemplo.com"
    password = "MinhaSenh@123"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = ($response.Content | ConvertFrom-Json).data.token
```

```powershell
# 3. Acessar rota protegida
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-WebRequest -Uri "http://localhost:3000/api/protected/dashboard" -Headers $headers
```

### Com curl (se disponível):

```bash
# Registrar
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"João Silva","email":"joao@exemplo.com","password":"MinhaSenh@123"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"joao@exemplo.com","password":"MinhaSenh@123"}'

# Rota protegida (substitua SEU_TOKEN)
curl -H "Authorization: Bearer SEU_TOKEN" http://localhost:3000/api/protected/dashboard
```

## 🐛 4. Checklist de Troubleshooting

- [ ] Servidor está rodando? (`npm run dev`)
- [ ] MongoDB está conectado? (deve aparecer "MongoDB conectado")
- [ ] URL correta? (deve começar com `/api/`)
- [ ] Método HTTP correto? (POST para register/login)
- [ ] Content-Type header? (`application/json` para POST)
- [ ] Token válido para rotas protegidas?

## 📋 5. Todas as Rotas Disponíveis

### Públicas (não precisam de token):
- `GET /health` - Status do servidor
- `GET /api` - Documentação
- `POST /api/auth/register` - Registrar usuário
- `POST /api/auth/login` - Fazer login

### Protegidas (precisam de token):
- `GET /api/auth/profile` - Ver perfil
- `PUT /api/auth/profile` - Atualizar perfil
- `PUT /api/auth/change-password` - Alterar senha
- `GET /api/protected/dashboard` - Dashboard
- `GET /api/protected/admin` - Área admin (só admin)
- `GET /api/protected/users` - Listar usuários (só admin)

## 🔧 6. Teste Rápido

Execute no PowerShell:

```powershell
# Teste básico
Invoke-WebRequest "http://localhost:3000/health"

# Se funcionar, o servidor está OK
# Se não funcionar, execute: npm run dev
```