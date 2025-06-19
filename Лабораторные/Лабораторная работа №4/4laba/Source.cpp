#include <iostream>
#include <cmath>
using namespace std;

extern "C" {
    float CalcIntegral(int n);  // ���������� ������������ �������
    float fun_el(float x);      // ������� f(x) = ���������� ������ �� ln(x)
}

int main() {
    setlocale(LC_ALL, "Russian");
    int n;
    cout << "������� ���������� ����������: ";
    cin >> n;

    if (n <= 0) {
        cerr << "���������� ������ ���� ����������!" << endl;
        return 1;
    }

    float result = CalcIntegral(n);  // ����� ������������ �������
    cout << "�������� ����������: " << result << endl;

    return 0;
}

// ������� f(x) = ���������� ������ �� ln(x)
extern "C" float fun_el(float x) {
    if (x <= 0.0f) return 0.0f;  // ������ �� ln(0) � ������������� x
    return cbrt(log(x));         // cbrt - ���������� ������
}