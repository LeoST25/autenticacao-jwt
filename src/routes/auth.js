const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();

const authController = require('../controllers/authController');
const { auth } = require('../middleware/auth');
const {
  registerValidation,
  loginValidation,
  updateProfileValidation,
  changePasswordValidation
} = require('../middleware/validation');

// Rate limiting para endpoints de autenticação
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // máximo 5 tentativas por IP
  message: {
    success: false,
    message: 'Muitas tentativas de login. Tente novamente em 15 minutos.'
  },
  standardHeaders: true,
  legacyHeaders: false
});

const registerLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hora
  max: 3, // máximo 3 registros por IP
  message: {
    success: false,
    message: 'Muitas tentativas de registro. Tente novamente em 1 hora.'
  },
  standardHeaders: true,
  legacyHeaders: false
});

// @route   POST /api/auth/register
// @desc    Registrar novo usuário
// @access  Public
router.post('/register', registerLimiter, registerValidation, authController.register);

// @route   POST /api/auth/login
// @desc    Fazer login
// @access  Public
router.post('/login', authLimiter, loginValidation, authController.login);

// @route   GET /api/auth/profile
// @desc    Obter perfil do usuário logado
// @access  Private
router.get('/profile', auth, authController.getProfile);

// @route   PUT /api/auth/profile
// @desc    Atualizar perfil do usuário
// @access  Private
router.put('/profile', auth, updateProfileValidation, authController.updateProfile);

// @route   PUT /api/auth/change-password
// @desc    Alterar senha do usuário
// @access  Private
router.put('/change-password', auth, changePasswordValidation, authController.changePassword);

module.exports = router;