const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI);
    
    console.log(`MongoDB conectado: ${conn.connection.host}`);
    
    // Event listeners para conexão
    mongoose.connection.on('error', (err) => {
      console.error('Erro na conexão MongoDB:', err);
    });
    
    mongoose.connection.on('disconnected', () => {
      console.log('MongoDB desconectado');
    });
    
    // Graceful shutdown
    process.on('SIGINT', async () => {
      try {
        await mongoose.connection.close();
        console.log('Conexão MongoDB fechada através do app termination');
        process.exit(0);
      } catch (err) {
        console.error('Erro ao fechar conexão MongoDB:', err);
        process.exit(1);
      }
    });
    
  } catch (error) {
    console.error('⚠️  AVISO: Não foi possível conectar ao MongoDB:', error.message);
    console.log('💡 Para usar as funcionalidades completas:');
    console.log('   1. Inicie o Docker Desktop');
    console.log('   2. Execute: npm run docker:up');
    console.log('   3. Reinicie a aplicação');
    console.log('');
    console.log('🌐 A API continuará rodando, mas endpoints que dependem do banco não funcionarão.');
  }
};

module.exports = connectDB;