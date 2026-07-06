#!/bin/bash
# setup.sh - быстрая установка рабочей станции разработчика
# Запуск: curl -fsSL https://raw.githubusercontent.com/your-repo/setup_local/main/setup.sh | bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Проверка ОС
check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ]; then
            error "Этот скрипт предназначен только для Ubuntu. Текущая ОС: $ID"
        fi
        info "Обнаружена ОС: $PRETTY_NAME"
    else
        error "Не удалось определить ОС. Скрипт работает только на Ubuntu."
    fi
}

# Проверка root/sudo
check_sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        error "Не запускайте скрипт от root. Используйте обычного пользователя с sudo."
    fi
    sudo -n true 2>/dev/null || error "Нужен доступ к sudo. Запустите: sudo -v"
}

# Установка Ansible
install_ansible() {
    if command -v ansible-playbook &> /dev/null; then
        info "Ansible уже установлен: $(ansible --version | head -n1)"
    else
        info "Устанавливаю Ansible..."
        sudo apt update -qq
        sudo apt install -y -qq ansible
        info "Ansible установлен: $(ansible --version | head -n1)"
    fi
}

# Скачивание playbook.yml
download_playbook() {
    WORK_DIR=$(mktemp -d)
    info "Рабочая директория: $WORK_DIR"

    PLAYBOOK_URL="https://raw.githubusercontent.com/your-repo/setup_local/main/playbook.yml"

    info "Скачиваю playbook.yml..."
    curl -fsSL "$PLAYBOOK_URL" -o "$WORK_DIR/playbook.yml" || error "Не удалось скачать playbook.yml"

    info "Playbook скачан в $WORK_DIR/playbook.yml"
}

# Запуск playbook
run_playbook() {
    info "Запускаю ansible-playbook..."
    echo ""
    echo "========================================"
    echo "  Начинается настройка рабочей станции"
    echo "  Будет запрошен пароль sudo"
    echo "========================================"
    echo ""

    ansible-playbook -i localhost, -c local "$WORK_DIR/playbook.yml" -K

    echo ""
    info "Настройка завершена!"
    echo ""
    info "Откройте новый терминал для подхвата переменных окружения."
    info "Если ставились NVIDIA-драйверы - перезагрузитесь."
}

# Очистка
cleanup() {
    if [ -d "$WORK_DIR" ]; then
        rm -rf "$WORK_DIR"
    fi
}

# Основной поток
main() {
    info "Запуск setup.sh - настройка рабочей станции разработчика"
    echo ""

    check_os
    check_sudo
    install_ansible
    download_playbook
    run_playbook
    cleanup

    echo ""
    info "Готово! Удачной разработки!"
}

trap cleanup EXIT
main "$@"
