const express = require('express');
const router = express.Router();

const { auth, requireAdmin } = require('../middleware/auth');

// @route   GET /api/protected/dashboard
// @desc    Rota protegida básica - qualquer usuário autenticado
// @access  Private
router.get('/dashboard', auth, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Acesso autorizado ao dashboard',
    data: {
      user: req.user.toSafeObject(),
      timestamp: new Date().toISOString(),
      message: 'Bem-vindo à área protegida!'
    }
  });
});

// @route   GET /api/protected/admin
// @desc    Rota protegida para administradores
// @access  Private (Admin only)
router.get('/admin', auth, requireAdmin, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Acesso autorizado à área administrativa',
    data: {
      user: req.user.toSafeObject(),
      timestamp: new Date().toISOString(),
      message: 'Bem-vindo à área administrativa!'
    }
  });
});

// @route   GET /api/protected/users
// @desc    Listar todos os usuários (somente admin)
// @access  Private (Admin only)
router.get('/users', auth, requireAdmin, async (req, res, next) => {
  try {
    const User = require('../models/User');
    
    const users = await User.find({ isActive: true })
      .select('-password')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      message: 'Usuários obtidos com sucesso',
      data: {
        users,
        count: users.length
      }
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/protected/users/:userId/role
// @desc    Alterar role de um usuário (somente admin)
// @access  Private (Admin only)
router.put('/users/:userId/role', auth, requireAdmin, async (req, res, next) => {
  try {
    const User = require('../models/User');
    const { role } = req.body;
    const { userId } = req.params;

    // Validar role
    if (!['user', 'admin'].includes(role)) {
      return res.status(400).json({
        success: false,
        message: 'Role deve ser "user" ou "admin"'
      });
    }

    // Não permitir que admin altere seu próprio role
    if (userId === req.user._id.toString()) {
      return res.status(400).json({
        success: false,
        message: 'Você não pode alterar seu próprio role'
      });
    }

    // Encontrar e atualizar usuário
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Usuário não encontrado'
      });
    }

    const oldRole = user.role;
    user.role = role;
    await user.save();

    res.status(200).json({
      success: true,
      message: `Role do usuário alterado de "${oldRole}" para "${role}"`,
      data: {
        user: user.toSafeObject(),
        changed_by: req.user.toSafeObject(),
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    next(error);
  }
});

// @route   POST /api/protected/make-admin
// @desc    Rota especial para tornar o primeiro usuário admin (apenas para desenvolvimento)
// @access  Private
router.post('/make-admin', auth, async (req, res, next) => {
  try {
    const User = require('../models/User');
    
    // Verificar se já existe algum admin
    const existingAdmin = await User.findOne({ role: 'admin' });
    
    if (existingAdmin) {
      return res.status(400).json({
        success: false,
        message: 'Já existe um administrador no sistema. Use a rota /users/:userId/role para alterar roles.'
      });
    }

    // Tornar o usuário atual admin (útil para o primeiro setup)
    const currentUser = await User.findById(req.user._id);
    currentUser.role = 'admin';
    await currentUser.save();

    res.status(200).json({
      success: true,
      message: 'Usuário promovido a administrador com sucesso!',
      data: {
        user: currentUser.toSafeObject(),
        timestamp: new Date().toISOString(),
        note: 'Esta rota funcionou porque não havia nenhum admin no sistema'
      }
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;