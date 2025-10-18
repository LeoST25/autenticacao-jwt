const { body } = require('express-validator');

// Validações para registro
const registerValidation = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Nome é obrigatório')
    .isLength({ min: 2, max: 50 })
    .withMessage('Nome deve ter entre 2 e 50 caracteres')
    .matches(/^[a-zA-ZÀ-ÿ\s]+$/)
    .withMessage('Nome deve conter apenas letras e espaços'),

  body('email')
    .trim()
    .notEmpty()
    .withMessage('Email é obrigatório')
    .isEmail()
    .withMessage('Email inválido')
    .normalizeEmail()
    .isLength({ max: 100 })
    .withMessage('Email não pode ter mais de 100 caracteres'),

  body('password')
    .notEmpty()
    .withMessage('Senha é obrigatória')
    .isLength({ min: 6, max: 128 })
    .withMessage('Senha fraca')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage('Senha deve conter ao menos uma letra minúscula, uma maiúscula e um número')
];

// Validações para login
const loginValidation = [
  body('email')
    .trim()
    .notEmpty()
    .withMessage('Email é obrigatório')
    .isEmail()
    .withMessage('Email inválido')
    .normalizeEmail(),

  body('password')
    .notEmpty()
    .withMessage('Senha é obrigatória')
];

// Validações para atualização de perfil
const updateProfileValidation = [
  body('name')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('Nome não pode estar vazio')
    .isLength({ min: 2, max: 50 })
    .withMessage('Nome deve ter entre 2 e 50 caracteres')
    .matches(/^[a-zA-ZÀ-ÿ\s]+$/)
    .withMessage('Nome deve conter apenas letras e espaços'),

  body('email')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('Email não pode estar vazio')
    .isEmail()
    .withMessage('Email inválido')
    .normalizeEmail()
    .isLength({ max: 100 })
    .withMessage('Email não pode ter mais de 100 caracteres')
];

// Validações para alteração de senha
const changePasswordValidation = [
  body('currentPassword')
    .notEmpty()
    .withMessage('Senha atual é obrigatória'),

  body('newPassword')
    .notEmpty()
    .withMessage('Nova senha é obrigatória')
    .isLength({ min: 6, max: 128 })
    .withMessage('Senha Fraca')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage('Nova senha deve conter ao menos uma letra minúscula, uma maiúscula e um número'),

  body('confirmPassword')
    .notEmpty()
    .withMessage('Confirmação de senha é obrigatória')
    .custom((value, { req }) => {
      if (value !== req.body.newPassword) {
        throw new Error('Confirmação de senha não coincide');
      }
      return true;
    })
];

module.exports = {
  registerValidation,
  loginValidation,
  updateProfileValidation,
  changePasswordValidation
};