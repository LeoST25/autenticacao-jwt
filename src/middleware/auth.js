const jwt = require('jsonwebtoken');
const User = require('../models/User');

const auth = async (req, res, next) => {
  try {
    // Verificar se o token está presente no header Authorization
    const authHeader = req.header('Authorization');
    
    if (!authHeader) {
      return res.status(401).json({ 
        success: false, 
        message: 'Acesso negado. Token não fornecido.' 
      });
    }
    
    // Extrair o token (formato: "Bearer <token>")
    const token = authHeader.startsWith('Bearer ') 
      ? authHeader.slice(7) 
      : authHeader;
    
    if (!token) {
      return res.status(401).json({ 
        success: false, 
        message: 'Acesso negado. Token inválido.' 
      });
    }
    
    // Verificar e decodificar o token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Buscar o usuário no banco de dados
    const user = await User.findById(decoded.id).select('-password');
    
    if (!user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Token inválido. Usuário não encontrado.' 
      });
    }
    
    // Verificar se o usuário está ativo
    if (!user.isActive) {
      return res.status(401).json({ 
        success: false, 
        message: 'Conta desativada. Acesso negado.' 
      });
    }
    
    // Adicionar dados do usuário na requisição
    req.user = user;
    next();
    
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ 
        success: false, 
        message: 'Token inválido.' 
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ 
        success: false, 
        message: 'Token expirado.' 
      });
    }
    
    console.error('Erro no middleware de autenticação:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Erro interno do servidor.' 
    });
  }
};

// Middleware para verificar se o usuário é admin
const requireAdmin = async (req, res, next) => {
  try {
    if (req.user.role !== 'admin') {
      return res.status(403).json({ 
        success: false, 
        message: 'Acesso negado. Privilégios de administrador necessários.' 
      });
    }
    next();
  } catch (error) {
    console.error('Erro no middleware requireAdmin:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Erro interno do servidor.' 
    });
  }
};

module.exports = {
  auth,
  requireAdmin
};