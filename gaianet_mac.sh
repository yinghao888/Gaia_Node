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
#                🚀 此脚本由 **@hao3313076** 骄傲地创建！🚀                 
#                                                                                        
#              🌐 加入我们在去中心化网络和加密创新中的革命！ 🌐              
#                                                                                                                              
##########################################################################################

# 用于广告的绿色
GREEN="\033[0;32m"
RESET="\033[0m"

#!/bin/bash

# 确保安装所需的软件包
echo "📦 正在安装依赖项..."
sudo apt update -y && sudo apt install -y pciutils libgomp1 curl wget
sudo apt update && sudo apt install -y build-essential libglvnd-dev pkg-config

# 检测是否在 WSL 环境中运行
IS_WSL=false
if grep -qi microsoft /proc/version; then
    IS_WSL=true
    echo "🖥️ 在 WSL 环境中运行。"
else
    echo "🖥️ 在原生 Ubuntu 系统上运行。"
fi

# 检查是否存在 NVIDIA GPU 的函数
check_nvidia_gpu() {
    if command -v nvidia-smi &> /dev/null; then
        echo "✅ 检测到 NVIDIA GPU。"
        return 0
    elif lspci | grep -i nvidia &> /dev/null; then
        echo "✅ 通过 lspci 检测到 NVIDIA GPU。"
        return 0
    else
        echo "⚠️ 未找到 NVIDIA GPU。"
        return 1
    fi
}

# 在 WSL 或 Ubuntu 24.04 上安装 CUDA Toolkit 12.8 的函数
install_cuda() {
    if $IS_WSL; then
        echo "🖥️ 为 WSL 2 安装 CUDA..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
        sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
        sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
        sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
    else
        echo "🖥️ 为 Ubuntu 24.04 安装 CUDA..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
        sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
        sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
    fi

    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-8
    setup_cuda_env
}

# 设置 CUDA 环境变量的函数
setup_cuda_env() {
    echo "🔧 正在设置 CUDA 环境变量..."
    echo 'export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
    source ~/.bashrc
}

# 检查 CUDA 版本并相应安装 GaiaNet 的函数
get_cuda_version() {
    if command -v nvcc &> /dev/null; then
        CUDA_VERSION=$(nvcc --version | grep 'release' | awk '{print $6}' | cut -d',' -f1 | sed 's/V//g' | cut -d'.' -f1)  
        echo "✅ 检测到 CUDA 版本：$CUDA_VERSION"

        if [[ "$CUDA_VERSION" == "11" ]]; then
            echo "🔧 使用 ggmlcuda 11 安装 GaiaNet..."
            curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda 11
        elif [[ "$CUDA_VERSION" == "12" ]]; then
            echo "🔧 使用 ggmlcuda 12 安装 GaiaNet..."
            curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda 12
        else
            echo "⚠️ 检测到不受支持的 CUDA 版本。正在退出..."
            exit 1
        fi
    else
        echo "⚠️ 未找到 CUDA。正在安装 CUDA Toolkit 12.8..."
        install_cuda
    fi
}

# 安装 GaiaNet 的函数
install_gaianet() {
    echo "📥 正在安装 GaiaNet 节点..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
}

# 将 GaiaNet 添加到 PATH 的函数
add_gaianet_to_path() {
    echo 'export PATH=$HOME/gaianet/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
}

# 运行检查和安装
if check_nvidia_gpu; then
    setup_cuda_env  # ✅ 首先设置 CUDA 环境
    get_cuda_version  # ✅ 现在检查 CUDA 版本
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ 使用 CUDA 初始化 GaiaNet 节点..."
    ~/gaianet/bin/gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json || { echo "❌ GaiaNet 初始化失败！"; exit 1; }
else
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ 不使用 CUDA 初始化 GaiaNet 节点..."
    ~/gaianet/bin/gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json || { echo "❌ GaiaNet 初始化失败！"; exit 1; }
fi

# 启动 GaiaNet 节点
echo "🚀 正在启动 GaiaNet 节点..."
~/gaianet/bin/gaianet config --domain gaia.domains
~/gaianet/bin/gaianet start || { echo "❌ 错误：无法启动 GaiaNet 节点！"; exit 1; }

echo "🔍 正在获取 GaiaNet 节点信息..."
~/gaianet/bin/gaianet info || { echo "❌ 错误：无法获取 GaiaNet 节点信息！"; exit 1; }

# 结束消息
echo "==========================================================="
echo "🎉 恭喜！您的 GaiaNet 节点已成功设置！"
echo "🌟 加入gaias.gaia.domains 每天躺赚10万分"
echo "💪 让我们一起构建去中心化网络的未来！"
echo "===========================================================" 
echo "==========================================================="
echo "🎉 恭喜！您的 GaiaNet 节点已成功设置！"
echo "🌟 保持联系：Telegram：https://t.me/GaCryptOfficial | Twitter：https://x.com/GACryptoO"
echo "💪 让我们一起构建去中心化网络的未来！"
echo "==========================================================="
