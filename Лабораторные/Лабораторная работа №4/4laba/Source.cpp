#include <iostream>
#include <cmath>
using namespace std;

extern "C" {
    float CalcIntegral(int n);  // Объявление ассемблерной функции
    float fun_el(float x);      // Функция f(x) = кубический корень из ln(x)
}

int main() {
    setlocale(LC_ALL, "Russian");
    int n;
    cout << "Введите количество интегралов: ";
    cin >> n;

    if (n <= 0) {
        cerr << "Количество должно быть позитивным!" << endl;
        return 1;
    }

    float result = CalcIntegral(n);  // Вызов ассемблерной функции
    cout << "Значения интегралов: " << result << endl;

    return 0;
}

// Функция f(x) = кубический корень из ln(x)
extern "C" float fun_el(float x) {
    if (x <= 0.0f) return 0.0f;  // Защита от ln(0) и отрицательных x
    return cbrt(log(x));         // cbrt - кубический корень
}