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

module.exports = router;