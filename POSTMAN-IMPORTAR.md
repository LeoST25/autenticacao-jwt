# 🚀 GUIA RÁPIDO: Importar e Usar no Postman

## 📥 PASSO 1: Importar Collection

### Opção A: Arquivo JSON (Mais Fácil)
1. **Abra o Postman**
2. **Clique em "Import"** (botão no canto superior esquerdo)
3. **Selecione o arquivo:** `JWT-Authentication-API.postman_collection.json`
4. **Clique em "Import"**
5. ✅ **Pronto!** Você terá todas as 10 requisições prontas

### Opção B: Manual
Siga o arquivo `POSTMAN-GUIA.md` para criar manualmente.

## ⚙️ PASSO 2: Configurar Environment

1. **Clique no ícone de "Environment"** (canto superior direito)
2. **Crie um novo environment:** `JWT Local`
3. **Adicione a variável:**
   - **Variable:** `base_url`
   - **Initial Value:** `http://localhost:3000`
   - **Current Value:** `http://localhost:3000`
4. **Salve** e **selecione este environment**

## 🖥️ PASSO 3: Iniciar o Servidor

```bash
# Terminal 1: Subir o MongoDB
npm run docker:up

# Terminal 2: Iniciar a aplicação  
npm run dev
```

Você deve ver:
```
🚀 Servidor iniciado com sucesso!
📍 Porta: 3000
MongoDB conectado: localhost
```

## 🎯 PASSO 4: Testar no Postman

### Ordem Recomendada:

#### 1. 🏥 Health Check
- **Método:** GET
- **Resultado esperado:** Status 200, `"success": true`

#### 2. 👤 Register User  
- **Método:** POST
- **Body:** Altere os dados se necessário:
```json
{
  "name": "Seu Nome Aqui",
  "email": "seu.email@exemplo.com", 
  "password": "SuaSenh@123"
}
```
- **Resultado:** Status 201, usuário criado + token salvo automaticamente

#### 3. 🔑 Login
- **Método:** POST  
- **Body:** Use os mesmos dados do registro
```json
{
  "email": "seu.email@exemplo.com",
  "password": "SuaSenh@123"  
}
```
- **Resultado:** Status 200, login realizado + token atualizado

#### 4. 📊 Protected Dashboard
- **Método:** GET
- **Headers:** `Authorization: Bearer {{token}}` (automático)
- **Resultado:** Status 200, acesso autorizado

#### 5. 👨‍💼 Get Profile
- **Método:** GET
- **Resultado:** Status 200, dados do perfil

#### 6. ✏️ Update Profile
- **Método:** PUT
- **Body:** Altere os dados:
```json
{
  "name": "Novo Nome",
  "email": "novo.email@exemplo.com"
}
```

#### 7. 🔒 Change Password
- **Método:** PUT
- **Body:**
```json
{
  "currentPassword": "SuaSenh@123",
  "newPassword": "NovaSenha@456", 
  "confirmPassword": "NovaSenha@456"
}
```

## 👑 PASSO 5: Tornar Usuário Admin

### 🚀 Método 1: Via Postman (MAIS FÁCIL!)

#### Para o primeiro usuário (setup inicial):
1. **Registre um usuário** primeiro (requisição "Register User")
2. **Faça login** (requisição "Login") 
3. **Execute a requisição:** `⭐ 11. Make Admin (First Setup)`
4. **Faça login novamente** para obter token de admin
5. **Teste as rotas admin:** `👑 9. Admin Area` e `📋 10. List Users`

#### Para usuários subsequentes:
1. **Com usuário admin logado**, execute: `📋 10. List Users`
2. **Copie o ID** do usuário que quer tornar admin
3. **Execute:** `🔄 12. Change User Role (Admin)`
4. **Substitua "USER_ID_AQUI"** pelo ID real do usuário
5. **No body**, confirme: `{"role": "admin"}`

### 🌐 Método 2: Via MongoDB Atlas

#### Para MongoDB Atlas:

