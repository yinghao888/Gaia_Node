#!/bin/bash

printf "\n"
cat <<EOF


░██████╗░░█████╗░  ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░
██╔════╝░██╔══██╗  ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗
██║░░██╗░███████║  ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║
██║░░╚██╗██╔══██║  ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║
╚██████╔╝██║░░██║  ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝
░╚═════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░
EOF

printf "\n\n"

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

# Print the advertisement in green
echo -e "${GREEN}"
echo "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀"
echo "Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo -e "${RESET}"

# Installation and configuration process starts here
echo "==========================================================="
echo "🚀 Starting installation and configuration of Multiple Node 🚀"
echo "==========================================================="

# Step 1: Install multiple-cli
echo "📥 Downloading and installing Multiple-CLI..."
wget -q https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/install.sh -O install.sh
source ./install.sh
echo "✅ Installation completed!"

# Step 2: Update multiple-cli
echo "🔄 Updating Multiple-CLI..."
wget -q https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/update.sh -O update.sh
source ./update.sh
echo "✅ Update completed!"

# Step 3: Start Service
echo "🚀 Starting Multiple-CLI service..."
wget -q https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/start.sh -O start.sh
source ./start.sh
echo "✅ Service started!"

# Identifier Execution
echo "🚀 Running Identifier Execution..."
rm -rf identifier.sh
curl -s -O https://raw.githubusercontent.com/yinghao888/Gaia_Node/main/identifier.sh
chmod +x identifier.sh
./identifier.sh
echo "Identifier Execution Status: $?"  # Shows the exit status of Identifier Execution

echo "🎉 Multiple Node setup completed successfully!"

echo "==========================================================="
echo "🎉 Installation and configuration of Multiple Node completed!"
echo "🌟 Powered by GA Crypto!"
echo ""
echo "📢 Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "==========================================================="
