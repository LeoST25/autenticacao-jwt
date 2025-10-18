# 🔧 Templates de Configuração

Este diretório contém templates (exemplos) dos scripts de configuração que você pode personalizar para seu ambiente.

## 📋 Lista de Templates

### 1. `configurar-atlas.ps1.example`
**Template completo para configuração do MongoDB Atlas**
- Interface interativa amigável
- Validação de entrada
- Backup automático do .env existente
- Geração da string de conexão completa

**Como usar:**
1. Copie para `configurar-atlas.ps1`
2. Edite as variáveis no topo do arquivo:
   - `$clusterName` - Nome do seu cluster Atlas
   - `$clusterId` - ID do seu cluster Atlas
3. Execute: `.\configurar-atlas.ps1`

### 2. `config-atlas-simples.ps1.example`
**Template simplificado para configuração rápida**
- Versão minimalista
- Apenas pede usuário e senha
- Salva diretamente no .env

**Como usar:**
1. Copie para `config-atlas-simples.ps1`
2. Edite as variáveis:
   - `$CLUSTER_NAME` - Nome do seu cluster
   - `$CLUSTER_ID` - ID do seu cluster
3. Execute: `.\config-atlas-simples.ps1`

### 3. `demo-usuario.ps1.example`
**Template para demonstração da API**
- Testa registro, login e acesso protegido
- Útil para verificar se a API está funcionando

**Como usar:**
1. Copie para `demo-usuario.ps1`
2. Customize a `$baseUrl` se necessário
3. Customize os dados de teste do usuário
4. Execute: `.\demo-usuario.ps1`

### 4. `teste-completo.ps1.example`
**Template para testes abrangentes da API**
- Testa todos os endpoints principais
- Inclui testes de admin
- Relatório de resultados

**Como usar:**
1. Copie para `teste-completo.ps1`
2. Customize os parâmetros padrão se necessário
3. Execute: `.\teste-completo.ps1`

## 🔐 Informações Necessárias do Atlas

Para usar os templates, você precisa das seguintes informações do seu MongoDB Atlas:

### Como obter as informações:

1. **Acesse** [MongoDB Atlas](https://cloud.mongodb.com/)
2. **Vá para** Database → Connect → Connect your application
3. **Encontre** a string de conexão que tem o formato:
   ```
   mongodb+srv://username:password@CLUSTER_NAME.CLUSTER_ID.mongodb.net/database
   ```

### Exemplos:
- **CLUSTER_NAME**: `cluster0`, `cluster2`, `mycluster`
- **CLUSTER_ID**: `bdhtrjl`, `xyz123`, `abc456`

## 🚨 Importante

- ❌ **NUNCA** commite os arquivos reais (sem .example)
- ✅ **SEMPRE** mantenha suas credenciais privadas
- 📁 Os arquivos sem `.example` estão no `.gitignore`
- 🔄 Você pode atualizar os templates conforme necessário

## 🎯 Fluxo Recomendado

1. **Primeira vez:**
   ```powershell
   cp configurar-atlas.ps1.example configurar-atlas.ps1
   # Edite o arquivo com suas informações
   .\configurar-atlas.ps1
   ```

2. **Para testes:**
   ```powershell
   cp demo-usuario.ps1.example demo-usuario.ps1
   .\demo-usuario.ps1
   ```

3. **Para desenvolvimento:**
   ```powershell
   cp teste-completo.ps1.example teste-completo.ps1
   .\teste-completo.ps1
   ```

## 💡 Dicas

- Use o `configurar-atlas.ps1` na primeira configuração
- Use o `config-atlas-simples.ps1` para mudanças rápidas
- Use os scripts de teste para validar mudanças na API
- Mantenha sempre um backup do seu `.env` antes das mudanças