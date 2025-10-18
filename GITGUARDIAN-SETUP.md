# 🔒 GitGuardian Setup Guide

## 📋 Visão Geral

Este projeto está configurado com GitGuardian para detectar automaticamente segredos (senhas, chaves API, tokens) no código e prevenir vazamentos de segurança.

## 🚀 Configuração Rápida

### 1. Criar Conta GitGuardian (Gratuita)

1. Acesse: https://gitguardian.com/
2. Clique em **"Start for Free"**
3. Crie sua conta (GitHub login recomendado)
4. Confirme o email

### 2. Obter API Key

1. Acesse: https://dashboard.gitguardian.com/settings/api-tokens
2. Clique em **"Create Token"**
3. Nome: `JWT Authentication Project`
4. Copie o token (guarde com segurança)

### 3. Configurar no GitHub (Actions)

1. Vá para seu repositório no GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Clique em **"New repository secret"**
4. Nome: `GITGUARDIAN_API_KEY`
5. Value: Cole seu token GitGuardian
6. Clique em **"Add secret"**

### 4. Configurar Localmente (Opcional)

#### Windows PowerShell:
```powershell
# Definir variável de ambiente (sessão atual)
$env:GITGUARDIAN_API_KEY = "seu_token_aqui"

# Definir permanentemente
[Environment]::SetEnvironmentVariable("GITGUARDIAN_API_KEY", "seu_token_aqui", "User")
```

#### Linux/Mac:
```bash
# Adicionar ao ~/.bashrc ou ~/.zshrc
export GITGUARDIAN_API_KEY="seu_token_aqui"

# Aplicar imediatamente
source ~/.bashrc
```

## 🛠 Instalação Local (Opcional)

### Instalar ggshield CLI:

```bash
# Usando pip
pip install ggshield

# Usando npm
npm install -g @gitguardian/ggshield

# Verificar instalação
ggshield --version
```

### Configurar Pre-commit Hook:

```powershell
# Executar script de configuração
.\scripts\pre-commit-gitguardian.ps1
```

## 🔍 Como Funciona

### GitHub Actions (Automático)
- ✅ **Push para main/develop**: Scan automático
- ✅ **Pull Requests**: Scan de diferenças  
- ✅ **Schedule**: Scan completo semanal
- ✅ **Notificações**: Via GitHub e email

### Pre-commit Local (Opcional)
- 🔍 Scan antes de cada commit
- ❌ Bloqueia commits com segredos
- 🚨 Alertas em tempo real

### Monitoramento Contínuo
- 📊 Dashboard GitGuardian
- 📧 Alertas por email
- 🔔 Notificações no GitHub

## 📁 Arquivos de Configuração

### `.gitguardian.yml`
Configurações principais:
- Arquivos ignorados
- Falsos positivos
- Tipos de segredos

### `.github/workflows/gitguardian.yml`  
GitHub Action para:
- Scan automático em pushes
- Verificação de PRs
- Scan semanal completo

## 🎯 O que é Detectado

### ✅ Tipos de Segredos:
- 🔑 **API Keys** (AWS, Google, etc.)
- 🎫 **Tokens** (GitHub, JWT real, etc.)
- 🔐 **Senhas** em código
- 🔒 **Chaves privadas** (SSH, SSL)
- 💳 **Credenciais** de banco
- 🌐 **URLs** com credenciais

### ❌ Ignorados (Configurado):
- 📝 Senhas de exemplo (`.env.example`)
- 🔧 Configurações locais
- 📚 Documentação
- 🗂️ node_modules/

## 🔧 Comandos Úteis

### Scan Manual:
```bash
# Scan do repositório completo
ggshield secret scan repo .

# Scan de arquivos específicos  
ggshield secret scan path arquivo.js

# Scan do último commit
ggshield secret scan commit-range HEAD~1..HEAD
```

### Pre-commit Manual:
```bash
# Executar script PowerShell
.\scripts\pre-commit-gitguardian.ps1

# Scan dos arquivos staged
ggshield secret scan pre-commit
```

## 🚨 Em Caso de Detecção

### 1. **Remover Segredo**
```bash
# Remover do arquivo
# Editar e remover a linha com segredo
```

### 2. **Usar Variável de Ambiente**
```javascript
// ❌ Errado
const apiKey = "abc123secretkey";

// ✅ Correto
const apiKey = process.env.API_KEY;
```

### 3. **Adicionar ao .gitignore**
```bash
# Adicionar arquivo com segredos
echo "config/secrets.json" >> .gitignore
```

### 4. **Configurar Exceção**
Editar `.gitguardian.yml`:
```yaml
matches-ignore:
  - match: "sua_string_aqui"
    name: "Falso Positivo"
    comment: "Explicação do porquê é seguro"
```

## 📊 Dashboard GitGuardian

Acesse: https://dashboard.gitguardian.com/

### Recursos Disponíveis:
- 📈 **Métricas** de segurança
- 🔍 **Histórico** de scans
- ⚠️ **Alertas** ativos
- 👥 **Gestão** de equipe
- 📋 **Relatórios** detalhados

## 🎯 Benefícios

### 🔒 Segurança:
- Prevenção de vazamentos
- Detecção automática
- Monitoramento contínuo

### 🚀 Produtividade:
- Integração sem fricção
- Alertas em tempo real
- Dashboard centralizado

### ⚡ Performance:
- Scan rápido (< 30s)
- Baixo overhead
- Cache inteligente

## 🆘 Troubleshooting

### Erro: "API Key inválida"
```
🔧 Solução: Verificar se GITGUARDIAN_API_KEY está correta
```

### Falso Positivo
```
🔧 Solução: Adicionar exceção no .gitguardian.yml
```

### Scan muito lento
```
🔧 Solução: Adicionar mais pastas ao paths-ignore
```

### Actions não executando
```
🔧 Solução: Verificar secret GITGUARDIAN_API_KEY no GitHub
```

## 🔗 Links Úteis

- 📖 **Documentação**: https://docs.gitguardian.com/
- 🎯 **Dashboard**: https://dashboard.gitguardian.com/
- 🛠️ **CLI Docs**: https://docs.gitguardian.com/ggshield-docs/
- 💬 **Suporte**: https://gitguardian.com/support
- 🐙 **GitHub Action**: https://github.com/GitGuardian/ggshield

---

**⚡ Dica:** GitGuardian é gratuito para projetos públicos e oferece um plano generoso para uso pessoal!