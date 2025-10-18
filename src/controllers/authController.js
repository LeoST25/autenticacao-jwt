const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const User = require('../models/User');

// Função para gerar JWT token
const generateToken = (userId) => {
  return jwt.sign(
    { id: userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );
};

// Registro de usuário
const register = async (req, res, next) => {
  try {
    // Verificar erros de validação
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Dados de entrada inválidos',
        errors: errors.array()
      });
    }

    const { name, email, password } = req.body;

    // Verificar se o usuário já existe
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Email já está registrado'
      });
    }

    // Criar novo usuário
    const user = new User({
      name,
      email,
      password
    });

    await user.save();

    // Gerar token
    const token = generateToken(user._id);

    // Remover senha da resposta
    const userResponse = user.toSafeObject();

    res.status(201).json({
      success: true,
      message: 'Usuário registrado com sucesso',
      data: {
        user: userResponse,
        token
      }
    });

  } catch (error) {
    next(error);
  }
};

// Login de usuário
const login = async (req, res, next) => {
  try {
    // Verificar erros de validação
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Dados de entrada inválidos',
        errors: errors.array()
      });
    }

    const { email, password } = req.body;

    // Buscar usuário por email (incluindo a senha)
    const user = await User.findOne({ email }).select('+password');
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Credenciais inválidas'
      });
    }

    // Verificar se a conta está ativa
    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Conta desativada'
      });
    }

    // Verificar a senha
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Credenciais inválidas'
      });
    }

    // Atualizar último login
    await user.updateLastLogin();

    // Gerar token
    const token = generateToken(user._id);

    // Remover senha da resposta
    const userResponse = user.toSafeObject();

    res.status(200).json({
      success: true,
      message: 'Login realizado com sucesso',
      data: {
        user: userResponse,
        token
      }
    });

  } catch (error) {
    next(error);
  }
};

// Obter perfil do usuário logado
const getProfile = async (req, res, next) => {
  try {
    const user = req.user.toSafeObject();
    
    res.status(200).json({
      success: true,
      message: 'Perfil obtido com sucesso',
      data: {
        user
      }
    });

  } catch (error) {
    next(error);
  }
};

// Atualizar perfil do usuário
const updateProfile = async (req, res, next) => {
  try {
    // Verificar erros de validação
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Dados de entrada inválidos',
        errors: errors.array()
      });
    }

    const { name, email } = req.body;
    const userId = req.user._id;

    // Verificar se o email já está em uso por outro usuário
    if (email && email !== req.user.email) {
      const existingUser = await User.findOne({ email, _id: { $ne: userId } });
      if (existingUser) {
        return res.status(400).json({
          success: false,
          message: 'Email já está em uso'
        });
      }
    }

    // Atualizar usuário
    const updatedUser = await User.findByIdAndUpdate(
      userId,
      {
        ...(name && { name }),
        ...(email && { email }),
        updatedAt: Date.now()
      },
      { 
        new: true,
        runValidators: true
      }
    );

    const userResponse = updatedUser.toSafeObject();

    res.status(200).json({
      success: true,
      message: 'Perfil atualizado com sucesso',
      data: {
        user: userResponse
      }
    });

  } catch (error) {
    next(error);
  }
};

// Alterar senha
const changePassword = async (req, res, next) => {
  try {
    // Verificar erros de validação
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Dados de entrada inválidos',
        errors: errors.array()
      });
    }

    const { currentPassword, newPassword } = req.body;
    const userId = req.user._id;

    // Buscar usuário com senha
    const user = await User.findById(userId).select('+password');

    // Verificar senha atual
    const isCurrentPasswordValid = await user.comparePassword(currentPassword);
    if (!isCurrentPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Senha atual incorreta'
      });
    }

    // Atualizar senha
    user.password = newPassword;
    await user.save();

    res.status(200).json({
      success: true,
      message: 'Senha alterada com sucesso'
    });

  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  getProfile,
  updateProfile,
  changePassword
};