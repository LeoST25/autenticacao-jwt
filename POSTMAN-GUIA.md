# 🚀 Guia Completo: Testando API no Postman

## 📥 1. CONFIGURAÇÃO INICIAL DO POSTMAN

### Criando uma Nova Collection

1. **Abra o Postman**
2. **Clique em "New"** → **"Collection"**
3. **Nome da Collection:** `JWT Authentication API`
4. **Descrição:** `API de autenticação com JWT - Sistema completo`

### Configurando Variáveis de Ambiente

1. **Clique no ícone de "Environment"** (canto superior direito)
2. **Crie um novo Environment:** `JWT Auth Local`
3. **Adicione estas variáveis:**

| Variable | Initial Value | Current Value |
|----------|---------------|---------------|
| `base_url` | `http://localhost:3000` | `http://localhost:3000` |
| `token` | *(deixe vazio)* | *(deixe vazio)* |

4. **Salve** e **selecione este environment**

## � CADASTRO EM MASSA (NOVO!)

Esta aplicação agora inclui ferramentas para cadastro automático de usuários:

### 📋 Usuários Pré-configurados

- **Arquivo:** `usuarios-teste.json` (100 usuários)
- **Senhas seguras:** Maiúscula + minúscula + números + caracteres especiais
- **Exemplos:**
  - Ana Silva Santos → `Ana@2024!`
  - Bruno Costa Lima → `Bruno#123`

### 🤖 Script Automático

Execute no PowerShell:
```powershell
.\cadastrar-usuarios.ps1
```

Isso cadastrará todos os 100 usuários automaticamente!

### 📋 Uso Manual no Postman

Copie qualquer usuário do `usuarios-teste.json`:
```json
{
  "name": "Ana Silva Santos",
  "email": "ana.silva.santos@gmail.com",
  "password": "Ana@2024!"
}
```

## �📝 2. CRIANDO AS REQUISIÇÕES

### 🏥 Request 1: Health Check

**Método:** `GET`  
**URL:** `{{base_url}}/health`

**Headers:** *(nenhum necessário)*

**Descrição:** Verifica se o servidor está funcionando

---

### 📚 Request 2: API Info

**Método:** `GET`  
**URL:** `{{base_url}}/api`

**Headers:** *(nenhum necessário)*

**Descrição:** Mostra informações e endpoints disponíveis

---

### 👤 Request 3: Registrar Usuário

**Método:** `POST`  
**URL:** `{{base_url}}/api/auth/register`

**Headers:**
```
Content-Type: application/json
```

**Body (raw → JSON):**
```json
{
  "name": "Maria Silva",
  "email": "maria@exemplo.com",
  "password": "MinhaSenh@123"
}
```

**Tests (opcional - para capturar o token automaticamente):**
```javascript
// Se o registro foi bem-sucedido, salvar o token
if (pm.response.code === 201) {
    const responseJson = pm.response.json();
    pm.environment.set("token", responseJson.data.token);
    console.log("Token salvo automaticamente:", responseJson.data.token.substring(0, 30) + "...");
}
```

---

### 🔑 Request 4: Login

**Método:** `POST`  
**URL:** `{{base_url}}/api/auth/login`

**Headers:**
```
Content-Type: application/json
```

**Body (raw → JSON):**
```json
{
  "email": "maria@exemplo.com",
  "password": "MinhaSenh@123"
}
```

**Tests (opcional - para capturar o token automaticamente):**
```javascript
// Se o login foi bem-sucedido, salvar o token
if (pm.response.code === 200) {
    const responseJson = pm.response.json();
    pm.environment.set("token", responseJson.data.token);
    console.log("Token atualizado:", responseJson.data.token.substring(0, 30) + "...");
}
```

---

### 👨‍💼 Request 5: Ver Perfil (Rota Protegida)

**Método:** `GET`  
**URL:** `{{base_url}}/api/auth/profile`

**Headers:**
```
Authorization: Bearer {{token}}
```

**Descrição:** Mostra o perfil do usuário logado

---

### ✏️ Request 6: Atualizar Perfil

**Método:** `PUT`  
**URL:** `{{base_url}}/api/auth/profile`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Body (raw → JSON):**
```json
{
  "name": "Maria Santos Silva",
  "email": "maria.santos@exemplo.com"
}
```

---

### 🔒 Request 7: Alterar Senha

**Método:** `PUT`  
**URL:** `{{base_url}}/api/auth/change-password`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Body (raw → JSON):**
```json
{
  "currentPassword": "MinhaSenh@123",
  "newPassword": "NovaSenha@456",
  "confirmPassword": "NovaSenha@456"
}
```

---

### 📊 Request 8: Dashboard (Rota Protegida)

**Método:** `GET`  
**URL:** `{{base_url}}/api/protected/dashboard`

**Headers:**
```
Authorization: Bearer {{token}}
```

**Descrição:** Acessa o dashboard do usuário

---

### 👑 Request 9: Área Admin (Somente Admin)

**Método:** `GET`  
**URL:** `{{base_url}}/api/protected/admin`

**Headers:**
```
Authorization: Bearer {{token}}
```

