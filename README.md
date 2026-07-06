# Setup Local

Ansible-плейбук для автоматической настройки Ubuntu 26.04 LTS как рабочей станции для Java-разработки и работы с локальными нейросетями.

## Быстрый запуск (одной командой)

```bash
curl -fsSL https://raw.githubusercontent.com/sergeloie/setup_local/main/setup.sh | bash
```

Скрипт автоматически:
- Проверит, что ОС - Ubuntu
- Установит Ansible (если не установлен)
- Скачает плейбук и запустит настройку

## Что устанавливается

| Программа | Назначение | Каталог |
|-----------|-----------|---------|
| Liberica JDK 25 | Java-разработка (full, с JavaFX) | `/usr/lib/jvm/bellsoft-java25-full-amd64` |
| Gradle 9.6.1 | Сборщик проектов | `/opt/gradle-9.6.1` |
| OpenIDE | IDE на базе IntelliJ IDEA CE | `/opt/openide` |
| Bruno | API-клиент | через apt |
| Apache JMeter 5.6.3 | Тестирование производительности | `/opt/apache-jmeter-5.6.3` |
| Docker CE | Контейнеризация | через apt |
| NVIDIA драйверы | GPU (если есть NVIDIA) | через apt |
| CUDA toolkit | GPU вычисления | через apt |
| Miniconda | Python-окружения | `~/miniconda3` |
| Node.js (LTS) | JavaScript-разработка | через apt |
| Ollama | Локальный сервер нейросетей | `/usr/local/bin/ollama` |
| LM Studio | GUI для нейросетей (опционально) | `~/Applications/LM-Studio.AppImage` |
| Hermes Agent | AI-ассистент (опционально) | скрипт в home |

## Установка вручную

### 1. Установите Ansible

```bash
sudo apt update
sudo apt install -y ansible
```

### 2. Скачайте плейбук

```bash
git clone https://github.com/your-repo/setup_local.git
cd setup_local
```

Или просто скачайте файл `playbook.yml`.

### 3. Запустите

```bash
ansible-playbook -i localhost, -c local playbook.yml -K
```

Флаг `-K` запросит пароль sudo (нужен для apt, Docker, драйверов).

## Конфигурация

Перед запуском можно изменить переменные в `playbook.yml` (раздел `vars`):

| Переменная | По умолчанию | Описание |
|------------|--------------|----------|
| `liberica_jdk_version` | `25` | Версия Java |
| `gradle_version` | `9.6.1` | Версия Gradle |
| `jmeter_version` | `5.6.3` | Версия JMeter |
| `install_ollama` | `true` | Устанавливать Ollama |
| `install_lmstudio` | `false` | Устанавливать LM Studio |
| `install_hermes_agent` | `true` | Устанавливать Hermes Agent |

## Повторный запуск

Плейбук безопасен для повторного запуска - он пропустит уже установленные компоненты.

## Требования

- Ubuntu 26.04 LTS (другие версии не тестировались)
- Подключение к интернету
- Права sudo
