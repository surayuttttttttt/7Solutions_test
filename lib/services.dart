import 'package:flutter/material.dart';

class FiboController2 {
  List<int> totalFib = [];
  Map<int, Map<int, bool>> fiboMap = {};
  bool isLatestDeleted = false;
  int count = 40;

  Map<int, Map<int, bool>> generatedFibonacci() {
    for (var i = 0; i < count; i++) {
      totalFib.add(fibonacci(i));
    }

    Map<int, Map<int, bool>> indexedBoolMap =
        totalFib.asMap().map((key, value) => MapEntry(key, {value: false}));

    fiboMap = indexedBoolMap;

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
}
