import 'package:flutter/material.dart';

class FiboController2 {
  Map<int, int> fiboMap = {};
  List<int> totalFib = [];
  Map<int, Map<int, bool>> fiboMap2 = {};
  bool isLatestDeleted = false;
  int count = 40;

  Map<int, int> generatedFibonacci() {
    for (var i = 0; i < count; i++) {
      totalFib.add(fibonacci(i));
    }

    Map<int, int> indexedMap = totalFib.asMap().map(
          (index, value) => MapEntry(index, value),
        );

    Map<int, Map<int, bool>> indexedBoolMap =
        totalFib.asMap().map((key, value) => MapEntry(key, {value: false}));

    print('index map bool $indexedBoolMap');

    fiboMap = indexedMap;

    fiboMap2 = indexedBoolMap;

    return fiboMap;
  }

  int fibonacci(int n) {
    if (n == 0 || n == 1) {
      return n;
    }

    return fibonacci(n - 1) + fibonacci(n - 2);
  }

  int getFiboType(int value) {
    if (value % 3 == 0) {
      return 1;
    } else if (value % 3 == 1) {
      return 2;
    } else if (value % 3 == 2) {
      return 3;
    } else {
      return 0;
    }
  }

  getFiboIcon(int value) {
    if (value % 3 == 0) {
      return Icons.circle;
    } else if (value % 3 == 1) {
      return Icons.square_outlined;
    } else if (value % 3 == 2) {
      return Icons.close;
    } else {
      return;
    }
  }

  Map<int, Map<String, dynamic>> generateFiboJson(int n) {
    Map<int, Map<String, dynamic>> fibonacciMap = {};
    int a = 0, b = 1;
    for (int i = 0; i <= n; i++) {
      fibonacciMap[i] = {
        "index": i,
        "value": a,
        "isActive": false,
      };
      int next = a + b;
      a = b;
      b = next;
    }

    return fibonacciMap;
  }
}
