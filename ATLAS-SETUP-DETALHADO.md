# 🌟 Configuração Detalhada do MongoDB Atlas

## 📋 Passo a Passo Completo

### 1️⃣ **Verificar/Criar Usuário no Atlas**

1. Acesse [MongoDB Atlas](https://cloud.mongodb.com/)
2. Faça login na sua conta
3. Selecione seu cluster
4. Vá em **Database Access** (no menu lateral esquerdo)
5. Clique em **Add New Database User**

**Configurações do usuário:**
- **Authentication Method**: Password
- **Username**: `jwt_user` (ou outro nome de sua escolha)
- **Password**: Gere uma senha segura (ANOTE esta senha!)
- **Database User Privileges**: 
  - Selecione "Built-in Role"
  - Escolha "Read and write to any database"

### 2️⃣ **Configurar Network Access (IP Whitelist)**

1. Vá em **Network Access** (no menu lateral)
2. Clique em **Add IP Address**
3. Para desenvolvimento, você pode:
   - **Opção A**: Clicar em "Add Current IP Address" 
   - **Opção B**: Usar `0.0.0.0/0` para permitir qualquer IP (menos seguro, só para desenvolvimento)

### 3️⃣ **Obter a String de Conexão Correta**

1. Vá em **Clusters** (ou **Database**)
2. Clique em **Connect** no seu cluster
3. Selecione **Connect your application**
4. Escolha **Driver**: Node.js e **Version**: 4.1 or later
5. Copie a string de conexão que aparece

**Formato da string:**
```
mongodb+srv://<username>:<password>@<cluster-name>.<random-id>.mongodb.net/<database-name>?retryWrites=true&w=majority
```

### 4️⃣ **Criar/Verificar o Banco de Dados**

1. No Atlas, vá em **Browse Collections**
2. Se não existir, clique em **Create Database**
3. Nome sugerido: `auth_jwt`
4. Collection inicial: `users`

## 🔧 Configuração no Projeto

### Atualizar o arquivo .env

Sua string deve ficar assim:
```env
MONGODB_URI=mongodb+srv://SEU_USUARIO:SUA_SENHA@seu-cluster.xxxxx.mongodb.net/auth_jwt?retryWrites=true&w=majority&appName=Cluster2
```

**Exemplo:**
```env
MONGODB_URI=mongodb+srv://jwt_user:MinhaSenh@123@cluster0.abc123.mongodb.net/auth_jwt?retryWrites=true&w=majority&appName=Cluster2
```

## ⚠️ Problemas Comuns e Soluções

### Erro: "Authentication failed"
- ✅ Verifique se o usuário existe no Atlas
- ✅ Confirme que a senha está correta (sem caracteres especiais problemáticos)
- ✅ Certifique-se que o usuário tem permissões de leitura/escrita

### Erro: "IP not whitelisted"
- ✅ Adicione seu IP atual no Network Access
- ✅ Para desenvolvimento, pode usar 0.0.0.0/0 temporariamente

### Erro: "Server selection timeout"
- ✅ Verifique sua conexão com a internet
- ✅ Confirme se o nome do cluster está correto na string

### Senha com caracteres especiais
Se sua senha tem caracteres especiais como `@`, `%`, etc., você precisa fazer URL encoding:
- `@` → `%40`
- `%` → `%25` 
- `#` → `%23`

## 🧪 Testando a Conexão

Depois de configurar, teste:

```bash
npm start
```

Se aparecer:
```
MongoDB conectado: cluster0-shard-00-02.xxxxx.mongodb.net
```

Está funcionando! ✅

## 📞 Ainda com problemas?

Se persistir o erro, me envie:
1. A mensagem de erro completa
2. Sua string de conexão (SEM a senha)
3. Print da tela do Database Access no Atlas