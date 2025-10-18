# Sistema de Autenticação com JWT

Uma API REST completa para autenticação de usuários usando JWT (JSON Web Tokens), Node.js, Express e MongoDB.

## 🚀 Funcionalidades

- ✅ Registro de usuários com validação
- ✅ Login/Logout com JWT
- ✅ Autenticação e autorização
- ✅ Criptografia de senhas com bcrypt
- ✅ Validação de dados de entrada
- ✅ Rate limiting para segurança
- ✅ Middleware de tratamento de erros
- ✅ Rotas protegidas
- ✅ Sistema de roles (user/admin)
- ✅ Docker para MongoDB
- ✅ Configurações de segurança (helmet, CORS)

## 🛠 Tecnologias Utilizadas

- **Node.js** - Runtime JavaScript
- **Express.js** - Framework web
- **MongoDB** - Banco de dados NoSQL
- **Mongoose** - ODM para MongoDB
- **JWT** - Tokens de autenticação
- **bcrypt** - Criptografia de senhas
- **Docker** - Containerização do banco
- **express-validator** - Validação de dados
- **helmet** - Segurança HTTP
- **cors** - Cross-Origin Resource Sharing
- **express-rate-limit** - Rate limiting

## 📋 Pré-requisitos

- Node.js (versão 14 ou superior)
- Docker e Docker Compose
- npm ou yarn

## 🔧 Instalação

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd autenticacao_com_JWT
   ```

2. **Instale as dependências**
   ```bash
   npm install
   ```

3. **Configure as variáveis de ambiente**
   ```bash
   cp .env.example .env
   ```
   Edite o arquivo `.env` com suas configurações.

4. **Suba o banco de dados MongoDB com Docker**
   ```bash
   npm run docker:up
   ```

5. **Inicie o servidor**
   ```bash
   # Modo desenvolvimento (com hot reload)
   npm run dev
   
   # Modo produção
   npm start
   ```

## 📚 API Endpoints

### Autenticação

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| POST | `/api/auth/register` | Registrar usuário | ❌ |
| POST | `/api/auth/login` | Fazer login | ❌ |
| GET | `/api/auth/profile` | Obter perfil | ✅ |
| PUT | `/api/auth/profile` | Atualizar perfil | ✅ |
| PUT | `/api/auth/change-password` | Alterar senha | ✅ |

### Rotas Protegidas

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/api/protected/dashboard` | Dashboard do usuário | ✅ |
| GET | `/api/protected/admin` | Área administrativa | ✅ Admin |
| GET | `/api/protected/users` | Listar usuários | ✅ Admin |

### Utilidades

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check |
| GET | `/api` | Informações da API |

## 📖 Exemplos de Uso

### Registrar Usuário
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

### Fazer Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

### Acessar Rota Protegida
```bash
curl -X GET http://localhost:3000/api/protected/dashboard \
  -H "Authorization: Bearer SEU_JWT_TOKEN"
```

## 🔐 Segurança

### Validações Implementadas

- **Senha forte**: Mínimo 6 caracteres, deve conter letra maiúscula, minúscula e número
- **Email único**: Verificação de duplicidade
- **Rate limiting**: Proteção contra ataques de força bruta
- **Helmet**: Headers de segurança HTTP
- **CORS**: Configuração adequada para produção
- **Validação de entrada**: Sanitização e validação de todos os dados

### Configurações de Segurança

- Tokens JWT com expiração configurável
- Hash de senhas com bcrypt (12 rounds por padrão)
- Middleware de autenticação robusto
- Tratamento adequado de erros sem exposição de dados sensíveis

## 🐳 Docker

### Comandos Úteis

```bash
# Subir o banco de dados
npm run docker:up

# Parar o banco de dados
npm run docker:down

# Ver logs do MongoDB
docker logs auth_jwt_mongodb

# Acessar o MongoDB diretamente
docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
```

## 📁 Estrutura do Projeto

```
src/
├── config/
│   └── database.js          # Configuração do MongoDB
├── controllers/
│   └── authController.js    # Controladores de autenticação
├── middleware/
│   ├── auth.js             # Middleware de autenticação
│   ├── errorHandler.js     # Tratamento de erros
│   └── validation.js       # Validações
├── models/
│   └── User.js             # Modelo do usuário
├── routes/
│   ├── auth.js             # Rotas de autenticação
│   └── protected.js        # Rotas protegidas
└── app.js                  # Arquivo principal
```

## 🔧 Scripts NPM

```bash
npm start          # Iniciar servidor
npm run dev        # Modo desenvolvimento
npm run docker:up  # Subir MongoDB
npm run docker:down # Parar MongoDB
```

## ⚠️ Considerações de Produção

1. **Altere o JWT_SECRET** para um valor seguro e aleatório
2. **Configure CORS** adequadamente para seu domínio
3. **Use HTTPS** em produção
4. **Configure logs** adequados
5. **Implemente backup** do banco de dados
6. **Configure monitoramento** da aplicação
7. **Use variáveis de ambiente** para configurações sensíveis

## 📝 Licença

Este projeto está sob a licença MIT.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se livre para abrir issues e pull requests.