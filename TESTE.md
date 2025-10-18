# Guia de Teste da API de Autenticação

## 🚀 Como Iniciar o Sistema

### 1. Primeiro, inicie o Docker Desktop
Certifique-se de que o Docker Desktop está rodando no seu sistema Windows.

### 2. Suba o banco MongoDB
```bash
npm run docker:up
```

### 3. Inicie o servidor
```bash
npm run dev
```

## 📋 Testando os Endpoints

### 1. Health Check
```bash
curl http://localhost:3000/health
```

### 2. Informações da API
```bash
curl http://localhost:3000/api
```

### 3. Registrar um Usuário
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

**Resposta esperada:**
```json
{
  "success": true,
  "message": "Usuário registrado com sucesso",
  "data": {
    "user": {
      "_id": "...",
      "name": "João Silva",
      "email": "joao@exemplo.com",
      "role": "user",
      "isActive": true,
      "createdAt": "...",
      "updatedAt": "..."
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 4. Fazer Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

### 5. Acessar Perfil (Rota Protegida)
**Substitua `SEU_TOKEN_AQUI` pelo token recebido no login/registro**
```bash
curl -X GET http://localhost:3000/api/protected/dashboard \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

### 6. Obter Perfil do Usuário
```bash
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

### 7. Atualizar Perfil
```bash
curl -X PUT http://localhost:3000/api/auth/profile \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "name": "João Santos",
    "email": "joao.santos@exemplo.com"
  }'
```

### 8. Alterar Senha
```bash
curl -X PUT http://localhost:3000/api/auth/change-password \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "currentPassword": "MinhaSenh@123",
    "newPassword": "NovaSenha@456",
    "confirmPassword": "NovaSenha@456"
  }'
```

## 🔐 Testando com Usuário Admin

### 1. Criar Usuário Admin (Direto no MongoDB)
Primeiro, conecte ao MongoDB:
```bash
docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
```

Depois, no shell do MongoDB:
```javascript
use auth_jwt

// Criar um usuário admin
db.users.updateOne(
  { email: "joao@exemplo.com" },
  { $set: { role: "admin" } }
)
```

### 2. Testar Rota Admin
```bash
curl -X GET http://localhost:3000/api/protected/admin \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

### 3. Listar Todos os Usuários (Admin)
```bash
curl -X GET http://localhost:3000/api/protected/users \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

## 🧪 Testando Validações e Segurança

### 1. Teste de Senha Fraca
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Teste",
    "email": "teste@exemplo.com",
    "password": "123"
  }'
```

**Deve retornar erro de validação**

### 2. Teste de Email Duplicado
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Duplicado",
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

**Deve retornar erro informando que o email já está em uso**

### 3. Teste de Token Inválido
```bash
curl -X GET http://localhost:3000/api/protected/dashboard \
  -H "Authorization: Bearer token_invalido"
```

**Deve retornar erro 401 - Token inválido**

### 4. Teste sem Token
```bash
curl -X GET http://localhost:3000/api/protected/dashboard
```

**Deve retornar erro 401 - Token não fornecido**

## 🔍 Rate Limiting

Teste fazendo muitas requisições rapidamente para ver o rate limiting em ação:

```bash
for i in {1..10}; do
  curl -X POST http://localhost:3000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"wrong@email.com","password":"wrongpass"}' &
done
```

Após algumas tentativas, você deve receber:
```json
{
  "success": false,
  "message": "Muitas tentativas de login. Tente novamente em 15 minutos."
}
```

## 📱 Testando com Postman/Insomnia

1. Importe as rotas criando uma nova collection
2. Configure as seguintes variáveis:
   - `base_url`: http://localhost:3000
   - `token`: (será preenchido após login)

3. Para as rotas protegidas, use:
   - Authorization Type: Bearer Token
   - Token: `{{token}}`

## 🐛 Troubleshooting

### Erro de conexão MongoDB
```
MongoNetworkError: connect ECONNREFUSED 127.0.0.1:27017
```
**Solução:** Certifique-se de que o MongoDB está rodando: `npm run docker:up`

### Docker não está rodando
```
error during connect: Get "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine
```
**Solução:** Inicie o Docker Desktop

### Porta 3000 em uso
```
EADDRINUSE: address already in use :::3000
```
**Solução:** Pare outros processos na porta 3000 ou altere a porta no `.env`

## 📊 Monitoramento

### Ver Logs do MongoDB
```bash
docker logs auth_jwt_mongodb
```

### Ver Logs da Aplicação
Os logs aparecem no terminal onde você executou `npm run dev`

### Verificar Status dos Containers
```bash
docker ps
```