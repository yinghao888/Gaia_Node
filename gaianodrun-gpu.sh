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

##########################################################################################
#                                                                                        
#                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀                 
#                                                                                        
#   🌐 Join our revolution in decentralized networks and crypto innovation!               
#                                                                                        
# 📢 Stay updated:                                                                      
#     • Follow us on Telegram: https://t.me/GaCryptOfficial                             
#     • Follow us on X: https://x.com/GACryptoO                                         
##########################################################################################

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

# Print the advertisement using printf
printf "${GREEN}"
printf "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀\n"
printf "Stay connected for updates:\n"
printf "   • Telegram: https://t.me/GaCryptOfficial\n"
printf "   • X (formerly Twitter): https://x.com/GACryptoO\n"
printf "${RESET}"

# Installation and configuration process starts here
echo "==========================================================="
echo "🚀 Welcome to GA Crypto's Automated GaiaNet Node Installer 🚀"
echo "==========================================================="
echo ""
echo "🌟 Your journey to decentralized networks begins here!"
echo "✨ Follow the steps as the script runs automatically for you!"
echo ""

# Function to check if CUDA is installed
check_cuda_installed() {
    if command -v nvcc &> /dev/null; then
        echo "✅ CUDA is already installed."
        nvcc --version
        return 0
    else
        echo "❌ CUDA is not installed."
        return 1
    fi
}

# Function to install CUDA
install_cuda() {
    echo "📥 Installing CUDA..."
    sudo apt update -y
    sudo apt install -y nvidia-cuda-toolkit
    if command -v nvcc &> /dev/null; then
        echo "✅ CUDA installation successful!"
        nvcc --version
    else
        echo "❌ Error: CUDA installation failed!"
        exit 1
    fi
}

# Check if CUDA is installed, if not, install it
if ! check_cuda_installed; then
    install_cuda
fi

# Set up CUDA environment variables
echo "🔧 Configuring CUDA environment variables..."

CUDA_PATH="/usr/local/cuda"
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"
ZSHRC="$HOME/.zshrc"
PROFILE="$HOME/.profile"

EXPORT_LD_LIBRARY_PATH="export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:\$LD_LIBRARY_PATH"
EXPORT_PATH="export PATH=${CUDA_PATH}/bin:\$PATH"

# Function to add environment variables if not already set
add_to_shell_config() {
    local file="$1"
    if [ -f "$file" ]; then
        if ! grep -qxF "$EXPORT_LD_LIBRARY_PATH" "$file"; then
            echo "$EXPORT_LD_LIBRARY_PATH" >> "$file"
        fi
        if ! grep -qxF "$EXPORT_PATH" "$file"; then
            echo "$EXPORT_PATH" >> "$file"
        fi
    fi
}

# Add environment variables to common shell configuration files
add_to_shell_config "$BASHRC"
add_to_shell_config "$BASH_PROFILE"
add_to_shell_config "$ZSHRC"
add_to_shell_config "$PROFILE"

# Apply changes immediately without restart
export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:$LD_LIBRARY_PATH
export PATH=${CUDA_PATH}/bin:$PATH
source ~/.bashrc

echo "✅ CUDA environment variables configured successfully and applied immediately!"

# Install required system packages
echo "📦 Installing Common Required Packages..."
sudo apt update -y && sudo apt-get install libgomp1 -y

# Install GaiaNet node
echo "📥 Installing GaiaNet node..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda 12
status=$?

if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node installation successful!"
else
    echo "❌ Error: GaiaNet node installation failed!"
    exit 1
fi
echo "Status: $status"

# Add GaiaNet to PATH (repeated sections consolidated)
echo "🔗 Adding GaiaNet to system PATH..."
echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Initialize GaiaNet node with the specified configuration
echo "⚙️ Initializing GaiaNet node with the latest configuration..."
gaianet init --config https://raw.githubusercontent.com/yinghao888/Gaia_Node/main/config1.json
status=$?

if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node initialized successfully!"
else
    echo "❌ Error: Failed to initialize GaiaNet node!"
    echo "🔍 Checking if GaiaNet is in the PATH..."

    # Check if GaiaNet binary exists in /opt/gaianet/
    if [ -f "/opt/gaianet/gaianet" ]; then
        echo "✅ GaiaNet binary found in /opt/gaianet/. Adding it to PATH..."
        echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc
        source ~/.bashrc

        echo "🔄 Retrying initialization..."
        gaianet init --config https://raw.githubusercontent.com/yinghao888/Gaia_Node/main/config1.json
        retry_status=$?

        if [ $retry_status -eq 0 ]; then
            echo "✅ GaiaNet node initialized successfully on retry!"
        else
            echo "❌ Error: Initialization failed even after fixing PATH!"
            exit 1
        fi
    else
        echo "❌ GaiaNet binary not found in /opt/gaianet/!"
        echo "🚨 Please ensure GaiaNet is installed and accessible."
        exit 1
    fi
fi
echo "Status: $status"

# Start the GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet config --domain gaia.domains
gaianet start
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node started successfully!"
else
    echo "❌ Error: Failed to start GaiaNet node!"
    exit 1
fi
echo "Status: $status"

# Display GaiaNet node info
echo "🔍 Fetching GaiaNet node information..."
gaianet info
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node information fetched successfully!"
else
    echo "❌ Error: Failed to fetch GaiaNet node information!"
    exit 1
fi
echo "Status: $status"

# Closing message
echo ""
echo "==========================================================="
echo "🎉 Congratulations! Your GaiaNet node is successfully set up!"
echo ""
echo "🌟 This script was brought to you by GA Crypto!"
echo "   • Stay connected for the latest updates:"
echo "     Telegram: https://t.me/GaCryptOfficial"
echo "     X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "💪 Together, let's build the future of decentralized networks!"
echo "==========================================================="
