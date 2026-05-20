# Скрипт установки окружения для синтеза на Yosys + Sky130
# Тестировалось на Linux Mint 21 (база Ubuntu 22.04 Jammy)


set -e

echo "=== Обновляем пакеты ==="
sudo apt update || true

echo ""
echo "=== Ставим Yosys, Graphviz и зависимости ==="
sudo apt install -y yosys graphviz python3-pip ca-certificates curl gnupg

echo ""
echo "=== Ставим Docker ==="
# Добавляем ключ и репозиторий Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2>/dev/null || true
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# ВАЖНО: на Mint используем UBUNTU_CODENAME, а не VERSION_CODENAME
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io || echo "Docker уже установлен или произошла ошибка, продолжаем..."

# Добавляем юзера в группу docker
sudo usermod -aG docker $USER

echo ""
echo "=== Ставим volare и скачиваем Sky130 PDK ==="
pip install volare --break-system-packages 2>/dev/null || pip install volare
volare enable 0fe599b2afb6708d281543108caf8310912f54af

echo ""
echo "=== Проверяем что всё встало ==="
echo -n "Yosys: "; yosys -V
echo -n "Graphviz: "; dot -V 2>&1
echo -n "Docker: "; docker --version 2>/dev/null || echo "не установлен"

# Ищем библиотеку Sky130
LIB_PATH=$(find ~/.volare -name "sky130_fd_sc_hd__tt_025C_1v80.lib" 2>/dev/null | head -1)
if [ -n "$LIB_PATH" ]; then
    echo "Sky130 lib: $LIB_PATH"
else
    echo "Sky130 lib: НЕ НАЙДЕНА, проверь установку volare"
fi

echo "  Установка завершена!"