#### 🌐 **Para MongoDB Atlas:**
1. **Acesse o MongoDB Atlas:**
   - Vá para https://cloud.mongodb.com/
   - Faça login na sua conta
   - Selecione seu cluster

2. **Abra o MongoDB Compass no Atlas:**
   - Clique em **"Browse Collections"**
   - Ou clique em **"Connect"** → **"Compass"** → **"I have MongoDB Compass"**

3. **Navegue até a collection:**
   - Database: `auth_jwt`
   - Collection: `users`

4. **Encontre seu usuário:**
   - Procure pelo email: `"seu.email@exemplo.com"`
   - Ou clique no filtro e use: `{"email": "seu.email@exemplo.com"}`

5. **Edite o usuário:**
   - Clique no ícone de **lápis (Edit)** ao lado do documento
   - Encontre o campo `"role": "user"`
   - Altere para `"role": "admin"`
   - Clique em **"Update"**

#### 🐳 **Para MongoDB Local (Docker):**
```bash
# Conecte ao MongoDB local
docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
```

```javascript
// Execute no MongoDB
use auth_jwt
db.users.updateOne(
  {email: "seu.email@exemplo.com"}, 
  {$set: {role: "admin"}}
)
```

### Após tornar Admin:
3. **Faça login novamente** no Postman para obter token admin
4. **Teste as rotas admin:**
   - **👑 Admin Area:** GET `/api/protected/admin`
   - **📋 List Users:** GET `/api/protected/users`

## 🔍 EXEMPLO DE USO COMPLETO

### Criando Múltiplos Usuários:

#### Usuário 1 - Regular:
```json
{
  "name": "Ana Silva",
  "email": "ana@exemplo.com",
  "password": "AnaSenh@123"
}
```

#### Usuário 2 - Será Admin:
```json  
{
  "name": "João Admin",
  "email": "joao.admin@exemplo.com",
  "password": "AdminSenh@456"
}
```

#### Usuário 3 - Outro Regular:
```json
{
  "name": "Carlos Santos", 
  "email": "carlos@exemplo.com",
  "password": "CarlosSenh@789"
}
```

## 🌐 ATLAS: Guia Detalhado para Admin

### Passo a Passo Completo no MongoDB Atlas:

1. **Registre um usuário primeiro no Postman:**
   ```json
   {
     "name": "Administrador",
     "email": "admin@exemplo.com",
     "password": "AdminSenh@123"
   }
   ```

2. **Acesse o MongoDB Atlas:**
   - URL: https://cloud.mongodb.com/
   - Faça login na sua conta

3. **Vá para seu cluster:**
   - Clique no nome do seu cluster (`Cluster2`)
   - Clique em **"Browse Collections"**

4. **Navegue até os dados:**
   - Database: `auth_jwt` (deve aparecer automaticamente)
   - Collection: `users` (clique para abrir)

5. **Encontre e edite o usuário:**
   - Você verá uma lista de documentos (usuários)
   - Encontre o usuário com email `"admin@exemplo.com"`
   - Clique no ícone de **lápis** ao lado do documento

6. **Altere o role:**
   - Encontre a linha: `"role": "user"`
   - Altere para: `"role": "admin"`
   - Clique em **"Update"**

7. **Faça login novamente no Postman:**
   - Use o endpoint de Login
   - O novo token terá privilégios de admin

### 🔍 Alternativa: MongoDB Compass

Se preferir usar o MongoDB Compass:

1. **Baixe o MongoDB Compass** (se não tiver)
2. **Conecte ao Atlas:**
   - No Atlas, clique em **"Connect"**
   - Escolha **"Compass"**
   - Copie a string de conexão
   - Cole no Compass e conecte

3. **Edite o usuário:**
   - Navegue: `auth_jwt` → `users`
   - Encontre o usuário
   - Clique em **"Edit Document"**
   - Altere `"role": "admin"`
   - Salve

## 💡 DICAS IMPORTANTES

### ✅ Verificações antes de testar:
- [ ] Servidor rodando (`npm start` ou `npm run dev`)
- [ ] MongoDB Atlas conectado (verificar logs)
- [ ] Environment selecionado no Postman
- [ ] Collection importada
- [ ] Usuário criado e promovido a admin

