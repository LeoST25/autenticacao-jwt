# 🚀 Cadastro em Massa de Usuários

## 📋 Visão Geral

Esta aplicação inclui ferramentas automatizadas para cadastrar múltiplos usuários de forma rápida e eficiente, ideal para desenvolvimento, testes e demonstrações.

## 🎯 Recursos Incluídos

- ✅ **100 usuários pré-configurados** com dados brasileiros realistas
- ✅ **Senhas seguras** que atendem a todos os critérios de segurança
- ✅ **Script automático** para cadastro em massa
- ✅ **Sem limites de rate limiting** - cadastre quantos usuários precisar
- ✅ **E-mails únicos** no domínio @gmail.com

## 📁 Arquivos Principais

### `usuarios-teste.json`
Contém 100 usuários com:
- **Nomes brasileiros** completos e realistas
- **E-mails únicos** no formato nome.sobrenome@gmail.com
- **Senhas seguras** seguindo padrões de segurança

### `cadastrar-usuarios.ps1`
Script PowerShell que:
- ✅ Verifica se o servidor está rodando
- ✅ Carrega usuários do arquivo JSON
- ✅ Cadastra automaticamente via API
- ✅ Mostra progresso em tempo real
- ✅ Gera relatório de resultados

## 🔐 Padrões de Senhas

Todas as senhas seguem critérios rigorosos de segurança:

### ✅ Critérios Atendidos:
- **Maiúscula**: Primeira letra do nome
- **Minúscula**: Restante do nome
- **Números**: Sequências numéricas (123, 456, etc.)
- **Caracteres especiais**: @, #, $, &, *

### 📝 Exemplos:
```
Ana Silva Santos    → Ana@2024!
Bruno Costa Lima    → Bruno#123
Carla Ferreira      → Carla$456
Daniel Rodrigues    → Daniel&789
Eduarda Oliveira    → Eduarda*012
```

## 🚀 Como Usar

### Método 1: Script Automático (Recomendado)

1. **Inicie o servidor:**
   ```bash
   npm start
   ```

2. **Execute o cadastro em massa:**
   ```bash
   npm run users:create
   ```
   
   **OU diretamente:**
   ```powershell
   .\cadastrar-usuarios.ps1
   ```

3. **Acompanhe o progresso:**
   - Barra de progresso em tempo real
   - Status de cada usuário cadastrado
   - Relatório final com estatísticas

### Método 2: Postman Individual

1. **Abra o arquivo `usuarios-teste.json`**

2. **Copie qualquer usuário:**
   ```json
   {
     "name": "Ana Silva Santos",
     "email": "ana.silva.santos@gmail.com", 
     "password": "Ana@2024!"
   }
   ```

3. **Use no Postman:**
   - **Método:** POST
   - **URL:** `http://localhost:3000/api/auth/register`
   - **Body:** Cole o JSON do usuário

### Método 3: Runner do Postman

1. **Importe a collection da API**
2. **Configure o Runner do Postman**
3. **Use `usuarios-teste.json` como Data File**
4. **Execute em lote**

## 📊 Exemplo de Output do Script

```
========================================
    CADASTRO EM MASSA DE USUÁRIOS
========================================

📋 Encontrados 100 usuários para cadastrar

Deseja continuar? (s/n): s

Iniciando cadastros...

✅ Ana Silva Santos - ana.silva.santos@gmail.com
✅ Bruno Costa Lima - bruno.costa.lima@gmail.com
✅ Carla Ferreira Souza - carla.ferreira.souza@gmail.com
⚠️  Daniel Rodrigues Pereira - daniel.rodrigues.pereira@gmail.com (já existe)
✅ Eduarda Oliveira Martins - eduarda.oliveira.martins@gmail.com

========================================
    RESULTADO DO CADASTRO
========================================
Total de usuários: 100
Sucessos: 97
Erros: 0
Já existentes: 3

🎉 97 usuários cadastrados com sucesso!

PRÓXIMOS PASSOS:
1. Use o Postman para testar login com qualquer usuário
2. Email: qualquer um da lista
3. Senha: Nome@números ou Nome#números (ex: Ana@2024!, Bruno#123)
4. Endpoint: POST http://localhost:3000/api/auth/login
```

## 🔧 Personalização

### Modificar Usuários

Edite o arquivo `usuarios-teste.json` para:
- Alterar nomes e e-mails
- Modificar padrões de senhas
- Adicionar ou remover usuários
- Incluir campos customizados

### Personalizar Script

Modifique `cadastrar-usuarios.ps1` para:
- Alterar endpoints da API
- Mudar intervalos entre requests
- Adicionar validações extras
- Customizar relatórios

## 🎯 Casos de Uso

### 👨‍💻 Desenvolvimento
- Teste de performance com múltiplos usuários
- Validação de funcionalidades de listagem
- Simulação de ambiente com dados reais

### 🧪 Testes
- Teste de carga da API
- Validação de regras de negócio
- Teste de autenticação em massa

### 📊 Demonstrações
- Apresentações com dados realistas
- Demos de funcionalidades
- Showcases de performance

## ⚡ Performance

### Script Otimizado:
- **Pausa entre requests**: 100ms (configurável)
- **Timeout por request**: 10 segundos
- **Tratamento de erros**: Automático
- **Progresso visual**: Barra em tempo real

### Estatísticas Esperadas:
- **100 usuários**: ~15-20 segundos
- **Taxa de sucesso**: >95% (considerando duplicatas)
- **Uso de CPU**: Baixo
- **Uso de rede**: Moderado

## 🛠 Troubleshooting

### Servidor não está rodando
```
❌ ERRO: Servidor não está rodando!
Execute primeiro: npm start
```
**Solução:** Inicie o servidor com `npm start`

### Arquivo não encontrado
```
❌ ERRO: Arquivo usuarios-teste.json não encontrado!
```
**Solução:** Verifique se o arquivo existe no diretório raiz

### Erro de conexão MongoDB
**Solução:** Verifique a string de conexão no arquivo `.env`

### Usuários duplicados
```
⚠️ Ana Silva Santos - ana.silva.santos@gmail.com (já existe)
```
**Resultado:** Normal - usuários já cadastrados são ignorados

## 🔗 Integração com Outros Recursos

### Autenticação JWT
Todos os usuários cadastrados podem:
- Fazer login imediatamente
- Receber tokens JWT válidos
- Acessar rotas protegidas

### Sistema de Roles
Por padrão, todos são criados como `user`. Para criar admins:
```bash
# Conecte no MongoDB e altere role
db.users.updateOne(
  {email: "ana.silva.santos@gmail.com"}, 
  {$set: {role: "admin"}}
)
```

### Dashboard e Relatórios  
Use usuários cadastrados para testar:
- Listagem de usuários (rota admin)
- Métricas de usuários
- Funcionalidades de gerenciamento

---

**💡 Dica:** Este sistema foi projetado para remover completamente rate limiting durante desenvolvimento, permitindo cadastros ilimitados e testes extensivos sem restrições!