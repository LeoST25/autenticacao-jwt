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

## 👑 PASSO 5: Testar Área Admin

### Tornar usuário Admin:
1. **Conecte ao MongoDB:**
```bash
docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
```

2. **Execute no MongoDB:**
```javascript
use auth_jwt
db.users.updateOne(
  {email: "seu.email@exemplo.com"}, 
  {$set: {role: "admin"}}
)
```

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

## 💡 DICAS IMPORTANTES

### ✅ Verificações antes de testar:
- [ ] Servidor rodando (`npm run dev`)
- [ ] MongoDB conectado (deve aparecer no log)
- [ ] Environment selecionado no Postman
- [ ] Collection importada

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

### 📞 Em caso de problemas:
1. Verifique se o servidor está rodando
2. Confira se o MongoDB está conectado
3. Verifique se o environment está selecionado
4. Consulte os logs no console do Postman