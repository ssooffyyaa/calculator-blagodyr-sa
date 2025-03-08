# Инструменты компиляции 
CC  ?= gcc
CXX ?= g++
AR  ?= ar

# Google Test root directory
GTEST_DIR ?= googletest/googletest

# Директории
SRC_DIR   ?= src
TESTS_DIR ?= tests
BUILD_DIR ?= build

APP_BUILD_DIR=$(BUILD_DIR)/app
TEST_BUILD_DIR=$(BUILD_DIR)/test

TEST_BUILD_DIR_APP_OBJS=$(TEST_BUILD_DIR)/app
TEST_BUILD_DIR_UNIT_TESTS_OBJS=$(TEST_BUILD_DIR)/unit-tests
TEST_BUILD_DIR_INTEGRATION_TESTS_OBJS=$(TEST_BUILD_DIR)/integration-tests

# Флаги компиляции
CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS += -g -Wall -Wextra -pthread
CFLAGS   += -g -Wall -Wextra -Wpedantic -Werror -std=c11
LDLIBS   += -lgtest -lgtest_main -pthread

# Поиск всех C файлов исходного кода
APP_SRCS := $(shell find $(SRC_DIR) -type f -name '*.c')

# Поиск всех C++ тестов
UNIT_TEST_SRCS := $(shell find $(TESTS_DIR)/unit -type f -name '*.cpp')
INTEGRATION_TEST_SRCS := $(shell find $(TESTS_DIR)/integration -type f -name '*.cpp')

# Пути к объектным файлам
APP_OBJS := $(patsubst $(SRC_DIR)/%.c, $(APP_BUILD_DIR)/%.o, $(APP_SRCS))
UNIT_TESTS_OBJS := $(patsubst $(TESTS_DIR)/unit/%.cpp, $(TEST_BUILD_DIR_UNIT_TESTS_OBJS)/%.o, $(UNIT_TEST_SRCS))
INTEGRATION_TESTS_OBJS := $(patsubst $(TESTS_DIR)/integration/%.cpp, $(TEST_BUILD_DIR_INTEGRATION_TESTS_OBJS)/%.o, $(INTEGRATION_TEST_SRCS))

# Создание необходимых директорий
$(shell mkdir -p $(APP_BUILD_DIR) $(TEST_BUILD_DIR_UNIT_TESTS_OBJS) $(TEST_BUILD_DIR_INTEGRATION_TESTS_OBJS))

################
# Основные цели #
################

all: $(BUILD_DIR)/app.exe $(BUILD_DIR)/unit-tests.exe $(BUILD_DIR)/integration-tests.exe

clean:
	rm -rf $(BUILD_DIR) venv

format:
	clang-format -i src/*.c tests/**/*.cpp
	@echo "The code is formatted in WebKit"

# Запуск приложения
run-int: $(BUILD_DIR)/app.exe
	@$<

run-float: $(BUILD_DIR)/app.exe
	@$< --float

# Запуск юнит-тестов
run-unit-tests: $(BUILD_DIR)/unit-tests.exe
	@$<

# Запуск интеграционных тестов
run-integration-tests: venv
	. venv/bin/activate && pytest tests/integration/

# Создание виртуального окружения и установка зависимостей
venv: venv/bin/activate

venv/bin/activate: 
	python3 -m venv venv
	. venv/bin/activate && pip install pytest
	@touch venv/bin/activate

#############
# Сборка приложения #
#############

# Компиляция исходников приложения
-include $(APP_OBJS:.o=.d)
$(APP_BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

# Линковка приложения
$(BUILD_DIR)/app.exe: $(APP_OBJS)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@

###############
# Сборка тестов #
###############

# Компиляция юнит-тестов
-include $(UNIT_TESTS_OBJS:.o=.d)
$(TEST_BUILD_DIR_UNIT_TESTS_OBJS)/%.o: $(TESTS_DIR)/unit/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -c $< -o $@

# Компиляция интеграционных тестов
-include $(INTEGRATION_TESTS_OBJS:.o=.d)
$(TEST_BUILD_DIR_INTEGRATION_TESTS_OBJS)/%.o: $(TESTS_DIR)/integration/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -c $< -o $@

# Линковка юнит-тестов с GoogleTest
$(BUILD_DIR)/unit-tests.exe: $(UNIT_TESTS_OBJS)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $^ -o $@ $(LDLIBS)

# Линковка интеграционных тестов с GoogleTest
$(BUILD_DIR)/integration-tests.exe: $(INTEGRATION_TESTS_OBJS)
	@mkdir -p $(BUILD_DIR)
	 $(CXX) $(CPPFLAGS) $(CXXFLAGS) $^ -o $@ $(LDLIBS)
