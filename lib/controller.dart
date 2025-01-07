// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiboController extends GetxController {
  RxList totalFib = [].obs;
  RxList typeA = [].obs;
  RxList typeB = [].obs;
  RxList typeC = [].obs;
  Map<int,int> fiboMap = {};

  getfib() {
    int count = 40;
    for (var i = 0; i < count; i++) {
      totalFib.add(fibonacci(i));
    }

    Map<int, int> indexedMap = totalFib.asMap().map(
          (index, value) => MapEntry(index, value),
        );

  
    fiboMap = indexedMap;
  }

  int fibonacci(int n) {
    if (n == 0 || n == 1) {
      return n;
    }

    return fibonacci(n - 1) + fibonacci(n - 2);
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

  void addFiboToList(int value) {
    if (value % 3 == 0) {
      print(typeA.toString());
      return typeA.add(value);
    } else if (value % 3 == 1) {
      print(typeB.toString());
      return typeB.add(value);
    } else if (value % 3 == 2) {
      print(typeC.toString());
      return typeC.add(value);
    } else {
      return;
    }
  }

  void clearAllLists() {
    typeA.clear();
    typeB.clear();
    typeC.clear();
    print('clear');
  }
}
