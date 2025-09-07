# 📁 UPack - Estrutura Atual (Backup)

## 📅 Documentado em: 7 de Setembro, 2025
### 🎯 Estado antes da reestruturação

---

## 🗂️ **ARQUIVOS NA RAIZ**

### Scripts Principais:
- `dev.sh` (7.9k) - Script de desenvolvimento ❌ **REMOVER**
- `install.sh` (5.0k) - Script redundante ❌ **REMOVER**  
- `setup.sh` (11k) - Script atual com menu ↻ **REESCREVER**
- `start.sh` (1.1k) - Script que confunde ❌ **REMOVER**

### Outros:
- `README.md` - Documentação principal ↻ **ATUALIZAR**

---

## 📂 **ESTRUTURA DE DIRETÓRIOS**

### `core/` - Scripts centrais
```
core/
├── common.sh      # Funções comuns ✅ **MANTER**
├── menu.sh        # Menu interativo ❌ **REMOVER**
├── optional.sh    # Apps opcionais ❌ **REMOVER**
└── required.sh    # Apps obrigatórios ↻ **REORGANIZAR**
```

### `install/` - Scripts de instalação
```
install/
├── gnome-extensions.sh     # Extensões GNOME ↻ **MOVER**
├── theme.sh               # Tema WhiteSur ↻ **MOVER**
└── apps/
    ├── required/          # Apps essenciais ↻ **MOVER**
    │   ├── chrome.sh
    │   ├── gnome-extension-manager.sh
    │   ├── gnome-tweaks.sh
    │   ├── sendany.sh
    │   ├── typora.sh
    │   ├── upack-app.sh
    │   ├── vlc.sh
    │   ├── vscode.sh
    │   ├── wl-clipboard.sh
    │   ├── xournalpp.sh
    │   └── zoxide.sh
    └── optional/          # Apps opcionais ↻ **CLI APENAS**
        ├── btop.sh
        ├── dev-languages.sh    # ❌ **REMOVER** (fragmentado)
        ├── dev-tools.sh
        ├── discord.sh
        ├── mise-setup.sh       # ❌ **REMOVER** (duplicação)
        ├── obs-studio.sh
        ├── terminal-config.sh
        └── tlauncher.sh
```

### `config/` - Configurações do sistema
```
config/
├── alacritty/          # Config do terminal ✅ **MANTER**
├── github/             # Config SSH Git ✅ **MANTER**
├── gnome/              # Config GNOME ✅ **MANTER**
├── terminal/           # Config terminal ✅ **MANTER**
├── typora/             # Config Typora ✅ **MANTER**
└── vscode/             # Config VS Code ✅ **MANTER**
```

### `utils/` - Utilitários
```
utils/
├── flatpak.sh      # Utilitários Flatpak ✅ **MANTER**
├── fonts.sh        # Instalação de fontes ✅ **MANTER**
├── git.sh          # Utilitários Git ✅ **MANTER**
├── gum.sh          # Interface gum ↻ **SIMPLIFICAR**
└── mise.sh         # Gerenciador mise ❌ **REMOVER**
```

### `bin/` - Binários
```
bin/
├── upack           # CLI principal ↻ **REESCREVER**
└── upack-tui       # Interface TUI ↻ **MELHORAR**
```

### `assets/` - Recursos
```
assets/
├── banner.txt              # Banner ASCII ✅ **MANTER**
├── dark-background.png     # Wallpaper ✅ **MANTER**
├── ubuntu-neo-wallpaper.jpg # Wallpaper ✅ **MANTER**
├── fonts/                  # Fontes SF Pro ✅ **MANTER**
└── icons/                  # Ícones ✅ **MANTER**
```

### `docs/` - Documentação
```
docs/
├── COMPLETE_GUIDE.md       # Guia completo ↻ **ATUALIZAR**
├── QUICK_REFERENCE.md      # Referência rápida ↻ **ATUALIZAR**
├── README.md               # Readme dos docs ↻ **ATUALIZAR**
└── development/            # Docs de desenvolvimento ✅ **MANTER**
```

---

## ⚠️ **PROBLEMAS IDENTIFICADOS**

### 🚨 Arquivos para REMOÇÃO IMEDIATA:
1. `dev.sh` - Desenvolvimento, não produção
2. `install.sh` - Redundante com setup.sh
3. `start.sh` - Confunde com setup.sh
4. `core/menu.sh` - Menu não deve existir no setup
5. `core/optional.sh` - Apps opcionais só via CLI
6. `install/apps/optional/dev-languages.sh` - Fragmentado e com mise
7. `install/apps/optional/mise-setup.sh` - Duplicação desnecessária
8. `utils/mise.sh` - Fonte de conflitos

### 🔄 Arquivos para REORGANIZAÇÃO:
1. `setup.sh` → Reescrever completamente (automático)
2. `core/required.sh` → Mover lógica para `install/core/`
3. `install/theme.sh` → Mover para `install/core/theme-setup.sh`
4. `install/gnome-extensions.sh` → Integrar em `install/core/gnome-config.sh`
5. `bin/upack` → Reescrever com sistema de linguagens inteligente

### ✅ Arquivos para MANTER:
- Todos os arquivos de configuração em `config/`
- Assets e recursos em `assets/`
- Documentação em `docs/` (com atualizações)
- Scripts individuais de apps (reorganizar localização)

---

## 🎯 **NOVA ESTRUTURA PLANEJADA**

```
├── setup.sh              # ← ÚNICO PONTO DE ENTRADA
├── upack                  # ← CLI INTELIGENTE
├── install/
│   ├── core/              # ← SCRIPTS AUTOMÁTICOS
│   │   ├── dependencies.sh
│   │   ├── essential-apps.sh
│   │   ├── theme-setup.sh
│   │   ├── gnome-config.sh
│   │   ├── terminal-setup.sh
│   │   ├── fonts-install.sh
│   │   └── upack-cli.sh
│   └── languages/         # ← LINGUAGENS VIA CLI
│       ├── node.sh        # → NVM
│       ├── python.sh      # → Sistema/pyenv
│       ├── rust.sh        # → rustup
│       ├── java.sh        # → SDKMAN
│       └── go.sh          # → apt
├── config/               # ← MESMO QUE ATUAL
├── assets/               # ← MESMO QUE ATUAL
└── docs/                # ← ATUALIZADO
```

---

## 📊 **ESTATÍSTICAS**

- **Total de arquivos .sh atuais**: ~40+
- **Arquivos a remover**: 8
- **Arquivos a reescrever**: 5  
- **Arquivos a reorganizar**: 15+
- **Arquivos a manter**: 20+

**Meta: Reduzir complexidade em ~40% mantendo funcionalidade**
