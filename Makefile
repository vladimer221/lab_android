# Makefile для автоматизации сборки Flutter проекта

# Параметры
FLUTTER = flutter
PROJECT_DIR = .
BUILD_DIR = build

# Стандартные цели
.PHONY: clean get build run test

# Получить зависимости
get:
	$(FLUTTER) pub get

# Очистить проект
clean:
	$(FLUTTER) clean

# Сборка проекта
build:
	$(FLUTTER) build apk --release

# Запуск проекта
run:
	$(FLUTTER) run

# Тесты
test:
	$(FLUTTER) test
