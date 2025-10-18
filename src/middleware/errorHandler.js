const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  console.error('Error:', err);

  // Erro de validação do Mongoose
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors).map(val => val.message);
    return res.status(400).json({
      success: false,
      message: 'Dados inválidos',
      errors: message
    });
  }

  // Erro de duplicação (código 11000 do MongoDB)
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue)[0];
    const value = err.keyValue[field];
    return res.status(400).json({
      success: false,
      message: `${field === 'email' ? 'Email' : field} '${value}' já está em uso`
    });
  }

  // Erro de CastError do Mongoose (ID inválido)
  if (err.name === 'CastError') {
    return res.status(400).json({
      success: false,
      message: 'ID inválido'
    });
  }

  // Erro padrão
  res.status(error.statusCode || 500).json({
    success: false,
    message: error.message || 'Erro interno do servidor'
  });
};

module.exports = errorHandler;