import subprocess

# Функция для запуска калькулятора
def run_calculator(expression: str):
    result = subprocess.run(
        ["./build/app.exe"],
        input=expression,
        text=True,
        capture_output=True
    )
    return result.returncode, result.stdout.strip()

# Тесты для проверки корректности вычислений
def test_addition():
    returncode, output = run_calculator("2 + 2")
    assert returncode == 0, "Ошибка выполнения программы"
    assert output.isdigit(), f"Ожидалось число, но получили: {output}"
    assert int(output) == 4, f"Ожидалось 4, но получили: {output}"

def test_subtraction():
    returncode, output = run_calculator("10 - 3")
    assert returncode == 0
    assert output.isdigit()
    assert int(output) == 7

def test_multiplication():
    returncode, output = run_calculator("3 * 3")
    assert returncode == 0
    assert output.isdigit()
    assert int(output) == 9

def test_division():
    returncode, output = run_calculator("8 / 2")
    assert returncode == 0
    assert output.replace('.', '', 1).isdigit()
    assert float(output) == 4.0

# Тест с ошибкой (например, деление на 0)
def test_division_by_zero():
    returncode, output = run_calculator("10 / 0")
    assert returncode != 0, "Программа должна завершиться с ошибкой при делении на 0"
