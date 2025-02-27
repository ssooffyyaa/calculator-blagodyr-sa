#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define MAX_EXPR_LEN 1024

int is_float_mode = 0;

double parse_expression(const char **);
double parse_term(const char **);
double parse_factor(const char **);

void skip_whitespace(const char **expr) {
    while (isspace(**expr)) (*expr)++;
}

double parse_number(const char **expr) {
    char *end;
    if (is_float_mode) {
        double val = strtod(*expr, &end);
        *expr = end;
        return val;
    } else {
        long val = strtol(*expr, &end, 10);
        *expr = end;
        return (double)val;
    }
}

double parse_factor(const char **expr) {
    skip_whitespace(expr);
    if (**expr == '(') {
        (*expr)++;
        double result = parse_expression(expr);
        skip_whitespace(expr);
        if (**expr == ')') (*expr)++;
        return result;
    } else {
        return parse_number(expr);
    }
}

double parse_term(const char **expr) {
    double result = parse_factor(expr);
    while (1) {
        skip_whitespace(expr);
        if (**expr == '*') {
            (*expr)++;
            result *= parse_factor(expr);
        } else if (**expr == '/') {
            (*expr)++;
            double divisor = parse_factor(expr);
            if (divisor == 0) {
                fprintf(stderr, "Division by zero\n");
                exit(1);
            }
            result /= divisor;
        } else {
            break;
        }
    }
    return result;
}

double parse_expression(const char **expr) {
    double result = parse_term(expr);
    while (1) {
        skip_whitespace(expr);
        if (**expr == '+') {
            (*expr)++;
            result += parse_term(expr);
        } else if (**expr == '-') {
            (*expr)++;
            result -= parse_term(expr);
        } else {
            break;
        }
    }
    return result;
}

int main(int argc, char *argv[]) {
    if (argc > 1 && strcmp(argv[1], "--float") == 0) {
        is_float_mode = 1;
    }

    char expr[MAX_EXPR_LEN];
    if (!fgets(expr, MAX_EXPR_LEN, stdin)) {
        return 1;
    }

    const char *p = expr;
    double result = parse_expression(&p);

    if (is_float_mode) {
        printf("%.10g\n", result);
    } else {
        printf("%ld\n", (long)result);
    }

    return 0;
}
