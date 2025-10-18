// Inicialização do banco de dados MongoDB
db = db.getSiblingDB('auth_jwt');

// Criar usuário para a aplicação
db.createUser({
  user: 'app_user',
  pwd: 'app_password',
  roles: [
    {
      role: 'readWrite',
      db: 'auth_jwt'
    }
  ]
});

// Criar coleção de usuários com índice único no email
db.createCollection('users');
db.users.createIndex({ email: 1 }, { unique: true });

console.log('Banco de dados auth_jwt inicializado com sucesso!');