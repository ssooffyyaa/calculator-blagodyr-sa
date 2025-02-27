# calculator-blagodyr-sa
## Описание проекта

Этот проект — простая программа-калькулятор, написанная на языке C.
Программа считывает арифметическое выражение из стандартного ввода, анализирует его и выводит результат.

Поддерживаемые операторы для работы с целыми числами:

+ — сложение
- — вычитание
* — умножение
/ — деление
( и ) — поддержка операций с приоритетом

## Сборка программы
Для сборки программы вам понадобится компилятор C — например, gcc или clang.

Инструкция по сборке:

Откройте терминал.
Перейдите в директорию с исходным кодом (main.c):
bash
Копировать
Редактировать
cd путь/к/папке/с/программой
Выполните следующую команду для компиляции:
bash
Копировать
Редактировать
gcc main.c -o calculator.exe
После этого в папке появится исполняемый файл с именем calculator.exe.

## Запуск программы

Для запуска программы используйте следующую команду:

bash
Копировать
Редактировать
./calculator.exe
Программа предложит вам ввести арифметическое выражение.
Введите выражение (например, 2 + 3 * (4 - 1)) и нажмите Enter.

Если программа ожидает завершения ввода, нажмите:

Linux/macOS: Ctrl + D
Windows (через WSL или Git Bash): Ctrl + Z и Enter
Результат выражения появится в терминале.

## Форматирование кода

Для форматирования кода по стилю WebKit можно использовать утилиту clang-format.

Инструкция по форматированию:

Убедитесь, что clang-format установлен. Если его нет, установите через пакетный менеджер:
Ubuntu/Debian:
bash
Копировать
Редактировать
sudo apt-get install clang-format
macOS (через Homebrew):
bash
Копировать
Редактировать
brew install clang-format
Чтобы отформатировать файл main.c, выполните команду:
bash
Копировать
Редактировать
clang-format -i main.c

## PGP PUBLIC KEY BLOCK


-----BEGIN PGP PUBLIC KEY BLOCK-----

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
0J++bDzeaW4t9DHOypfRgKB8PXgIxSuRjA==
=S/3P
-----END PGP PUBLIC KEY BLOCK-----