**Descrição:** Acessa área administrativa (precisa ser admin)

---

### 📋 Request 10: Listar Usuários (Somente Admin)

**Método:** `GET`  
**URL:** `{{base_url}}/api/protected/users`

**Headers:**
```
Authorization: Bearer {{token}}
```

**Descrição:** Lista todos os usuários (precisa ser admin)

## 🎯 3. FLUXO DE TESTE RECOMENDADO

### Ordem para testar:

1. **Health Check** - Verifica se servidor está rodando
2. **API Info** - Vê informações da API
3. **Registrar Usuário** - Cria novo usuário (token é salvo automaticamente)
4. **Login** - Faz login (atualiza o token)
5. **Ver Perfil** - Testa rota protegida básica
6. **Dashboard** - Testa outra rota protegida
7. **Atualizar Perfil** - Testa update de dados
8. **Alterar Senha** - Testa alteração de senha

### Para testar como Admin:

9. **Conecte no MongoDB** e transforme o usuário em admin:
   ```bash
   docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
   use auth_jwt
   db.users.updateOne({email: "maria@exemplo.com"}, {$set: {role: "admin"}})
   ```

10. **Faça Login novamente** para obter token com role admin
11. **Teste Área Admin**
12. **Teste Listar Usuários**

## 📂 4. EXEMPLO DE COLLECTION PRONTA

Você pode importar esta collection diretamente no Postman:

```json
{
  "info": {
    "name": "JWT Authentication API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "http://localhost:3000"
    }
  ],
  "item": [
    {
      "name": "1. Health Check",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "{{base_url}}/health",
          "host": ["{{base_url}}"],
          "path": ["health"]
        }
      }
    },
    {
      "name": "2. API Info",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "{{base_url}}/api",
          "host": ["{{base_url}}"],
          "path": ["api"]
        }
      }
    },
    {
      "name": "3. Register User",
      "event": [
        {
          "listen": "test",
          "script": {
            "exec": [
              "if (pm.response.code === 201) {",
              "    const responseJson = pm.response.json();",
              "    pm.environment.set(\"token\", responseJson.data.token);",
              "}"
            ]
          }
        }
      ],
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"name\": \"Maria Silva\",\n  \"email\": \"maria@exemplo.com\",\n  \"password\": \"MinhaSenh@123\"\n}"
        },
        "url": {
          "raw": "{{base_url}}/api/auth/register",
          "host": ["{{base_url}}"],
          "path": ["api", "auth", "register"]
        }
      }
    },
    {
      "name": "4. Login",
      "event": [
        {
          "listen": "test",
          "script": {
            "exec": [
              "if (pm.response.code === 200) {",
              "    const responseJson = pm.response.json();",
              "    pm.environment.set(\"token\", responseJson.data.token);",
              "}"
            ]
          }
        }
      ],
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"email\": \"maria@exemplo.com\",\n  \"password\": \"MinhaSenh@123\"\n}"
        },
        "url": {
          "raw": "{{base_url}}/api/auth/login",
          "host": ["{{base_url}}"],
          "path": ["api", "auth", "login"]
        }
      }
    },
    {
      "name": "5. Get Profile",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/auth/profile",
          "host": ["{{base_url}}"],
          "path": ["api", "auth", "profile"]
        }
      }
    },
    {
      "name": "6. Protected Dashboard",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/protected/dashboard",
          "host": ["{{base_url}}"],
          "path": ["api", "protected", "dashboard"]
        }
      }
    }
  ]
}
```

## 🔧 5. DICAS IMPORTANTES

### ✅ Verificações antes de testar:

1. **Servidor rodando?**
   ```bash
   npm run dev
   ```

2. **MongoDB conectado?**
   ```bash
   npm run docker:up
   ```

### 🎯 Respostas esperadas:

- **Registro (201):** Usuário criado + token
- **Login (200):** Dados do usuário + token  
- **Rotas protegidas (200):** Dados solicitados
- **Erros (400/401/403):** Mensagens de erro claras

### 🔑 Gerenciamento de Token:

- O token é **automaticamente capturado** se você usar os scripts de teste
- Você pode **copiar/colar manualmente** se preferir
- Tokens **expiram em 7 dias** (configurável no .env)

### 📱 Testando diferentes usuários:

Crie múltiplos usuários alterando:
```json
{
  "name": "João Santos",
  "email": "joao@exemplo.com", 
  "password": "OutraSenh@456"
}
```

## 🐛 6. TROUBLESHOOTING

### Erro comum: "Rota não encontrada"
- ✅ Verificar URL: `/api/auth/register`
- ✅ Verificar método: `POST`
- ✅ Verificar Content-Type: `application/json`

### Erro: "Token inválido"
- ✅ Verificar header: `Authorization: Bearer {{token}}`
- ✅ Fazer login novamente para token válido

### 🚀 Cadastro em Massa
- ✅ Use `usuarios-teste.json` para 100 usuários pré-configurados
- ✅ Execute `cadastrar-usuarios.ps1` para cadastro automático
- ✅ Sem limites de tentativas - cadastre quantos usuários precisar

---

**🎉 Agora você pode testar toda a API de forma visual e organizada no Postman!**