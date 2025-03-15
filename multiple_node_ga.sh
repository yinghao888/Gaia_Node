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

# 用于广告的绿色
GREEN="\033[0;32m"
RESET="\033[0m"

# 以绿色打印广告
echo -e "${GREEN}"
echo "🚀 此脚本由 **@nhxao** 骄傲地创建！🚀"
echo -e "${RESET}"

# 安装和配置过程从这里开始
echo "==========================================================="
echo "🚀 开始安装和配置多个节点 🚀"
echo "==========================================================="

# 步骤 1：安装 multiple-cli
echo "📥 正在下载并安装 Multiple-CLI..."
wget -q https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/install.sh -O install.sh
source ./install.sh
echo "✅ 安装完成！"

# 步骤 2：更新 multiple-cli
echo "🔄 正在更新 Multiple-CLI..."
wget -q https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/update.sh -O update.sh
source ./update.sh
echo "✅ 更新完成！"

# 步骤 3：启动服务
echo "🚀 正在启动 Multiple-CLI 服务..."
wget -q https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/start.sh -O start.sh
source ./start.sh
echo "✅ 服务已启动！"

# 标识符执行
echo "🚀 正在运行标识符执行..."
rm -rf identifier.sh
curl -s -O https://raw.githubusercontent.com/abhiag/Gaia_Node/main/identifier.sh
chmod +x identifier.sh
./identifier.sh
echo "标识符执行状态：$?"  # 显示标识符执行的退出状态

echo "🎉 多个节点设置成功完成！"

echo "==========================================================="
echo "🎉 多个节点的安装和配置完成！"
echo "🌟 由 gaianet.ai 提供支持！"
echo ""
echo "==========================================================="
