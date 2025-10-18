const express = require('express');
// Rate limiting removido para permitir tentativas ilimitadas
const router = express.Router();

const authController = require('../controllers/authController');
const { auth } = require('../middleware/auth');
const {
  registerValidation,
  loginValidation,
  updateProfileValidation,
  changePasswordValidation
} = require('../middleware/validation');

// Rate limiting removido para permitir tentativas ilimitadas de login

// @route   POST /api/auth/register
// @desc    Registrar novo usuário
// @access  Public
router.post('/register', registerValidation, authController.register);

// @route   POST /api/auth/login
// @desc    Fazer login
// @access  Public
router.post('/login', loginValidation, authController.login);

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