### 🔑 Gerenciamento Automático de Token:
- O token é **capturado automaticamente** após registro/login
- Não precisa copiar/colar manualmente  
- Válido por 7 dias (configurável)

### 📱 Testando Diferentes Cenários:

#### Senha Fraca (deve dar erro):
```json
{
  "name": "Teste Erro",
  "email": "teste@exemplo.com",
  "password": "123" // Muito simples
}
```

#### Email Duplicado (deve dar erro):
```json
{
  "name": "Outro Nome",
  "email": "ana@exemplo.com", // Email já usado
  "password": "OutraSenh@123"
}
```

#### Login com Senha Errada:
```json
{
  "email": "ana@exemplo.com",
  "password": "SenhaErrada123" // Senha incorreta
}
```

## 🎉 VANTAGENS DO POSTMAN

### ✅ Gerenciamento de Admin Simplificado:
- **Rota especial para primeiro admin:** `/make-admin`
- **Alteração de roles via API:** `/users/:userId/role` 
- **Listagem de usuários:** `/users` (para pegar IDs)
- **Não precisa acessar MongoDB diretamente!**

### ✅ Interface Visual:
- Fácil de organizar requisições
- Histórico de chamadas
- Testes automáticos

### ✅ Captura Automática de Token:
- Token salvo automaticamente
- Usado em todas as rotas protegidas
- Não precisa copiar/colar

### ✅ Testes Integrados:
- Validações automáticas
- Console com logs úteis
- Feedback visual de sucesso/erro

### ✅ Organização:
- Todas as rotas em um lugar
- Documentação embutida
- Fácil de compartilhar com equipe

---

**🎯 Agora você tem tudo pronto para testar sua API de forma profissional no Postman!**

## 🎯 FLUXO COMPLETO DE EXEMPLO

### Cenário: Criar e Configurar Administrador

#### 1️⃣ Registro e Setup Inicial:
```
POST /api/auth/register
{
  "name": "João Administrador",
  "email": "joao.admin@exemplo.com", 
  "password": "AdminSenh@123"
}
```

#### 2️⃣ Login Inicial:
```
POST /api/auth/login
{
  "email": "joao.admin@exemplo.com",
  "password": "AdminSenh@123"  
}
```

#### 3️⃣ Tornar Admin (Primeira vez):
```
POST /api/protected/make-admin
# Sem body - usa o usuário logado
```

#### 4️⃣ Login Novamente (Token Admin):
```
POST /api/auth/login
# Mesmo login para pegar token de admin
```

#### 5️⃣ Testar Poderes de Admin:
```
GET /api/protected/admin     # ✅ Deve funcionar
GET /api/protected/users     # ✅ Lista todos usuários
```

#### 6️⃣ Criar Outro Admin:
```
# Primeiro, registre outro usuário normal
# Depois liste users para pegar o ID
GET /api/protected/users

# Use o ID para promover
PUT /api/protected/users/USUARIO_ID/role
{
  "role": "admin"
}
```

### 📞 Em caso de problemas:

#### Para MongoDB Atlas:
1. **Conexão Atlas não funciona:**
   ```bash
   # Testar conexão
   npm run test:atlas
   
   # Reconfigurar se necessário
   npm run config:atlas
   ```

2. **Não encontra database/collection:**
   - Primeiro registre um usuário no Postman
   - Isso criará automaticamente o database `auth_jwt`
   - A collection `users` será criada automaticamente

3. **Não consegue editar no Atlas:**
   - Certifique-se de que está logado na conta correta
   - Verifique se tem permissões no cluster
   - Tente usar MongoDB Compass como alternativa

#### Para MongoDB Local:
1. Verifique se o servidor está rodando
2. Confira se o MongoDB está conectado
3. Verifique se o environment está selecionado
4. Consulte os logs no console do Postman

#### Comandos úteis para diagnóstico:
```bash
# Ver status da conexão
npm run test:atlas

# Iniciar aplicação 
npm start

# Ver logs detalhados
npm run dev
```