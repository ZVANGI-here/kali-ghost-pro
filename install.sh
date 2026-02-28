#!/bin/bash
echo "Installing KALI-GHOST PRO v1.1..."
sudo cp src/main.sh /usr/local/bin/kali-ghost-pro
sudo chmod +x /usr/local/bin/kali-ghost-pro

mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/kali-ghost-pro.desktop << EOF
[Desktop Entry]
Name=Kali-Ghost-Pro
Comment=OPSEC Pentest Dashboard
Exec=kali-ghost-pro
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Network;Security;
EOF

mkdir -p ~/.kali-ghost-pro
echo '{"theme":"dark"}' > ~/.kali-ghost-pro/config.json

echo "✅ Installed! Run: kali-ghost-pro"
