#!/usr/bin/env bash

set -e

TLAUNCHER_DIR="$HOME/.local/share/tlauncher"
DESKTOP_FILE="$HOME/.local/share/applications/tlauncher.desktop"
ICON_URL="https://cdn2.steamgriddb.com/icon/67baaa05759c5f8da208f540ff782a5f.png"
ICON_PATH="$TLAUNCHER_DIR/icon.png"
JAR_PATH="$TLAUNCHER_DIR/TLauncher.jar"
TLAUNCHER_ZIP_URL="https://dl2.tlauncher.org/f.php?f=files%2FTLauncher.v16.zip"

echo "📦 Instalando dependência: OpenJDK..."
sudo apt update
sudo apt install -y default-jre

echo "⬇️ Baixando TLauncher..."
mkdir -p "$TLAUNCHER_DIR"
cd "$TLAUNCHER_DIR"
wget -qO tlauncher.zip "$TLAUNCHER_ZIP_URL"
unzip -qq -o tlauncher.zip
rm tlauncher.zip

# Verificar se o .jar foi extraído corretamente
if [ ! -f "$JAR_PATH" ]; then
  echo "❌ Erro: TLauncher.jar não encontrado após extração."
  exit 1
fi

echo "🖼️ Baixando ícone..."
wget -qO "$ICON_PATH" "$ICON_URL"

echo "🖥️ Criando atalho de aplicativo..."
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=TLauncher
Comment=Launch Minecraft with TLauncher
Exec=java -jar "$JAR_PATH"
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Game;
EOF

chmod +x "$DESKTOP_FILE"
update-desktop-database ~/.local/share/applications || true

echo "✅ TLauncher instalado e disponível no menu de aplicativos."
