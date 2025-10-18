require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
// Rate limiting removido para permitir cadastros ilimitados

// Importar configuração do banco
const connectDB = require('./config/database');

// Importar middlewares
const errorHandler = require('./middleware/errorHandler');

// Importar rotas
const authRoutes = require('./routes/auth');
const protectedRoutes = require('./routes/protected');

// Conectar ao banco de dados
connectDB();

const app = express();

// Configurações de segurança
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
}));

// Rate limiting removido para permitir requisições ilimitadas

// Configuração do CORS
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? ['https://seudominio.com'] // Substitua pelo seu domínio em produção
    : ['http://localhost:3000', 'http://localhost:3001', 'http://127.0.0.1:3000'],
  credentials: true,
  optionsSuccessStatus: 200
}));

// Middleware para parsing de JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Middleware para logging (simples)
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path} - IP: ${req.ip}`);
  next();
});

// Rota de health check
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Servidor funcionando normalmente',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Rota de informações da API
app.get('/api', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'API de Autenticação com JWT',
    version: '1.0.0',
    endpoints: {
      auth: {
        register: 'POST /api/auth/register',
        login: 'POST /api/auth/login',
        profile: 'GET /api/auth/profile',
        updateProfile: 'PUT /api/auth/profile',
        changePassword: 'PUT /api/auth/change-password'
      },
      protected: {
        dashboard: 'GET /api/protected/dashboard',
        admin: 'GET /api/protected/admin',
        users: 'GET /api/protected/users'
      }
    }
  });
});

// Rotas da API
app.use('/api/auth', authRoutes);
app.use('/api/protected', protectedRoutes);

// Middleware para rotas não encontradas
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Rota não encontrada'
  });
});

// Middleware de tratamento de erros (deve ser o último)
app.use(errorHandler);

// Configuração da porta
const PORT = process.env.PORT || 3000;

// Iniciar servidor
const server = app.listen(PORT, () => {
  console.log(`
🚀 Servidor iniciado com sucesso!
📍 Porta: ${PORT}
🌍 Ambiente: ${process.env.NODE_ENV || 'development'}
📚 Documentação: http://localhost:${PORT}/api
🏥 Health Check: http://localhost:${PORT}/health
  `);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});

module.exports = app;