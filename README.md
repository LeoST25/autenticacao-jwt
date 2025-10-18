# 🔐 Sistema de Autenticação JWT

Uma API REST completa para autenticação de usuários usando JWT (JSON Web Tokens), desenvolvida com Node.js, Express, MongoDB e Docker.

## 🚀 Demonstração

![API em funcionamento](https://img.shields.io/badge/Status-Funcional-brightgreen)
![Node.js](https://img.shields.io/badge/Node.js-18+-green)
![MongoDB](https://img.shields.io/badge/MongoDB-6.0+-green)
![JWT](https://img.shields.io/badge/JWT-Autenticação-blue)

## ✨ Funcionalidades

- ✅ **Registro de usuários** com validação robusta
- ✅ **Login/Logout** com tokens JWT seguros
- ✅ **Autenticação e autorização** por roles
- ✅ **Criptografia de senhas** com bcrypt
- ✅ **Validação de dados** com express-validator
- ✅ **Rate limiting** para proteção contra ataques
- ✅ **Middleware de tratamento de erros** personalizado
- ✅ **Rotas protegidas** com diferentes níveis de acesso
- ✅ **Sistema de roles** (user/admin)
- ✅ **Docker** para MongoDB
- ✅ **Configurações de segurança** (helmet, CORS)

## 🛠 Tecnologias Utilizadas

| Backend | Banco de Dados | Segurança | DevOps |
|---------|---------------|-----------|--------|
| Node.js | MongoDB | JWT | Docker |
| Express.js | Mongoose | bcrypt | Docker Compose |
| JavaScript | - | Helmet | Nodemon |
| - | - | CORS | - |

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Node.js](https://nodejs.org/) (versão 14 ou superior)
- [Docker](https://www.docker.com/) e Docker Compose
- [Git](https://git-scm.com/)
- [Postman](https://www.postman.com/) (opcional, para testes)

## 🚀 Instalação e Configuração

### 1. Clone o repositório

```bash
git clone https://github.com/LeoST25/autenticacao-jwt.git
cd autenticacao-jwt
```

### 2. Instale as dependências

```bash
npm install
```

### 3. Configure as variáveis de ambiente

```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Edite as variáveis conforme necessário
# IMPORTANTE: Altere o JWT_SECRET para produção!
```

### 4. Inicie o MongoDB com Docker

```bash
npm run docker:up
```

### 5. Execute a aplicação

```bash
# Modo desenvolvimento (com hot reload)
npm run dev

# Modo produção
npm start
```

## 📚 Documentação da API

### 🌐 Endpoints Públicos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Status do servidor |
| GET | `/api` | Informações da API |
| POST | `/api/auth/register` | Registrar usuário |
| POST | `/api/auth/login` | Fazer login |

### 🔒 Endpoints Protegidos

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/api/auth/profile` | Obter perfil | Token |
| PUT | `/api/auth/profile` | Atualizar perfil | Token |
| PUT | `/api/auth/change-password` | Alterar senha | Token |
| GET | `/api/protected/dashboard` | Dashboard do usuário | Token |
| GET | `/api/protected/admin` | Área administrativa | Admin |
| GET | `/api/protected/users` | Listar usuários | Admin |

### 📖 Exemplos de Uso

#### Registrar Usuário
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

#### Fazer Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@exemplo.com",
    "password": "MinhaSenh@123"
  }'
```

#### Acessar Rota Protegida
```bash
curl -X GET http://localhost:3000/api/protected/dashboard \
  -H "Authorization: Bearer SEU_JWT_TOKEN"
```

## 🧪 Testes com Postman

Este projeto inclui uma **collection completa do Postman** para facilitar os testes:

### Importar Collection

1. Abra o Postman
2. Clique em **"Import"**
3. Selecione o arquivo: `JWT-Authentication-API.postman_collection.json`
4. Configure o environment: `base_url = http://localhost:3000`

### Guias Incluídos

- 📖 **`POSTMAN-GUIA.md`** - Documentação completa do Postman
- 🚀 **`POSTMAN-IMPORTAR.md`** - Instruções de importação
- 🧪 **`TESTE.md`** - Guia de testes manuais

## 🏗 Estrutura do Projeto

```
src/
├── config/
│   └── database.js          # Configuração do MongoDB
├── controllers/
│   └── authController.js    # Lógica de autenticação
├── middleware/
│   ├── auth.js             # Middleware JWT
│   ├── errorHandler.js     # Tratamento de erros
│   └── validation.js       # Validações
├── models/
│   └── User.js             # Modelo do usuário
├── routes/
│   ├── auth.js             # Rotas de autenticação
│   └── protected.js        # Rotas protegidas
└── app.js                  # Servidor principal

# Arquivos de configuração
├── docker-compose.yml      # Docker do MongoDB
├── mongo-init.js          # Inicialização do banco
├── .env.example           # Exemplo de variáveis
├── package.json           # Dependências
└── README.md             # Este arquivo
```

## 🔐 Segurança

### Recursos Implementados

- **🔑 JWT Tokens** com expiração configurável
- **🔒 bcrypt** para hash de senhas (12 rounds)
- **⚡ Rate Limiting** (5 login attempts / 15min)
- **🛡️ Helmet** para headers de segurança
- **🌐 CORS** configurado adequadamente
- **✅ Validação rigorosa** de dados de entrada
- **🚫 Sanitização** para prevenir injeções
- **👥 Sistema de roles** (user/admin)

### Configurações de Produção

Para usar em produção, altere:

```env
# .env
JWT_SECRET=seu_jwt_secret_super_complexo_aqui_512_bits
NODE_ENV=production
MONGODB_URI=sua_string_de_conexao_producao
```

## 🐳 Docker

### Comandos Úteis

```bash
# Subir MongoDB
npm run docker:up

# Parar MongoDB  
npm run docker:down

# Ver logs
docker logs auth_jwt_mongodb

# Acessar MongoDB
docker exec -it auth_jwt_mongodb mongosh -u admin -p admin123
```

### Configuração Personalizada

O arquivo `docker-compose.yml` pode ser customizado conforme suas necessidades:

- Porta do MongoDB
- Credenciais de acesso
- Volume de dados
- Configurações de rede

## 🚀 Deploy

### Opções de Deploy

1. **Heroku** - Para aplicações Node.js
2. **Vercel** - Para APIs serverless
3. **DigitalOcean** - VPS completo
4. **AWS EC2** - Cloud escalável
5. **Railway** - Deploy simplificado

### Checklist de Produção

- [ ] Alterar `JWT_SECRET` para valor seguro
- [ ] Configurar `MONGODB_URI` para produção
- [ ] Ajustar `CORS` para domínios específicos
- [ ] Configurar `NODE_ENV=production`
- [ ] Implementar logs estruturados
- [ ] Configurar monitoramento
- [ ] Backup automático do banco

## 🤝 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### Padrões do Projeto

- Use **Conventional Commits**
- Mantenha **cobertura de testes**
- Documente **novas funcionalidades**
- Siga os **padrões ESLint**

## 📝 Scripts Disponíveis

```bash
# Desenvolvimento
npm run dev          # Inicia com nodemon
npm start           # Inicia em produção

# Docker
npm run docker:up   # Sobe MongoDB
npm run docker:down # Para MongoDB

# Testes (futuro)
npm test           # Executa testes
npm run test:watch # Testes em watch mode
```

## 🐛 Troubleshooting

### Problemas Comuns

#### MongoDB não conecta
```bash
# Verificar se Docker está rodando
docker ps

# Reiniciar containers
npm run docker:down && npm run docker:up
```

#### Erro de porta em uso
```bash
# Encontrar processo na porta 3000
netstat -ano | findstr :3000

# Alterar porta no .env
PORT=3001
```

#### Token inválido
- Verificar se o token não expirou (7 dias por padrão)
- Confirmar formato: `Authorization: Bearer <token>`
- Fazer novo login para obter token válido

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Leo ST**
- GitHub: [@LeoST25](https://github.com/LeoST25)
- LinkedIn: [seu-perfil](https://linkedin.com/in/seu-perfil)
- Email: leo.st@exemplo.com

## 🙏 Agradecimentos

- [Express.js](https://expressjs.com/) - Framework web rápido e minimalista
- [MongoDB](https://www.mongodb.com/) - Banco de dados NoSQL
- [JWT.io](https://jwt.io/) - Padrão de tokens JSON
- [Docker](https://www.docker.com/) - Containerização
- [Postman](https://www.postman.com/) - Testes de API

---

⭐ **Se este projeto foi útil, considere dar uma estrela!** ⭐