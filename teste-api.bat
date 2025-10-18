@echo off
echo Testando a API de Autenticação...
echo.

echo 1. Testando Health Check...
powershell -Command "(Invoke-WebRequest -Uri 'http://localhost:3000/health' -Method GET).Content"
echo.

echo 2. Testando informações da API...
powershell -Command "(Invoke-WebRequest -Uri 'http://localhost:3000/api' -Method GET).Content"
echo.

echo Teste completo! Para usar todas as funcionalidades:
echo 1. Inicie o Docker Desktop
echo 2. Execute: npm run docker:up
echo 3. Reinicie a aplicação
echo 4. Use o arquivo TESTE.md para mais exemplos

pause