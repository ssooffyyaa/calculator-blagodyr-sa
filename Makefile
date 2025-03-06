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

# Флаги компиляции
CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS += -g -Wall -Wextra -pthread
CFLAGS   += -g -Wall -Wextra -Wpedantic -Werror -std=c11
LDLIBS   += -lgtest -lgtest_main -pthread

# Поиск всех C файлов исходного кода
APP_SRCS := $(shell find $(SRC_DIR) -type f -name '*.c')

# Поиск всех C++ тестов
TEST_SRCS := $(shell find $(TESTS_DIR) -type f -name '*.cpp')

# Пути к объектным файлам
APP_OBJS := $(patsubst $(SRC_DIR)/%.c, $(APP_BUILD_DIR)/%.o, $(APP_SRCS))
UNIT_TESTS_OBJS := $(patsubst $(TESTS_DIR)/%.cpp, $(TEST_BUILD_DIR_UNIT_TESTS_OBJS)/%.o, $(TEST_SRCS))

# Создание необходимых директорий
$(shell mkdir -p $(APP_BUILD_DIR) $(TEST_BUILD_DIR_UNIT_TESTS_OBJS))

################
# Основные цели #
################

all: $(BUILD_DIR)/app.exe $(BUILD_DIR)/unit-tests.exe

clean:
	rm -rf $(BUILD_DIR)

# Запуск приложения
run-int: $(BUILD_DIR)/app.exe
	@$<

run-float: $(BUILD_DIR)/app.exe
	@$< --float

# Запуск тестов
run-unit-tests: $(BUILD_DIR)/unit-tests.exe
	@$<

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

# Компиляция тестов
-include $(UNIT_TESTS_OBJS:.o=.d)
$(TEST_BUILD_DIR_UNIT_TESTS_OBJS)/%.o: $(TESTS_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -c $< -o $@

# Линковка тестов с GoogleTest
$(BUILD_DIR)/unit-tests.exe: $(UNIT_TESTS_OBJS)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $^ -o $@ $(LDLIBS)
